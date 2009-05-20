use Test::More tests => 3;

do {
    package TestApp;
    use Trinity::Class isa => 'Application';

    package TestApp::Controller::Foo;
    use Trinity::Class isa => 'Controller';

    package TestApp::Controller::Bar;
    use Trinity::Class isa => 'Controller';
};

my $app = TestApp->new;
$app->setup_controllers;

ok $app->controller('Foo'), 'Controller::Foo ok';
ok $app->controller('Bar'), 'Controller::Bar ok';
is @{[ $app->controllers ]} => 2, 'has 2 controllers';
