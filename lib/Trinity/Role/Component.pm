package Trinity::Role::Component;

use Mouse::Role;

has 'app' => (
    is       => 'rw',
    isa      => 'Trinity::Application',
    weak_ref => 1,
    required => 1,
);

no Mouse::Role; 1;

=head1 NAME

Trinity::Role::Component

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
