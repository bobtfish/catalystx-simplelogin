package CatalystX::SimpleLogin::Form::Login;
use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler';
use MooseX::Types::Moose qw/ HashRef /;
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;

has '+name' => ( default => 'login_form' );

has authenticate_args => (
    is        => 'ro',
    isa       => HashRef,
    predicate => 'has_authenticate_args',
);

has authenticate_realm => (
    is        => 'ro',
    isa       => NonEmptySimpleStr,
    predicate => 'has_authenticate_realm',
);

has 'login_error_message' => (
    is => 'ro',
    isa => NonEmptySimpleStr,
    required => 1,
    default => 'Wrong username or password',
);

foreach my $type (qw/ username password /) {
    has sprintf("authenticate_%s_field_name", $type) => (
        is => 'ro',
        isa => NonEmptySimpleStr,
        default => $type
    );
    # FIXME - be able to change field names in rendered form also!
}

has_field 'username' => ( type => 'Text', tabindex => 1 );
has_field 'password' => ( type => 'Password', tabindex => 2 );
has_field 'remember' => ( type => 'Checkbox', tabindex => 3 );
has_field 'submit'   => ( type => 'Submit', value => 'Login', tabindex => 4 );

sub validate {
    my $self = shift;

    my %values = %{$self->values}; # copy the values
    unless (
        $self->ctx->authenticate(
            {
                (map {
                    my $param_name = sprintf("authenticate_%s_field_name", $_);
                    ($self->can($param_name) ? $self->$param_name() : $_) => $self->values->{$_};
                }
                grep { ! /remember/ }
                keys %{ $self->values }),
                ($self->has_authenticate_args ? %{ $self->authenticate_args } : ()),
            },
            ($self->has_authenticate_realm ? $self->authenticate_realm : ()),
        )
    ) {
        $self->add_auth_errors;
        return;
    }
    return 1;
}

sub add_auth_errors {
    my $self = shift;
    $self->field( 'password' )->add_error( $self->login_error_message )
        if $self->field( 'username' )->has_value && $self->field( 'password' )->has_value;
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

=item L<CatalystX::SimpleLogin::Controller::Login>

=back

=head1 CUSTOMIZATION

By default, the params passed to authenticate() are 'username' and
'password'. If you need to use different names, then you'll need to
set the correct value(s) via login_form_args in the configuration.
The keys are 'authenticate_username_field_name' and/or
'authenticate_password_field_name'.

    __PACKAGE__->config(
        'Controller::Login' => {
            login_form_args => {
               authenticate_username_field_name => 'name',
               authenticate_password_field_name => 'password2',
            },
        },
    );

You can also change the way that the form is displayed by setting
attributes.  In MyApp.pm:

    __PACKAGE__->config(
        'Controller::Login' => {
            login_form_args => {
               login_error_message => 'Login failed',
               field_list => [
                   '+submit' => { value => 'Login' },
               ]
            }
        },
    );

Additional fields can be added:

   field_list => [
       'foo' => ( type => 'MyField' ),
       'bar' => { type => 'Text' },
   ]

Additional arguments to the authenticate call can be added:
If your user table has a column C<status> and you want only those with C<status = 'active'>to be able to log .in

    __PACKAGE__->config(
        'Controller::Login' => {
            login_form_args => { 
                authenticate_args => { status => 1 },
            },
        },
    };

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

