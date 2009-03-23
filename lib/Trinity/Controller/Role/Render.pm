package Trinity::Controller::Role::Render;

use Mouse::Role;

sub display {
    my ($self, $object, @args) = @_;

    my $body = $self->render(@args);
    return $bodt if $body;

    my %vars = @args;
    if (@args % 2) {
        shift @args;
        %vars = @args;
    }

    my $format = $vars{format} || $self->req->format || 'html';
    my $method = "to_${format}";
    return $object->can($method) ? $object->$method : undef;
}

sub render {
    my ($self, @args) = @_;

    my %vars = @args;
    if (@args % 2) {
        my $thing = shift @args;
        %vars = @args;

        # FIXME: is "Trinity::Component::View" good name ?
        if (blessed $thing and $thing->meta->does_role('Trinity::Component::View')) {
            # forward View
            return $thing->render(%vars);
        }
        else {
            $vars{template} = $thing;
        }
    }

    my $format = $vars{format} || $self->req->format || 'html';
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
