package Trinity::Controller::Mixin::Responder;

use Mouse::Role;
use HTTP::Status ':constants';

requires 'txn';

sub redirect {
    my ($self, $uri, %args) = @_;

    if ($uri) {
        $self->res->location($uri);
        $self->res->status($args{status} || HTTP_FOUND);
    }

    return $self->res->location;
}

sub sendfile {
    # TODO: not implemented yet
    my ($self, $file) = @_;
}

no Mouse::Role;

1;

=head1 NAME

Trinity::Controller::Mixin::Responder

=head1 METHODS

=head2 $controller->redirect($uri)

=head2 $controller->redirect($uri, status => $status)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
