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

isa_ok $app->controller('Foo') => 'TestApp::Controller::Foo', 'Controller::Foo ok';
isa_ok $app->controller('Bar') => 'TestApp::Controller::Bar', 'Controller::Bar ok';
is @{[ $app->controllers ]} => 2, 'has 2 controllers';
