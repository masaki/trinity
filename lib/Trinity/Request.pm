package Trinity::Request;

use Mouse;

extends 'HTTP::Engine::Request';

has 'action' => (
    is => 'rw',
);

no Mouse;

1;

=head1 NAME

Trinity::Request

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
