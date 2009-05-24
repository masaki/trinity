package Trinity::Context;

use Mouse;

has 'app' => (
    is       => 'rw',
    isa      => 'Trinity::Application',
    required => 1,
);

has 'req' => (
    is       => 'rw',
    isa      => 'HTTP::Engine::Request',
    required => 1,
);

has 'res' => (
    is       => 'rw',
    isa      => 'HTTP::Engine::Response',
    required => 1,
);

has 'stash' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

sub uri_for {
    # TODO: not implements yet
}

no Mouse;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity::Context

=head1 METHODS

=head2 app

=head2 req

=head2 res

=head2 stash

=head2 uri_for

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
