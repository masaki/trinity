package Trinity::Controller::Role::Render;

use Mouse::Role;

sub display {
    my ($self, $object, @args) = @_;

    if (my $body = $self->render(@args)) {
        return $body;
    }

    my (undef, %vars) = $self->_populate_args(@args);

    my $format = $self->_detect_format(%vars);
    my $method = "to_${format}";
    return $object->can($method) ? $object->$method : undef;
}

sub render {
    my ($self, @args) = @_;

    my ($view, %vars) = $self->_populate_args(@args);
    if ($view) {
        return $view->render(%vars);
    }

    my $format = $self->_detect_format(%vars);
    # forward View with provided
    # TODO: provided_view_for() is not implemented
    if (my $view = $self->provided_view_for($format)) {
        return $view->render(%vars);
    }

    my $template = $vars{template} || $self->req->path;
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
    $self->render_with_template($file, %vars);
}

sub partial {
    my ($self, $template, %vars) = @_;

    $template = do {
        my @path = split m!/! => $template;
        $path[-1] = "_$path[-1]";
        join '/' => @path;
    };
    my $format = $vars{format} || $self->req->format || 'html';
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
    $self->render_with_template($file, %vars);
}

sub _populate_args {
    my ($self, @args) = @_;
    my ($view, %vars) = (undef, @args);

    if (@args % 2) {
        my $thing = shift @args;
        %vars = @args;

        # FIXME: is "Trinity::Component::View" good name ?
        if (blessed $thing and $thing->meta->does_role('Trinity::Component::View')) {
            $view = $thing;
        }
        else {
            $vars{template} = $thing;
        }
    }

    return ($view, %vars);
}

sub _detect_format {
    my ($self, %vars) = @_;
    return $vars{format} || $self->req->format || 'html';
}

no Mouse::Role;

1;

=head1 NAME

Trinity::Controller::Role::Render

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
