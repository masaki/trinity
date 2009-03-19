package Trinity::Engine;

use Mouse;
use HTTP::Engine;
use Trinity::Utils;

has 'environment' => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has 'interface' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => 'ServerSimple',
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

has 'application' => (
    is       => 'rw',
    isa      => 'Trinity::Application',
    required => 1,
    handles  => ['handle_request'],
);

has 'http_engine' => (
    is         => 'rw',
    isa        => 'HTTP::Engine',
    lazy_build => 1,
);

sub _build_environment {
    my $self = shift;

    my $env;
    $env ||= Trinity::Utils::env_value($self->application->meta->name, 'ENV');
    $env ||= 'development';
    $env;
}

sub _build_http_engine {
    my $self = shift;

    return HTTP::Engine->new(
        interface => {
            module => $self->interface,
            args   => {
                host => $self->host,
                port => $self->port,
            },
            request_handler => sub { $self->handle_request(@_) },
        },
    );
}

sub BUILDARGS {
    my ($self, %args) = @_;

    # application
    if (exists $args{appclass}) {
        my $appclass = delete $args{appclass};
        Mouse::load_class($appclass);
        $args{application} = $appclass->new;
    }

    return \%args;
}

sub run {
    my ($self, %args) = @_;

    unless ($self->application->setup_finished) {
        $self->application->setup;
    }

    # FIXME: Exception::Class ?
    my $code = sub { CORE::die('caught signal') };
    eval {
        local $SIG{INT}  = $code;
        local $SIG{QUIT} = $code;
        local $SIG{TERM} = $code;
        $self->engine->run;
    };
}

no Mouse; 1;

=head1 NAME

Trinity::Engine

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
