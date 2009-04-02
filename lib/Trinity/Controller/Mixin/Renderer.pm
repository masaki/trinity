package Trinity::Controller::Mixin::Renderer;

use Mouse::Role;
use PadWalker ();

requires qw(app txn);

sub render {
    my ($self, @args) = @_;

    my $thing = blessed $args[0] ? shift @args : undef;

    my %args = @args;
    $args{format} ||= $self->txn->req->format || 'html';
    $args{locals} ||= $self->_build_local_vars;

    # has thing (isa model or view)
    if (defined $thing) {
        if ($thing->isa('Trinity::View')) {
            return $thing->render(%args);
        }
        elsif ($thing->isa('Trinity::Model')) {
            my $method = "to_$args{format}";
            if ($thing->can($method)) {
                return $thing->$method(%args);
            }
        }
    }

    my @views = $self->app->views;
    if (my $view = [ grep { $_->accepts($args{format}) } @views ]->[0]) {
        # forward format-specific view
        return $view->render(%args);
    }

    my @templates = grep { $_->isa('Trinity::View::Templates') } @views;
    unless (@templates) {
        # TODO: exceptionize
        die 'Not found template view';
    }

    # TODO: use action for template
    $args{template} ||= $self->txn->req->path;
    $args{layouts}  ||= 'layouts/' . $self->namespace;

    # forward templates
    for my $view (@templates) {
        my $body = $view->render(%args);
        return $body if defined $body;
    }

    return;
}

sub _build_local_vars {
    my %peek = ( %{ PadWalker::peek_my(2) }, %{ PadWalker::peek_our(2) } );

    my %vars;
    while (my ($key, $value) = each %peek) {
        $key =~ s/^.//; # delete sigil
        $vars{$key} = ${$value};
    }

    return \%vars;
}

no Mouse::Role;

1;

=head1 NAME

Trinity::Controller::Mixin::Renderer

=head1 METHODS

=head2 $controller->render()

=head2 $controller->render(%args)

=head2 $controller->render($thing)

=head2 $controller->render($thing, %args)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
