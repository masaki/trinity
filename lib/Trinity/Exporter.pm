package Trinity::Exporter;

use Mouse;
use Mouse::Object;
use Mouse::Util;
use Mouse::Meta::Class;

sub import {
    my (undef, %args) = @_;

    my $class     = $args{class}     || caller(1);
    my $metaclass = $args{metaclass} || 'Mouse::Meta::Class';

    my @superclasses = @{ $args{superclasses} || [] };
    my @roles        = @{ $args{roles}        || [] };
    push @superclasses, 'Mouse::Object' unless @superclasses;

    my $caller = caller;

    {
        no strict 'refs';
        no warnings 'redefine';

        *{ $caller . '::import' } = sub {
            strict->import;
            warnings->import;
            utf8->import;

            my $meta = $metaclass->initialize($class);
            $meta->superclasses(@superclasses);
            # TODO: should use trunk version
            if (@roles) {
                Mouse::Util::apply_all_roles($class, @roles);
            }

            no strict 'refs';
            no warnings 'redefine';
            *{ $class . '::meta' } = sub { $meta };

            for my $keyword (@Mouse::EXPORT) {
                *{ $class . ':: ' . $keyword } = \&{ 'Mouse::' . $keyword };
            }
        };

        *{ $caller . '::unimport' } = sub {
            no strict 'refs';
            for my $keyword (@Mouse::EXPORT) {
                delete ${ $class . '::' }{$keyword};
            }
        };
    }
}

no Mouse;

1;

=head1 NAME

Trinity::Exporter

=head1 SYNOPSIS

    package Trinity;
    use Trinity::Exporter
        superclasses => ['Trinity::Application'];

    package Trinity::Controller;
    use Trinity::Exporter
        superclasses => ['Trinity::Component'];

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
