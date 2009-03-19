package Trinity::Controller;

use Mouse;
use Mouse::Meta::Class;
use Mouse::Util;

sub import {
    my $class = shift;

    strict->import;
    warnings->import;
    utf8->import;

    my $caller = caller;

    my $meta = Mouse::Meta::Class->initialize($caller);
    $meta->superclasses('Mouse::Object');

    no strict 'refs';
    no warnings 'redefine';
    *{ $caller . '::meta' } = sub { $meta };

    for my $keyword (@Mouse::EXPORT) {
        *{ $caller . ':: ' . $keyword } = \&{ 'Mouse::' . $keyword };
    }

    Mouse::Util::apply_all_roles($meta, 'Trinity::Role::Component');
}

no Mouse; 1;

=head1 NAME

Trinity::Controller

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
