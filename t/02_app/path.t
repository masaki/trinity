use Test::More tests => 3;
use FindBin;
use lib "$FindBin::Bin/app/lib";
use TestApp;

my $app = TestApp->new;

is $app->home => "$FindBin::Bin/app", 'home ok';
is $app->root => "$FindBin::Bin/app/root", 'root ok';
is $app->path_to('root/favicon.ico'), "$FindBin::Bin/app/root/favicon.ico", 'path_to ok';
