package Trinity::Class;

use Mouse;
use Mouse::Meta::Class;

sub import {
    my ($class, %args) = @_;

    strict->import;
    warnings->import;
    utf8->import;

    my $caller = caller;

    my @superclasses = ( ref $args{isa} ? @{ $args{isa} } : ($args{isa}) );
    for my $klass (@superclasses) {
        if ($klass =~ /^\+/) {
            $klass =~ s/^\+//;
        }
        else {
            $klass = "Trinity::${klass}";
        }
    }

    my $meta = Mouse::Meta::Class->initialize($caller);
    $meta->superclasses(@superclasses);

    {
        no strict 'refs';
        no warnings 'redefine';

        *{ $caller . '::meta' } = sub { $meta };

        for my $keyword (@Mouse::EXPORT) {
            *{ $caller . ':: ' . $keyword } = \&{ 'Mouse::' . $keyword };
        }
    }
}

sub unimport {
    my $caller = caller;

    no strict 'refs';
    for my $keyword (@Mouse::EXPORT) {
        delete ${ $caller . '::' }{$keyword};
    }
}

no Mouse;

1;

=head1 NAME

Trinity::Class

=head1 SYNOPSIS

    package MyApp;
    use Trinity::Class isa => 'Application';

    package MyApp::Controller::Foo;
    use Trinity::Class isa => 'Controller';

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
