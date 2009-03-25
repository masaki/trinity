use Test::Base;

plan tests => 3*blocks;

do {
    package MyApp::Controller::Foo;
    use Trinity::Class isa => 'Controller';

    package MyApp::Controller::Bar::Baz;
    use Trinity::Class isa => 'Controller';

    package MyApp::Web::Controller::Quux;
    use Trinity::Class isa => 'Controller';
};

run {
    my $block = shift;

    my $controller = $block->name->new;
    is $controller->name => $block->name, 'name ok';
    is $controller->namespace => $block->namespace, 'namespace ok';
    is $controller->suffix => $block->suffix, 'suffix ok';
}

__END__
=== MyApp::Controller::Foo
--- namespace: foo
--- suffix: Foo

=== MyApp::Controller::Bar::Baz
--- namespace: bar/baz
--- suffix: Bar::Baz

=== MyApp::Web::Controller::Quux
--- namespace: quux
--- suffix: Quux
