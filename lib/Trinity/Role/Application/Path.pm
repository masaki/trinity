package Trinity::Role::Application::Path;

use Mouse::Role;
use MouseX::Types::Path::Class;
use Path::Class qw(file dir);
use Trinity::Utils;

has 'home' => (
    is         => 'rw',
    isa        => 'Path::Class::Dir',
    lazy_build => 1,
);

requires 'name';

sub path_to {
    my ($self, @path) = @_;

    my $path = dir($self->home, @path);
    return -d $path ? $path : file($path);
}

sub root { shift->path_to('root') }

sub _build_home {
    my $self = shift;

    my $home;
    $home ||= $self->_setup_home_from_env;
    $home ||= $self->_setup_home_from_path;
    $home ||= do {
        require Cwd;
        Cwd::getcwd();
    };

    return $home;
}

sub _setup_home_from_env {
    my $self = shift;

    return unless my $env = Trinity::Utils::env_value($self->name, 'HOME');

    my $home = dir($env)->absolute->cleanup;
    return -d $home ? $home : undef;
}

sub _setup_home_from_path {
    my $self = shift;

    # from Catalyst
    (my $file = sprintf '%s.pm', $self->name) =~ s{::}{/}g;

    return unless my $path = $INC{$file};
    $path =~ s/$file$//;

    my $home = dir($path)->absolute->cleanup;
    $home = $home->parent while $home->dir_list(-1) =~ /^b?lib$/;
    $home = $home->parent->parent if ($home->dir_list(-1, 1))[0] eq '..';

    return -d $home ? $home : undef;
}

no Mouse::Role;

1;

=head1 NAME

Trinity::Role::Application::Path

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
