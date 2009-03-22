package Trinity::Controller::Role::Render;

use Mouse::Role;

sub display {
}

sub render {
    my ($self, @args) = @_;

    my %vars = @args;
    if (@args % 2) {
        my $thing = shift @args;
        %vars = @args;

        if (blessed $thing) { # TODO: does('Trinity::View')
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
