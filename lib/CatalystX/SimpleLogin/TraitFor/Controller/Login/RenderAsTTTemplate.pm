package CatalystX::SimpleLogin::TraitFor::Controller::Login::RenderAsTTTemplate;

use MooseX::MethodAttributes::Role;
use namespace::autoclean;

after 'login' => sub {
    my ( $self, $ctx ) = @_;

    my $rendered_form = $ctx->{stash}->{$self->login_form_stash_key}->render;
    $ctx->stash( template => \$rendered_form );
};

1;

=head1 NAME

CatalystX::SimpleLogin::TraitFor::Controller::Login::RenderAsTTTemplate

=head1 DESCRIPTION

Simple controller role to allow rendering a login form with no
template file. Sets the stash 'template' key to a string reference
containing the rendered form.

=head1 METHODS

=head2 after 'login'

  $ctx->stash( template => \$self->render_login_form($ctx, $result) );

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::ControllerRole::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut
