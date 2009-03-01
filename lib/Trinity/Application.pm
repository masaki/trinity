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

{
    for my $comp ('model', 'view', 'controller') {
        $self->meta->add_method(
            $comp => sub {
                my ($self, $name) = @_;
                my $key = join '::', ucfirst($comp), $name;
                return $self->components->{$key};
            }
        );
    }
}

after 'setup' => sub { shift->setup_finished(1) };

sub setup {
    my $self = shift;

    $self->setup_config;
    $self->setup_logger;
    $self->setup_components;
    $self->setup_dispatcher;
}

sub setup_config {}
sub setup_logger {}

sub setup_components {
    my $self = shift;

    my @paths = qw/::Controller ::View ::Model/;
    my $locator = Module::Pluggable::Object->new(
        search_path => [ map { $self->meta->name . $_ } @paths ],
    );

    for my $component ($locator->plugins) {
        $self->load_component($component);
    }
}

sub setup_dispatcher {}

sub load_component {
    my ($self, $component) = @_;

    unless (Mouse::is_class_loaded($component)) {
        Mouse::load_class($component);
    }

    my $prefix = $self->meta->name;
    my $suffix = $component;
    $suffix =~ s/$prefix\:://;

    # TODO: apply config
    my $instance = $component->new;
    $self->components->{$suffix} = $instance;
}

no Mouse; __PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity::Application

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
