package Trinity::Controller;

use Any::Moose;

has '_suffix' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { [ $_[0]->meta->name =~ /::(Controller::.+)$/ ]->[0] },
);

has '_namespace' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $namespace;
        if ($self->meta->name =~ /::Controller::(.+)$/) {
            $namespace = lc $1;
            $namespace =~ s!::!/!g;
        }
        return $namespace;
    },
);

no Any::Moose;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity::Controller

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
