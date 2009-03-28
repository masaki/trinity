package Trinity::Controller;

use Mouse;
use Class::Inspector;
use Trinity::Transaction;

extends 'Trinity::Component';

has '+application' => (
    handles => ['logger', 'home', 'root', 'path_to', 'model', 'view']
);

has 'transaction' => (
    is       => 'rw',
    isa      => 'Trinity::Transaction',
    weak_ref => 1,
    handles  => [
        grep { $_ ne 'meta' } @{ Class::Inspector->functions('Trinity::Transaction') }
    ],
);

{ # alias
    no warnings 'once';
    *txn = \&transaction;
}

with qw(
    Trinity::Role::Controller::Render
    Trinity::Role::Controller::Response
);

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
