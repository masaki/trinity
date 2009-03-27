use inc::Module::Install;
name 'Trinity';
all_from 'lib/Trinity.pm';

requires 'Mouse' => '0.19';
requires 'Mouse::Role';
requires 'Mouse::Meta::Class';
requires 'MouseX::Getopt';
requires 'MouseX::Types::Path::Class';

requires 'Path::Class';
requires 'Cwd';

requires 'HTTP::Engine';
requires 'HTTP::Router';
requires 'HTTP::Status';

requires 'Pod::Usage';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'Test::UseAllModules';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
