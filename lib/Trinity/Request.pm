package Trinity::Request;

use Mouse;
use Mouse::Util::TypeConstraints;

subtype 'Trinity::Request'
    => as 'Object'
    => where { $_->isa('Trinity::Request') };

coerce 'Trinity::Request'
    => from 'Object'
    => via { $_->isa('Trinity::Request') ? $_ : Trinity::Request->new(%$_) };

extends 'HTTP::Engine::Request';

has 'action' => (
    is => 'rw',
);

no Mouse;
no Mouse::Util::TypeConstraints;

1;

=head1 NAME

Trinity::Request

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
