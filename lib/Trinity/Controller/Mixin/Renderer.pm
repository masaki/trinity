package Trinity::Controller::Mixin::Renderer;

use Mouse::Role;
use PadWalker ();

requires qw(app txn namespace);

sub render {
    my ($self, @args) = @_;

    my $model = blessed $args[0] ? shift @args : undef;

    my %args = @args;
    unless (exists $args{locals}) {
        $args{locals} = $self->_build_local_vars;
    }
    unless (exists $args{format}) {
        $args{format} = $self->txn->req->format;
    }

    # has thing (isa model, really ?)
    if (defined $model and $model->isa('Trinity::Model')) {
        my $method = "to_$args{format}";
        if ($model->can($method)) {
            return $model->$method(%args);
        }
    }

    unless (exists $args{template}) {
        # Controller::Foo#bar -> foo/bar
        my $action = [ caller(1) ]->[3];
        $action =~ s/.+:://; 
        $args{template} = join '/', $self->namespace, $action;
    }
    unless (exists $args{layouts}) {
        # Controller::Foo -> layouts/foo
        $args{layouts} = 'layouts/' . $self->namespace;
    }

    # forward templates
    for my $view ($self->app->views) {
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

=head2 $controller->render($model)

=head2 $controller->render($model, %args)

Returns a rendered string

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
