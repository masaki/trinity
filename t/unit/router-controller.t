use Test::More tests => 2;

do {
    package MyApp;
    use Trinity::Class isa => 'Application';

    package MyApp::Controller::Routes;
    use Trinity::Class isa => 'Controller::Routes';

    GET '/bar' => sub {};
    GET '/quux/{quux}', { quux => qr/^\d+$/ } => sub {};
};

my $app = MyApp->new->setup;

my $router = $app->router;
isa_ok $router => 'HTTP::Router';
is scalar @{[ $router->routes ]} => 2;
