package Trinity::Script::Server;

use Mouse;
use Pod::Usage qw(pod2usage);
use Trinity::Engine;

with 'MouseX::Getopt';

has 'environment' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => 'development',
);

has 'host' => (
    is       => 'rw',
    isa      => 'Str',
    lazy    => 1,
    default  => 'localhost',
);

has 'port' => (
    is       => 'rw',
    isa      => 'Int',
    lazy    => 1,
    default  => 3000,
);

has 'appclass' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'restart' => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => 0
);

has 'help' => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => 0
);

before 'run' => sub {
    my $self = shift;

    if ($self->help) {
        pod2usage(-input => (caller(0))[1], -exitval => 1);
    }
}

sub run {
    my ($self, %args) = @_;

    my $engine = Trinity::Engine->new(
        environment => $self->environment,
        interface   => 'ServerSimple',
        host        => $self->host,
        port        => $self->port,
        restart     => $self->restart,
        appclass    => $self->appclass,
        %args,
    );
    $engine->run;
}

no Mouse; __PACKAGE__->meta->make_immutable;
