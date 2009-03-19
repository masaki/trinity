package Trinity;

use 5.008_001;
use strict;
use warnings;
use utf8;
use Mouse;
use Mouse::Meta::Class;

our $VERSION = '0.01';

sub import {
    my $class  = shift;

    strict->import;
    warnings->import;
    utf8->import;

    my $caller = caller;

    my $meta = Mouse::Meta::Class->initialize($caller);
    $meta->superclasses('Trinity::Application');

    no strict 'refs';
    no warnings 'redefine';
    *{ $caller . '::meta' } = sub { $meta };

    for my $keyword (@Mouse::EXPORT) {
        *{ $caller . ':: ' . $keyword } = \&{ 'Mouse::' . $keyword };
    }
}

sub unimport {
    my $caller = caller;

    no strict 'refs';
    for my $keyword (@Mouse::EXPORT) {
        delete ${ $caller . '::' }{$keyword};
    }
}

no Mouse;

=head1 NAME

Trinity - A Web Application Framework

=head1 SYNOPSIS

    package MyApp;
    use Trinity;

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
