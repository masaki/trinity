package Trinity::Controller;

use Mouse;

extends 'Trinity::Component';

with qw(
    Trinity::Role::Controller::Render
    Trinity::Role::Controller::Response
);

sub suffix {
    my $self = shift;
    my $suffix;
    if ($self->meta->name =~ /^.+?::Controller::(.+)$/) {
        $suffix = $1;
    }
    return $suffix;
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

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
