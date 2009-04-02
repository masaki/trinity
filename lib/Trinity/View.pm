package Trinity::View;

use Mouse;
use MouseX::AttributeHelpers;

extends 'Trinity::Component';

has 'accept_formats' => (
    metaclass => 'Collection::Array',
    is        => 'rw',
    isa       => 'ArrayRef',
    default   => sub { [] },
    provides  => { find => 'accepts' },
);

no Mouse;

1;

=head1 NAME

Trinity::View

=head1 METHODS

=head2 accepts

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
