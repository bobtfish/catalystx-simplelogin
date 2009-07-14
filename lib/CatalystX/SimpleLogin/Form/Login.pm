package CatalystX::SimpleLogin::Form::Login;
use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler';
with 'HTML::FormHandler::Render::Simple';

has_field 'username' => ( type => 'Text' );
has_field 'password' => ( type => 'Password' );
has_field 'remember' => ( type => 'Checkbox' );
has_field 'submit'   => ( type => 'Submit', value => 'Login' );

__PACKAGE__->meta->make_immutable;

=head1 NAME

CatalystX::SimpleLogin::Form::Login - validation for the login form

=head1 DESCRIPTION

A L<HTML::FormHandler> form for the login form.

=head1 FIELDS

=over

=item username

=item password

=item remember

=back

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::ControllerRole::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

