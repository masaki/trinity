package Trinity::Controller::Mixin::Renderer;

use Mouse::Role;

#requires 'req', 'path_to';

sub render {
    my ($self, @args) = @_;

    my %args = $self->_populate_args(@args);

    my $format = $self->_format_for($args{format});
    my $depth = $args{depth} || 1;

    # forward View with provided
    # TODO: provided_view_for() is not implemented
    if (my $view = $self->provided_view_for($format)) {
        return $view->render(%args);
    }

    my $template = $args{template} || $self->req->path;
    my $file = do {
        my @files;
        my $base = "${template}\.${format}\.";
        $self->path_to('templates')->recurse(
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

sub display {
    my ($self, $object, @args) = @_;

    if (my $body = $self->render(@args, depth => 2)) {
        return $body;
    }

    my %args = $self->_populate_args(@args);

    my $format = $self->_format_for($args{format});
    my $method = "to_${format}";
    return $object->can($method) ? $object->$method : undef;
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
        $self->path_to('templates')->recurse(
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
    my ($self, $format) = @_;
    return $format || $self->req->format || 'html';
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
