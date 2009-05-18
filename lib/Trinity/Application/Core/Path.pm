package Trinity::Application::Core::Path;

use Any::Moose '::Role';
use Any::Moose 'X::Types::Path::Class';
use Cwd ();
use Path::Class::File ();
use Path::Class::Dir ();
use Trinity::Utils;

has 'home' => (
    is         => 'rw',
    isa        => 'Path::Class::Dir',
    lazy_build => 1,
);

sub path_to {
    my ($self, @path) = @_;

    my $path = Path::Class::Dir->new($self->home, @path);
    return -d $path ? $path : Path::Class::File->new($path);
}

sub _build_home {
    my $self = shift;

    my $home;
    $home ||= $self->_setup_home_from_env;
    $home ||= $self->_setup_home_from_path;
    $home ||= Cwd::getcwd();

    return $home;
}

sub _setup_home_from_env {
    my $self = shift;

    return unless my $env = Trinity::Utils::env_value($self->meta->name, 'HOME');

    my $home = Path::Class::Dir->new($env)->absolute->cleanup;
    return -d $home ? $home : undef;
}

sub _setup_home_from_path {
    my $self = shift;

    # from Catalyst
    (my $file = sprintf '%s.pm', $self->meta->name) =~ s{::}{/}g;

    return unless my $path = $INC{$file};
    $path =~ s/$file$//;

    my $home = Path::Class::Dir->new($path)->absolute->cleanup;
    $home = $home->parent while $home->dir_list(-1) =~ /^b?lib$/;
    $home = $home->parent->parent if ($home->dir_list(-1, 1))[0] eq '..';

    return -d $home ? $home : undef;
}

no Any::Moose '::Role';
1;

=head1 NAME

Trinity::Application::Core::Path

=head1 METHODS

=head2 $app->home

=head2 $app->root

=head2 $app->path_to(@path)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
