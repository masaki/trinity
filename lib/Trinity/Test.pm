package Trinity::Test;

use Mouse;
use Test::Builder;
use Data::Util;
use HTTP::Cookies;
use HTTP::Engine;
use HTTP::Request;
use URI;

our $Test = Test::Builder->new;

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

    my %methods = (
        request => $request,
        get     => $get,

        content_is => sub {
            my ($path, $content, $message) = @_;
            $Test->is_eq($get->($path), $content, $message);
        },
        content_like => sub {
            my ($path, $content, $message) = @_;
            $Test->like($get->($path), $content, $message);
        },

        action_ok => sub {
            my ($path, $message) = @_;
            $Test->ok($request->($path)->is_success, $message);
        },
        action_redirect => sub {
            my ($path, $message) = @_;
            $Test->ok($request->($path)->is_redirect, $message);
        },
        action_notfound => sub {
            my ($path, $message) = @_;
            $Test->is_eq($request->($path)->code, 404, $message);
        },
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
