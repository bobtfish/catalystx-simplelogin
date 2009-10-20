package CatalystX::SimpleLogin::Form::Login;
use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler';
#with 'HTML::FormHandler::Render::Simple';
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;

has '+name' => ( default => 'login_form' );

has 'login_error_message' => (
    is => 'ro',
    isa => NonEmptySimpleStr,
    required => 1,
    default => 'Wrong username or password',
);

has_field 'username' => ( type => 'Text' );
has_field 'password' => ( type => 'Password' );
has_field 'remember' => ( type => 'Checkbox' );
has_field 'submit'   => ( type => 'Submit', value => 'Login' );

sub validate {
    my $self = shift;

    my %values = %{$self->values}; # copy the values
    delete $values{remember};
    unless ($self->ctx->authenticate(\%values)) { 
        $self->add_auth_errors;
        return;
    }
    return 1;
}

sub add_auth_errors {
    my $self = shift;
    $self->field( 'password' )->add_error( $self->login_error_message ) if $self->field( 'username' )->has_value && $self->field( 'password' )->has_value ;
}

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

=item submit

=back

=head1 METHODS

=over

=item validate

=item add_auth_errors

=back

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::ControllerRole::Login>

=back

=head1 CUSTOMIZATION

If the password and username fields have different names in your
authentication, set them using the field's 'accessor' attribute.
You can also change the way that the form is displayed by setting
attributes.  In MyApp.pm:

    __PACKAGE__->config(
        'Controller::Login' => {
            login_form_args => {
               login_error_message => 'Login failed',
               field_list => {
                   '+username' => { accessor => 'user_name' },
                   '+submit' => { value => 'Login' },
               }
            }
        },
    );

Additional fields can be added:

   field_list => {
       'foo' => ( type => 'MyField' ),
       'bar' => { type => 'Text' },
   }

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

