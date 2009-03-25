package Trinity::Controller;

use Mouse;

extends 'Trinity::Component';

with qw(
    Trinity::Role::Controller::Render
    Trinity::Role::Controller::Response
);

no Mouse;

1;

=head1 NAME

Trinity::Controller

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
