package Trinity;

use 5.008_001;
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
    $meta->superclasses('Mouse::Object', 'Trinity::Application');

    Mouse->import;
}

sub unimport {
    Mouse->unimport;
}

no Mouse; __PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity - A Web Application Framework

=head1 SYNOPSIS

    package MyApp;
    use Trinity;

=head1 DESCRIPTION

Trinity is

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
