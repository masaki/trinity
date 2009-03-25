use Test::Base;

plan tests => 3*blocks;

do {
    package MyApp;
    use Trinity::Class isa => 'Application';

    package MyApp::Controller::Foo;
    use Trinity::Class isa => 'Controller';

    package MyApp::Controller::Bar::Baz;
    use Trinity::Class isa => 'Controller';
};

do {
    package MyApp::Web;
    use Trinity::Class isa => 'Application';

    package MyApp::Web::Controller::Quux;
    use Trinity::Class isa => 'Controller';
};

run {
    my $block = shift;

    my $app = $block->app->new;
    my $controller = $block->name->new(app => $app);
    is $controller->name => $block->name, 'name ok';
    is $controller->namespace => $block->namespace, 'namespace ok';
    is $controller->suffix => $block->suffix, 'suffix ok';
}

__END__
=== MyApp::Controller::Foo
--- app: MyApp
--- namespace: foo
--- suffix: Foo

=== MyApp::Controller::Bar::Baz
--- app: MyApp
--- namespace: bar/baz
--- suffix: Bar::Baz

=== MyApp::Web::Controller::Quux
--- app: MyApp::Web
--- namespace: quux
--- suffix: Quux
