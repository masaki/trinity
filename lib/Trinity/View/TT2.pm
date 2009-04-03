package Trinity::View::TT2;

use Mouse;
use Template;

extends 'Trinity::View';

has '+extension' => ( default => 'tt2' );

sub _build_renderer {
    my $self = shift;
    return Template->new({
        INCLUDE_PATH => $self->includes,
        ENCODING     => 'utf-8',
    });
}

sub _templatize {
    my ($self, $name, $format) = @_;
    return join '.', $name, $format, $self->extension;
}

sub render {
    my ($self, %args) = @_;

    my $format   = $args{format}   || $self->txn->req->format;
    my $template = $args{template} || $self->txn->action->namespace;
    $template = $self->_templatize($template, $format);

    my $vars = {
        %{ $self->txn->stash },
        %{ $args{locals} ? $args{locals} : {} },
    };

    my $options = {};
    if (exists $args{layouts} ) {
        $options->{PROCESS} = $self->_templatize($args{layouts}, $format)
            unless $args{layout};
    }
    else {
        my $name = 'layouts/' . $self->txn->action->path;
        $options->{PROCESS} = $self->_templatize($name, $format);
    }

    $self->renderer->process($template, $vars, \my $output, $options);
    return $output;
}

no Mouse;

1;

=head1 NAME

Trinity::View::TT2

=head1 SYNOPSIS

    package MyApp::View::TT2;
    use Trinity::Class isa => 'View::TT2';

    package MyApp::Controller::Foo;
    use Trinity::Class isa => 'Controlelr', with => ['Renderer'];

    sub show {
        my ($self, $args) = @_;

        my $body = $self->view('TT2')->render;
        $self->txn->res->status(200);
        $self->txn->res->body($body);
    }

=head1 METHODS

=head2 $view->render(%args)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
