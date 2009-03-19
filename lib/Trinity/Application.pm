package Trinity::Application;

use Mouse;
use Module::Pluggable::Object;

with 'Trinity::Role::Path';

has 'config' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

has 'components' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

has 'setup_finished' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

after 'setup' => sub { shift->setup_finished(1) };

sub setup {
    my $self = shift;

    $self->setup_config;
    $self->setup_logger;
    $self->setup_components;
    $self->setup_dispatcher;
}

sub setup_config {
    # TODO: not implemented yet
}

sub setup_logger {
    # TODO: not implemented yet
}

sub setup_components {
    my $self = shift;

    my @paths = qw/::Controller ::View ::Model/;
    my $appname = $self->meta->name;
    my $locator = Module::Pluggable::Object->new(
        search_path => [ map { $appname . $_ } @paths ],
    );

    for my $component ($locator->plugins) {
        $self->load_component($component);
    }
}

sub setup_dispatcher {
    # TODO: not implemented yet
}

sub load_component {
    my ($self, $fullname) = @_;

    if (exists $self->components->{$fullname}) {
        return $self->components->{$fullname};
    }

    unless (Mouse::is_class_loaded($fullname)) {
        Mouse::load_class($fullname);
    }

    my $prefix = $self->meta->name;
    (my $suffix = $fullname) =~ s/$prefix\:://;

    my $config = $self->config->{$suffix} || {};
    $self->components->{$fullname} = $fullname->new(app => $self, %$config);
}

{
    no strict 'refs';
    for my $keyword (qw/Model View Controller/) {
        *{ lc $keyword } = sub {
            my ($self, $name) = @_;
            return unless defined $name;

            my $fullname = join '::', $self->meta->name, $keyword, $name;
            return $self->load_component($fullname);
        };
    }
}

no Mouse; 1;

=head1 NAME

Trinity::Application

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
