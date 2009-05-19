use Test::Base;

plan tests => 2*blocks;

do {
    package MyApp::Controller::Foo;
    use Trinity::Class isa => 'Controller';

    package MyApp::Controller::Bar::Baz;
    use Trinity::Class isa => 'Controller';
};

do {
    package MyApp::Web::Controller::Quux;
    use Trinity::Class isa => 'Controller';
};

run {
    my $block = shift;

    my $controller = $block->controller;

    my $instance = $controller->new;
    is $instance->_suffix => $block->suffix, "$controller suffix ok";
    is $instance->_namespace => $block->namespace, "$controller namespace ok";
}

__END__
===
--- controller: MyApp::Controller::Foo
--- suffix: Controller::Foo
--- namespace: foo

===
--- controller: MyApp::Controller::Bar::Baz
--- suffix: Controller::Bar::Baz
--- namespace: bar/baz

===
--- controller: MyApp::Web::Controller::Quux
--- suffix: Controller::Quux
--- namespace: quux
