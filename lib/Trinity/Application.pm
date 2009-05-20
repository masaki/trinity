package Trinity::Application;

use Any::Moose;
use Any::Moose 'X::AttributeHelpers';
use Module::Pluggable::Object;
use Trinity::Utils;

with qw(
    Trinity::Application::Core::Path
    Trinity::Application::Core::Logger
);

has 'transaction' => (
    is       => 'rw',
    isa      => 'Trinity::Transaction',
    weak_ref => 1,
);

{ # alias
    no warnings 'once';
    *txn = \&transaction;
}

has 'config' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

sub setup_config {
    shift->config; # initialize
}

has 'router';

has 'controllers' => (
    is         => 'rw',
    isa        => 'ArrayRef',
    metaclass  => 'Collection::Array',
    lazy       => 1,
    default    => sub { [] },
    auto_deref => 1,
    provides   => {
        push => 'push_controller',
    },
    curries    => {
        find => {
            find_controller => sub {
                my ($self, $body, $name) = @_;
                my $controller = $self->meta->name . '::Controller::' . $name;
                $body->($self, sub { $_[0]->meta->name eq $controller });
            },
        },
    },
);

sub controller {
    my ($self, $name) = @_;
    $self->find_controller($name) || $self->load_controller($name);
}

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

sub load_controller {
    my ($self, $class) = @_;

    unless ($class =~ /@{[ $self->meta->name ]}/) {
        $class = $self->meta->name . '::Controller::' . $class;
    }
    eval { Any::Moose::load_class($class) } or return;

    my $config = {
        #%{ $class->config },
        %{ $self->config->{$class->_suffix} || {} },
    };

    my $controller = $class->new(app => $self, %$config);
    $self->register_controller($controller);

    return $controller;
}

sub register_controller {
    my ($self, $controller) = @_;

    $self->push_controller($controller);
    # TODO: not implemented yet
}

has 'setup_finished' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

after 'setup' => sub { shift->setup_finished(1) };

sub setup {
    my $self = shift;

    unless ($self->setup_finished) {
        $self->setup_config      if $self->can('setup_config');
        $self->setup_router      if $self->can('setup_router');
        $self->setup_controllers if $self->can('setup_controllers');
    }

    return $self;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity::Application

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
