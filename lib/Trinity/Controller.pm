package Trinity::Controller;

use Mouse;

sub _suffix {
    my ($suffix) = $_[0]->meta->name =~ /::(Controller::.+)$/;
    $suffix;
}

sub _namespace {
    my $namespace = lc $_[0]->_suffix;
    $namespace =~ s/^controller:://;
    $namespace =~ s!::!/!g;
    $namespace;
}

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
