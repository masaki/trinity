package Trinity::Component;

use Mouse;

has 'app' => (
    is       => 'rw',
    isa      => 'Trinity::Application',
    weak_ref => 1,
);

sub suffix {
    my $self = shift;
    my $suffix;
    if ($self->meta->name =~ /^.+?::(?:Model|View|Controller)::(.+)$/) {
        $suffix = $1;
    }
    return $suffix;
}

no Mouse;

1;

=head1 NAME

Trinity::Component

=head1 METHODS

=head2 suffix

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
