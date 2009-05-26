package Trinity::Application;

use Mouse;
use MouseX::AttributeHelpers;
use Data::Util;
use Module::Pluggable::Object;
use HTTP::Engine::Response;
use HTTP::Router;
use Trinity::Context;
use Trinity::Utils;

with qw(
    Trinity::Application::Core::Path
    Trinity::Application::Core::Logger
);

has 'config' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

has 'router' => (
    is      => 'rw',
    isa     => 'HTTP::Router',
    lazy    => 1,
    default => sub { HTTP::Router->new },
);

has 'controllers' => (
    is         => 'rw',
    isa        => 'ArrayRef',
    metaclass  => 'Collection::Array',
    lazy       => 1,
    default    => sub { [] },
    auto_deref => 1,
    provides   => {
        push => 'register_controller',
    },
    curries    => {
        find => {
            find_controller => sub {
                my ($self, $body, $name) = @_;
                $body->($self, sub { $_[0]->meta->name =~ /::Controller::${name}$/ });
            },
        },
    },
);

has 'setup_finished' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

after 'setup' => sub { shift->setup_finished(1) };

sub setup {
    my $self = shift;

    unless ($self->setup_finished) {
        # build
        $self->home;
        $self->logger;

        $self->setup_config      if $self->can('setup_config');
        $self->setup_controllers if $self->can('setup_controllers');
        $self->setup_router      if $self->can('setup_router');
    }

    return $self;
}

sub setup_config { $_[0]->config }

sub setup_controllers {
    my $self = shift;

    my $locator = Module::Pluggable::Object->new(
        inner       => 1,
        search_path => [ $self->meta->name . '::Controller' ],
    );

    for my $class ($locator->plugins) {
        $self->load_controller($class);
    }
}

sub setup_router {
    my $self = shift;

    # exists router.pl
    my $file = $self->path_to('config', 'router.pl');
    if (-f $file) {
        local $@;
        my $router = eval qq{
            package @{[ $self->meta->name ]}::Router;
            use HTTP::Router::Declare;
            @{[ $file->slurp ]};
        };
        $self->router($router) if not $@ and defined $router;
    }
}

sub controller {
    my ($self, $name) = @_;

    if (my $controller = $self->find_controller($name)) {
        return $controller;
    }

    my $class = $self->meta->name . '::Controller::' . $name;
    return $self->load_controller($class);
}

sub load_controller {
    my ($self, $class) = @_;

    eval { Mouse::load_class($class) } or return;

    my $config = {
        # TODO: need controller class config
        #%{ $class->config },
        %{ $self->config->{$class->suffix} || {} },
    };

    my $controller = $class->new(app => $self, %$config);
    $self->register_controller($controller);

    return $controller;
}

sub handle_request {
    my ($self, $req) = @_;
    my $res = HTTP::Engine::Response->new;

    if (my $match = $self->router->match($req)) {
        my $controller = $self->controller($match->params->{controller});
        my $code = Data::Util::get_code_ref($controller->meta->name, $match->params->{action});

        my $c = Trinity::Context->new(
            app => $self,
            req => $req,
            res => $res,
        );
        $code->($controller, $c, $match->captures);

        if (my $error = $c->error->[-1]) {
            chomp $error;
            $self->log->error(qq'Caught exception in engine "$error"');
        }
    }
    else {
        $res->status(404);
        $res->body('404 Not Found');
    }

    return $res;
}

no Mouse;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity::Application

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
