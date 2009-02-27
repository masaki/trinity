use inc::Module::Install;
name 'Trinity';
all_from 'lib/Trinity.pm';

requires 'Mouse';
requires 'MouseX::Getopt';
requires 'namespace::clean';

requires 'HTTP::Engine';
requires 'HTTP::Router';
requires 'HTTP::Status';
requires 'Path::Class';
requires 'Pod::Usage';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'ok';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
