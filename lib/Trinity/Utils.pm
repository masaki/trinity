package Trinity::Utils;

use strict;
use warnings;

sub env_value {
    my ($class, $key) = @_;

    $class =~ s/::/_/g;
    $class = uc $class;
    $key = uc $key;

    my @prefixes = ($class, 'TRINITY');
    for my $prefix (@prefixes) {
        if (exists $ENV{"${prefix}_${key}"}) {
            return $ENV{"${prefix}_${key}"};
        }
    }

    return;
}

1;

=head1 NAME

Trinity::Utils

=head1 METHODS

=head2 env_value($class, $key)

Returns an environment value. If $class is 'MyApp' and $key is 'home',
this method check $ENV{MYAPP_HOME} and $ENV{TRINITY_HOME}.

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
