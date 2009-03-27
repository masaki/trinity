package Trinity::Types;

use strict;
use warnings;
use Mouse::Util::TypeConstraints;

subtype 'Trinity::Request'
    => as 'Object'
    => where { $_->isa('Trinity::Request') };

coerce 'Trinity::Request'
    => from 'Object'
    => via { $_->isa('Trinity::Request') ? $_ : Trinity::Request->new(%$_) };

subtype 'Trinity::Response'
    => as 'Object'
    => where { $_->isa('Trinity::Response') };

coerce 'Trinity::Response'
    => from 'Object'
    => via { $_->isa('Trinity::Response') ? $_ : Trinity::Response->new(%$_) };

no Mouse::Util::TypeConstraints;

1;

=head1 NAME

Trinity::Types

=head1 TYPES

=head2 Trinity::Request

=head2 Trinity::Response

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
