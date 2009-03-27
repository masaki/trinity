package Trinity::Response;

use Mouse;
use HTTP::Status qw(HTTP_FOUND);

extends 'HTTP::Engine::Response';

sub location {
    my $self = shift;

    if (@_) {
        my $location = shift;
        $self->header('Location' => $location);
    }

    return $self->header('Location');
}

sub redirect {
    my $self = shift;

    if (@_) {
        my $location = shift;
        my $status   = shift || HTTP_FOUND;

        $self->location($location);
        $self->status($status);
    }

    return $self->location;
}

no Mouse;

1;

=head1 NAME

Trinity::Response

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
