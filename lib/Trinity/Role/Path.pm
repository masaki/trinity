package Trinity::Role::Path;

use Mouse::Role;
use MouseX::Types::Path::Class;
use Path::Class qw(file dir);

has 'home' => (
    is         => 'rw',
    isa        => 'Path::Class::Dir',
    lazy_build => 1,
);

sub path_to {
    my ($self, @path) = @_;

    require File::Spec;
    my $path = File::Spec->catfile($self->home, @path);
    return -d $path ? dir($path) : file($path);
}

sub _build_home {
    my $self = shift;

    my $home;
    $home ||= $self->_setup_home_from_env;
    $home ||= $self->_setup_home_from_document_root;
    $home ||= $self->_setup_home_from_path;
    $home;
}

sub _setup_home_from_env {
    my $self = shift;

    if (my $env = Trinity::Utils::env_value($self->meta->name, 'HOME')) {
        my $home = dir($env)->absolute->cleanup;
        return $home if -d $home;
    }

    return;
}

sub _setup_home_from_document_root {
    if (exists $ENV{DOCUMENT_ROOT} and exists $ENV{MOD_PERL}) {
        my $home = dir($ENV{DOCUMENT_ROOT})->absolute->cleanup;
        return $home if -d $home;
    }

    return;
}

sub _setup_home_from_path {
    my $self = shift;

    # from Catalyst
    (my $file = sprintf '%s.pm', $self->meta->name) =~ s{::}{/}g;

    if (my $inc_entry = $INC{$file}) {
        (my $path = $inc_entry) =~ s/$file$//;
        my $home = dir($path)->absolute->cleanup;
        $home = $home->parent while $home =~ /b?lib$/;

        if (-f $home->file("Makefile.PL") or -f $home->file("Build.PL")) {
            $home = $home->parent->parent if ($home->dir_list(-1, 1))[0] eq '..';
            return $home;
        }
    }

    # finally, current directory is home
    require Cwd;
    return Cwd::getcwd();
}

no Mouse::Role; 1;
