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
        push => 'add_controller',
    },
    curries    => {
        find => {
            controller => sub {
                my ($self, $body, $shortname) = @_;
                $body->($self, sub { $_[0]->shortname eq $shortname });
            },
        },
    },
);

sub setup_controllers {
    my $self = shift;

    my $locator = Module::Pluggable::Object->new(
        inner       => 1,
        search_path => [ $self->meta->name . '::Controller' ],
    );

    for my $fullname ($locator->plugins) {
        $self->load_controller($fullname);
    }
}

sub load_controller {
    my ($self, $fullname) = @_;

    my $shortname = $fullname->shortname;
    if (my $controller = $self->controller($shortname)) {
        return $controller;
    }

    eval { Any::Moose::load_class($fullname) } or return;

    my $suffix = $fullname->suffix;
    my $config = $self->config->{$suffix} || {};

    my $controller = $fullname->new(app => $self, %$config);
    $self->add_controller($controller);

    return $controller;
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
