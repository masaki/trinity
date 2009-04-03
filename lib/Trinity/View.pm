package Trinity::View;

use Mouse;

extends 'Trinity::Component';

has 'includes' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub { [ shift->app->path_to('templates') ] },
);

has 'extension' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'renderer' => (
    is         => 'rw',
    lazy_build => 1,
);

no Mouse;

1;

=head1 NAME

Trinity::View

=head1 METHODS

=head2 includes

=head2 extension

=head2 renderer

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
