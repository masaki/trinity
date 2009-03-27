use Test::Base;

plan tests => 1*blocks;

do {
    package MyApp::Model::Foo;
    use Trinity::Class isa => 'Model';

    package MyApp::Model::Bar::Baz;
    use Trinity::Class isa => 'Model';

    package MyApp::View::Foo;
    use Trinity::Class isa => 'Model';

    package MyApp::View::Bar::Baz;
    use Trinity::Class isa => 'View';

    package MyApp::Controller::Foo;
    use Trinity::Class isa => 'Controller';

    package MyApp::Controller::Bar::Baz;
    use Trinity::Class isa => 'Controller';
};

do { 
    package MyApp::Web::Model::Quux;
    use Trinity::Class isa => 'Model';

    package MyApp::Web::View::Quux;
    use Trinity::Class isa => 'View';

    package MyApp::Web::Controller::Quux;
    use Trinity::Class isa => 'Controller';
};

run {
    my $block = shift;

    my $component = $block->component;

    my $instance = $component->new;
    is $instance->suffix => $block->suffix, "$component suffix ok";
}

__END__
===
--- component: MyApp::Model::Foo
--- suffix: Foo

===
--- component: MyApp::Model::Bar::Baz
--- suffix: Bar::Baz

===
--- component: MyApp::Web::Model::Quux
--- suffix: Quux

===
--- component: MyApp::View::Foo
--- suffix: Foo

===
--- component: MyApp::View::Bar::Baz
--- suffix: Bar::Baz

===
--- component: MyApp::Web::View::Quux
--- suffix: Quux

===
--- component: MyApp::Controller::Foo
--- suffix: Foo

===
--- component: MyApp::Controller::Bar::Baz
--- suffix: Bar::Baz

===
--- component: MyApp::Web::Controller::Quux
--- suffix: Quux
