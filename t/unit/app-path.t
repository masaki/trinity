use Test::More tests => 9;
use Cwd qw(cwd);
use FindBin;
use Path::Class qw(dir file);

do {
    package TestApp;
    use Trinity::Class isa => 'Application';
};

{ # ENV
    my $home = dir $FindBin::Bin;

    local $ENV{TESTAPP_HOME} = $home->stringify;
    my $app = TestApp->new;

    is $app->home => $home, 'home ok';
    is $app->public => $home->subdir('public'), 'public ok';
    is $app->path_to('public/favicon.ico'), $home->file('public', 'favicon.ico'), 'path_to ok';
}

{ # INC
    my $home = dir $FindBin::Bin;

    local $INC{'TestApp.pm'} = $home->file('lib', 'TestApp.pm')->stringify;
    my $app = TestApp->new;

    is $app->home => $home, 'home ok';
    is $app->public => $home->subdir('public'), 'public ok';
    is $app->path_to('public/favicon.ico'), $home->file('public', 'favicon.ico'), 'path_to ok';
}

{ # Cwd
    my $home = dir cwd;

    my $app = TestApp->new;

    is $app->home => $home, 'home ok';
    is $app->public => $home->subdir('public'), 'public ok';
    is $app->path_to('public/favicon.ico'), $home->file('public', 'favicon.ico'), 'path_to ok';
}
