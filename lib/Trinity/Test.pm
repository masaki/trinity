package Trinity::Test;

use Mouse;
use Test::More ();
use Data::Util;
use HTTP::Cookies;
use HTTP::Engine;
use HTTP::Request;
use URI;

sub import {
    my ($class, $appclass, %options) = @_;

    Mouse::load_class($appclass);

    my $app    = $appclass->new->setup;
    my $cookie = HTTP::Cookies->new;

    # taken from Ark::Test
    my $request = sub {
        my $req = (blessed $_[0] and $_[0]->isa('HTTP::Request')) ? $_[0] : HTTP::Request->new(@_);
        $req->uri(URI->new('http://localhost' . $req->uri->path));
        $req->header(Host => 'localhost');
        $cookie->add_cookie_header($req);

        my $res = HTTP::Engine->new(
            interface => {
                module          => 'Test',
                request_handler => sub { $app->handle_request(@_) },
            },
        )->run($req, env => \%ENV);

        $res->{_request} = $req;
        $cookie->extract_cookies($res);

        return $res;
    };

    my $get = sub { $request->(GET => @_)->content };

    my $test = Test::More->builder;

    my %methods = (
        request => $request,
        get     => $get,

        content_is   => sub { $test->is_eq($get->(shift), @_) },
        content_like => sub { $test->like($get->(shift), @_) },

        action_ok       => sub { $test->ok($request->(shift)->is_success, @_) },
        action_redirect => sub { $test->ok($request->(shift)->is_redirect, @_) },
        action_notfound => sub { $test->is_eq($request->(shift)->code => 404, @_) },
    );

    my $caller = caller;
    Data::Util::install_subroutine($caller, %methods);
}

no Mouse;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Trinity::Test

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
