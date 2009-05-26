package Trinity::Controller;

use Mouse;

has 'app' => (
    is       => 'rw',
    isa      => 'Trinity::Application',
    weak_ref => 1,
);

sub suffix { [ $_[0]->meta->name =~ /::(Controller::.+)$/ ]->[0] }

has namespace => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my ($namespace) = $_[0]->meta->name =~ /::Controller::(.+)$/;
        $namespace =~ s!::!/!g;
        lc $namespace;
    },
);

no Mouse;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity::Controller

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
