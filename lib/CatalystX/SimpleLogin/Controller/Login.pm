package CatalystX::SimpleLogin::Controller::Login;
use Moose;
use Moose::Autobox;
use MooseX::Types::Moose qw/ HashRef ArrayRef ClassName Object Str /;
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use CatalystX::SimpleLogin::Form::Login;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

with qw(
    CatalystX::Component::Traits
    Catalyst::Component::ContextClosure
);

has '+_trait_merge' => (default => 1);

__PACKAGE__->config(
    traits => [qw/
        WithRedirect
        RenderAsTTTemplate
        Logout
    /],
);

sub BUILD {
    my $self = shift;
    $self->login_form; # Build login form at construction time
}

has login_form_class => (
    isa => ClassName,
    is => 'rw',
    default => 'CatalystX::SimpleLogin::Form::Login',
);

has login_form_class_roles => (
    isa => ArrayRef[NonEmptySimpleStr],
    is => 'ro',
    default => sub  { [] },
);

has login_form => (
    isa => Object,
    is => 'ro',
    lazy_build => 1,
);

has login_form_args => (
    isa => HashRef,
    is => 'ro',
    default => sub { {} },
);

has login_form_stash_key => (
    is      => 'ro',
    isa     => Str,
    default => 'login_form',
);

has render_login_form_stash_key => (
    is      => 'ro',
    isa     => Str,
    default => 'render_login_form',
);

with 'MooseX::RelatedClassRoles' => { name => 'login_form' };

sub _build_login_form {
    my $self = shift;
    $self->apply_login_form_class_roles($self->login_form_class_roles->flatten)
        if scalar $self->login_form_class_roles->flatten; # FIXME - Should MX::RelatedClassRoles
                                                          #         do this automagically?
    return $self->login_form_class->new( $self->login_form_args );
}

sub render_login_form {
    my ($self, $ctx, $form) = @_;
    return $form->render;
}

sub login
    :Chained('/')
    :PathPart('login')
    :Args(0)
{
    my ($self, $ctx) = @_;
    my $form = $self->login_form;
    my $p = $ctx->req->parameters;
   
    if( $form->process(ctx => $ctx, params => $p) ){
        $ctx->res->redirect($self->redirect_after_login_uri($ctx));
        $ctx->extend_session_expires(999999999999)
            if $form->field( 'remember' )->value;
    }

    $ctx->stash(
        $self->login_form_stash_key        => $form,
        $self->render_login_form_stash_key => $self->make_context_closure(sub {
            my ($ctx) = @_;
            $self->render_login_form($ctx, $form);
        }, $ctx),
    );
}

sub redirect_after_login_uri {
    my ($self, $ctx) = @_;
    $ctx->uri_for('/');
}

1;

=head1 NAME

CatalystX::SimpleLogin::Controller::Login - Configurable login controller

=head1 SYNOPSIS

    # For simple useage exmple, see CatalystX::SimpleLogin, this is a
    # full config example
    __PACKAGE__->config(
        'Controller::Login' => {
            traits => 'WithRedirect', # Optional, enables redirect-back feature
            actions => {
                login => { # Also optional
                    PathPart => ['theloginpage'], # Change login action to /theloginpage
                },
            },
        },
    );

See L<CatalystX::SimpleLogin::Form::Login> for configuring the form.

=head1 DESCRIPTION

Controller base class which exists to have login roles composed onto it
for the login and logout actions.

=head1 ATTRIBUTES

=head1 METHODS

=head2 BUILD

Cause form instance to be built at application startup.

=head2 login

Login action

=head2 login_GET

Displays the login form

=head2 login_POST

Processes a submitted login form, and if correct, logs the user in
and redirects

=head2 redirect_after_login_uri

If you are using WithRedirect (i.e. it has been set in your config),
then you need to set 'redirect_after_login_uri' if you want something
other than the default, which is C<< $c->uri_for('/'); >>

=head2 render_login_form

Renders the login form. By default it just calls the form's render method. If
you want to do something different, like rendering the form with a template
through your view, this is the place to hook into.

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::ControllerRole::Login::WithRedirect>

=item L<CatalystX::SimpleLogin::Form::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

