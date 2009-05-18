package Trinity::Application;

use Any::Moose;
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

has 'components' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

{
    no strict 'refs';
    for my $keyword (qw/Model View Controller/) {
        *{ lc $keyword } = sub {
            my ($self, $name) = @_;
            return unless defined $name;

            my $fullname = join '::', $self->meta->name, $keyword, $name;
            return $self->load_component($fullname);
        };

        *{ lc($keyword) . 's' } = sub {
            my $self = shift;
            return grep { $_->meta->name =~ /::${keyword}::/ } values %{ $self->components };
        };
    }
}

sub load_component {
    my ($self, $fullname) = @_;

    if (exists $self->components->{$fullname}) {
        return $self->components->{$fullname};
    }

    eval { Any::Moose::load_class($fullname) } or return;
    my $prefix = $self->meta->name;
    (my $suffix = $fullname) =~ s/$prefix\:://;

    my $config = $self->config->{$suffix} || {};
    $self->components->{$fullname} = $fullname->new(app => $self, %$config);
}

sub setup_components {
    my $self = shift;

    my @paths = qw/::Controller ::View ::Model/;
    my $appname = $self->meta->name;
    my $locator = Module::Pluggable::Object->new(
        inner       => 1,
        search_path => [ map { $appname . $_ } @paths ],
    );

    for my $component ($locator->plugins) {
        $self->load_component($component);
    }
}

has 'dispatcher' => (
    is      => 'rw',
);

sub setup_dispatcher {
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
        $self->setup_layouts    if $self->can('setup_layouts');
        $self->setup_config     if $self->can('setup_config');
        $self->setup_logger     if $self->can('setup_logger');
        $self->setup_components if $self->can('setup_components');
        $self->setup_dispatcher if $self->can('setup_dispatcher');
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
