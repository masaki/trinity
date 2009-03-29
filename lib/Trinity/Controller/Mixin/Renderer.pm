package Trinity::Controller::Mixin::Renderer;

use Mouse::Role;
use HTTP::Status qw(:constants);

requires qw(app txn);

sub render {
    my ($self, @args) = @_;

    my %args = $self->_populate_args(@args);
    $args{format}   ||= $self->_format_for;
    $args{template} ||= $self->_template_for;

    # forward View#render
    if (my $view = $self->app->view_of($args{format})) {
        my $body = $view->render(%args);
        $self->txn->res->body($body);
        $self->txn->res->status($args{status} || HTTP_OK);
        return $body;
    }

    my @files = do {
        my $base = $self->app->path_to('templates', "$args{template}.$args{format}.*");
        glob $base;
    };
    # TODO: exceptionize
    unless (@files) {
        die "Not found template $args{template}.$args{format}.*";
    }

    # forward Template#render
    my $view = $self->app->view('Template');
    for my $file (@files) {
        next unless my $body = $view->render($file, %args);
        $self->txn->res->body($body);
        $self->txn->res->status($args{status} || HTTP_OK);
        return $body;
    }
}

sub display {
    my ($self, $object, @args) = @_;

    my %args = $self->_populate_args(@args);
    $args{format} ||= $self->_format_for;

    if (my $body = $self->render(%args)) {
        return $body;
    }

    my $method = "to_$args{format}";
    return unless $object->can($method);

    my $body = $object->$method(%args);
    $self->txn->res->body($body);
    $self->txn->res->status($args{status} || HTTP_OK);
    return $body;
}

sub partial {
    my ($self, $template, %args) = @_;

    $template = do {
        my @path = split m!/! => $template;
        $path[-1] = "_$path[-1]";
        join '/' => @path;
    };
    my $format = $self->_format_for($args{format});
    my $file = do {
        my @files;
        my $base = "${template}\.${format}\.";
        $self->app->path_to('templates')->recurse(
            callback => sub {
                my $file = shift;
                push @files, $file if -f $file and $file =~ /$base/;
            },
        );
        # TODO: templates selection
        $files[0];
    };
    # TODO: exceptionize
    unless ($file) {
        die "Not found template $template.$format.*";
    }

    # TODO: render_with_template() is not implemented
    $self->render_with_template($file, %args);
}

sub _populate_args {
    my $self = shift;
    return (@_ % 2 ? (template => shift, @_) : @_);
}

sub _format_for {
    return shift->txn->req->format || 'html';
}

sub _template_for {
    # TODO: use action for template
    return shift->txn->req->path;
}

no Mouse::Role;

1;

=head1 NAME

Trinity::Controller::Mixin::Renderer

=head1 METHODS

=head2 $controller->render()

=head2 $controller->render($template, %args)

=head2 $controller->render(%args)

=head2 $controller->display($object)

=head2 $controller->display($object, $template, %args)

=head2 $controller->display($object, %args)

=head2 $controller->partial($name, %args)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
