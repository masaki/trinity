package Trinity::Controller;

use Mouse;
use Class::Inspector;
use Trinity::Transaction;

extends 'Trinity::Component';

has '+application' => (
    handles => ['logger', 'home', 'root', 'path_to', 'model', 'view']
);

sub shortname {
    my $self = shift;
    my $shortname;
    if ($self->meta->name =~ /^.+?::Controller::(.+)$/) {
        $shortname = $1;
    }
    return $shortname;
}

sub namespace {
    my $self = shift;
    my $namespace;
    if ($self->meta->name =~ /^.+?::Controller::(.+)$/) {
        $namespace = lc $1;
        $namespace =~ s!::!/!g;
    }
    return $namespace;
}

no Mouse;

1;

=head1 NAME

Trinity::Controller

=head1 METHODS

=head2 transaction, txn

=head2 namespace

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
