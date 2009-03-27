package Trinity::Connection;

use Mouse;
use Trinity::Types;

has 'request' => (
    is     => 'rw',
    isa    => 'Trinity::Request',
    coerce => 1,
);

has 'response' => (
    is     => 'rw',
    isa    => 'Trinity::Response',
    coerce => 1,
);

has 'stash' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

has 'action' => (
    is  => 'rw',
    isa => 'Trinity::Action',
);

{ # alias
    *req = \&request;
    *res = \&response;
}

sub uri_for {
    # TODO: not implements yet
}

no Mouse;

1;

=head1 NAME

Trinity::Connection

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
