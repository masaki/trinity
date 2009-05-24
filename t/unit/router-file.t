use Test::More tests => 2;

do {
    package MyApp;
    use Trinity::Class isa => 'Application';
};

my $app = do {
    require FindBin;
    local $ENV{MYAPP_HOME} = "$FindBin::Bin/router-file";
    MyApp->new->setup;
};

my $router = $app->router;
isa_ok $router => 'HTTP::Router';
is scalar @{[ $router->routes ]} => 2;
