package Trinity::Role::Application::Logger;

use Mouse::Role;
use Log::Log4perl;
use Trinity::Utils;

requires 'path_to';

has 'logger' => (
    is         => 'rw',
    isa        => 'Log::Log4perl',
    lazy_build => 1,
    handles    => [qw(
        fatal
        error
        warn
        info
        debug
        is_fatal
        is_error
        is_warn
        is_info
        is_debug
    )],
);

sub _build_logger {
    my $self = shift;
    my $name = $self->meta->name;

    my $env   = lc Trinity::Utils::env_value($name, 'ENV') || 'development';
    my $level = $env eq 'production' ? 'INFO' : 'DEBUG';

    my $file  = $self->path_to('log', "${env}.log");
    $file->dir->mkpath unless -e $file->dir;

    my $category = $name;
    $category =~ s/::/\./g;

    my %spec = (
        "log4perl.category.$category" => "$level, Screen, File",

        'log4perl.appender.Screen'                          => 'Log::Log4perl::Appender::ScreenColoredLevels',
        'log4perl.appender.Screen.layout'                   => 'Log::Log4perl::Layout::PatternLayout',
        'log4perl.appender.Screen.layout.ConversionPattern' => '[%p] %m%n',

        'log4perl.appender.File'                          => 'Log::Log4perl::Appender::File',
        'log4perl.appender.File.filename'                 => $file->stringify,
        'log4perl.appender.File.utf8'                     => 1,
        'log4perl.appender.File.layout'                   => 'Log::Log4perl::Layout::PatternLayout',
        'log4perl.appender.File.layout.ConversionPattern' => '[%p] %m%n',
    );

    Log::Log4perl->init(\%spec); # mod_perl ok?
    return Log::Log4perl->get_logger($name);
}

no Mouse::Role;

1;

=head1 NAME

Trinity::Role::Application::Logger

=head2 METHODS

=head2 fatal

=head2 error

=head2 warn

=head2 info

=head2 debug

=head2 is_fatal

=head2 is_error

=head2 is_warn

=head2 is_info

=head2 is_debug

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
