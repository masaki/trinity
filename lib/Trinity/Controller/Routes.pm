package Trinity::Controller::Routes;

use Mouse;

extends 'Trinity::Controller';

our @EXPORT = qw(GET);

my %ACTION_CACHE;

sub register_routes {
    my $self = shift;
    for my $action (@{ $ACTION_CACHE{$self->meta->name} ||= [] }) {
        $self->app->router->add_route(@$action);
    }
}

sub GET {
    my $caller = caller;

    my $code = ref $_[-1] eq 'CODE' ? pop : undef;
    return unless defined $code;

    my ($path, $conditions) = @_;
    $conditions ||= {};
    $conditions->{method} = 'GET';

    push @{ $ACTION_CACHE{$caller} ||= [] }, [
        $path,
        conditions => $conditions,
        params     => { code => $code },
    ];
}

no Mouse;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity::Controller::Routes

=head1 METHODS

=head2 register_actions

=head2 GET

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
