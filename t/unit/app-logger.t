use Test::More 'no_plan';
use FindBin;
use File::Path;

do {
    package TestApp;
    use Trinity::Class isa => 'Application';
};

BEGIN { mkpath "$FindBin::Bin/log" unless -d "$FindBin::Bin/log" }
END { rmtree "$FindBin::Bin/log" if -d "$FindBin::Bin/log" }

sub app {
    local $ENV{TESTAPP_HOME} = $FindBin::Bin;
    return TestApp->new->setup;
}

{ # development
    my $env = 'development';
    local $ENV{TESTAPP_ENV} = $env;
    my $logger = app->logger;

    ok $logger->is_fatal;
    ok $logger->is_error;
    ok $logger->is_warn;
    ok $logger->is_info;
    ok $logger->is_debug;

    $logger->debug($env);
    ok(-s "$FindBin::Bin/log/$env.log" > 0);
}

{ # test
    my $env = 'test';
    local $ENV{TESTAPP_ENV} = $env;
    my $logger = app->logger;

    ok $logger->is_fatal;
    ok $logger->is_error;
    ok $logger->is_warn;
    ok $logger->is_info;
    ok $logger->is_debug;

    $logger->debug('test');
    ok -s "$FindBin::Bin/log/$env.log" > 0;
}

{ # production
    my $env = 'production';
    local $ENV{TESTAPP_ENV} = $env;
    my $logger = app->logger;

    ok $logger->is_fatal;
    ok $logger->is_error;
    ok $logger->is_warn;
    ok $logger->is_info;
    ok !$logger->is_debug, 'production is not debug mode';

    $logger->debug($env);
    is -s "$FindBin::Bin/log/$env.log" => 0, 'production is not debug logging';
}
