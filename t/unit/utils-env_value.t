use Test::More tests => 4;
use Trinity::Utils;

my $foo = 'foo';
my $bar = 'bar';

local $ENV{TRINITY_FOO} = $foo;
is Trinity::Utils::env_value('MyApp', 'FOO') => $foo;

local $ENV{MYAPP_FOO} = $bar;
is Trinity::Utils::env_value('MyApp', 'FOO') => $bar;

is Trinity::Utils::env_value('MyApp::Web', 'BAZ') => undef;
local $ENV{MYAPP_WEB_BAZ} = $baz;
is Trinity::Utils::env_value('MyApp::Web', 'BAZ') => $baz;
