package Trinity::Role::Controller::Response;

use Mouse::Role;
use HTTP::Status ':constants';

requires 'res';

sub redirect {
    my ($self, $uri, %args) = @_;

    if ($uri) {
        my $status = $args{status} || HTTP_FOUND;

        $self->res->header(Location => $status);
        $self->res->status($status);
    }

    return $self->res->header('Location');
}

no Mouse::Role;

1;

=head1 NAME

Trinity::Role::Controller::Response

=head1 METHODS

=head2 $controller->redirect($uri)

=head2 $controller->redirect($uri, status => $status)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
