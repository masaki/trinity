use Test::More tests => 3;

do {
    package TestApp;
    use Trinity::Class isa => 'Application';

    package TestApp::Controller::Foo;
    use Trinity::Class isa => 'Controller';

    package TestApp::Controller::Bar;
    use Trinity::Class isa => 'Controller';

#    package TestApp::View::Baz;
#    use Trinity::Class isa => 'View';
};

my $app = TestApp->new;
$app->setup_controllers;

#ok !$app->model('404::NotFound'), 'no model';
ok $app->controller('Foo'), 'Controller::Foo ok';
ok $app->controller('Bar'), 'Controller::Bar ok';
#ok $app->view('Baz'), 'View::Baz ok';

#is scalar($app->models) => 0, 'not exists models';
#is scalar($app->views) => 1, 'has 1 view';
is @{[ $app->controllers ]} => 2, 'has 2 controllers';

#is scalar(keys %{ $app->components }) => 3, 'has 3 components';
