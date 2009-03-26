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

    my $controller = $block->controller->new;

    is $controller->namespace => $block->namespace, 'namespace ok';
    is $controller->suffix => $block->suffix, 'suffix ok';
}

__END__
===
--- controller: MyApp::Controller::Foo
--- namespace: foo
--- suffix: Foo

===
--- controller: MyApp::Controller::Bar::Baz
--- namespace: bar/baz
--- suffix: Bar::Baz

===
--- controller: MyApp::Web::Controller::Quux
--- namespace: quux
--- suffix: Quux
