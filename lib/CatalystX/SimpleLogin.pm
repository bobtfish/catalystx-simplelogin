package CatalystX::SimpleLogin;
use Moose::Role;
use CatalystX::InjectComponent;
use namespace::autoclean;

our $VERSION = '0.07';

after 'setup_components' => sub {
    my $class = shift;
    CatalystX::InjectComponent->inject(
        into => $class,
        component => 'CatalystX::SimpleLogin::Controller::Login',
        as => 'Controller::Login'
    );
};

=head1 NAME

CatalystX::SimpleLogin - Provide a simple Login controller which can be reused

=head1 SYNOPSIS

    package MyApp;
    use Moose;
    use namespace::autoclean;

    use Catalyst qw/
        +CatalystX::SimpleLogin
        Authentication
        Session
        Session::State::Cookie
        Session::Store::File
    /;
    extends 'Catalyst';

    __PACKAGE__->config(
        'Plugin::Authentication' => { # Auth config here }
    );

   __PACKAGE__->config(
        'Controller::Login' => { # SimpleLogin config here }
   );

   __PACKAGE__->setup;

=head1 DESCRIPTION

CatalystX::SimpleLogin is an application class L<Moose::Role|role> which will
inject a L<Catalyst::Controller|controller>
which is an instance of L<CatalystX::SimpleLogin::Controller::Login> into your
application. This provides a simple login and logout page with the adition
of only one line of code and one template to your application.

=head1 REQUIREMENTS

=over

=item A Catalyst application

=item Working authentication configuration

=item Working session configuration

=item A view

=back

=head1 CUSTOMISATION

CatalystX::SimpleLogin is a prototype for CatalystX::Elements. As such, one of the goals
is to make it easy for users to customise the provided component to the maximum degree
possible, and also, to have a linear relationship between effort invested and level of
customisation achieved.

Three traits are shipped with SimpleLogin: WithRedirect, Logout, and RenderAsTTTemplate.
These traits are set in the config:

   __PACKAGE__->config(
        'Controller::Login' => {
            traits => [qw/ Logout WithRedirect RenderAsTTTemplate /],
            login_form_args => { # see the login form },
   );

=head1 COMPONENTS

=over

=item *

L<CatalystX::SimpleLogin::Controller::Login> - first point of call for customisation.
Override the action configs to reconfigure the paths of the login or logout actions.
Subclass to be able to apply method modifiers to run before / after the login or
logout actions or override methods.

=item *

L<CatalystX::SimpleLogin::TraitFor::Controller::Logout> - provides the C<logout> action
and associated methods. You can compose this manually yourself if you want just that
action.

This trait is set by default, but if you set another trait in your config, you
will have to include it.

=item *

L<CatalystX::SimpleLogin::TraitFor::Controller::Login::WithRedirect> - provides the C<login>
action with a wrapper to redirect to a page which needs authentication, from which the
user was previously redirected. Goes hand in hand with L<Catalyst::ActionRole::NeedsLogin>

=item *

L<CatalystX::SimpleLogin::TraitFor::Controller::Login::RenderAsTTTemplate> - sets
the stash variable 'template' to point to a string reference containing the
rendered template so that it's not necessary to have a login.tt template file.

=item *

L<CatalystX::SimpleLogin::Form::Login> - the L<HTML::FormHandler> form for the login form.

=item *

L<Catalyst::ActionRole::NeedsLogin> - Used to cause a specific path to redirect to the login
page if a user is not authenticated.

=back

=head1 TODO

Here's a list of what I think needs working on, in no particular order.

Please feel free to add to or re-arrange this list :)

=over

=item Fix extension documentation

=item Document all this stuff.

=item Examples of use / customisation in documentation

=item Fixing one uninitialized value warning in LoginRedirect

=item Disable the use of NeedsLogin ActionRole when WithRedirect is not loaded

=back

=head1 SOURCE CODE

    http://github.com/bobtfish/catalystx-simplelogin/tree/master

    git://github.com/bobtfish/catalystx-simplelogin.git

Forks and patches are welcome. #formhandler or #catalyst (irc.perl.org)
are both good places to ask about using or developing this code.

=head1 SEE ALSO

=over

=item *

L<Catalyst>

=item *

L<Moose> and L<Moose::Role>

=item *

L<MooseX::MethodAttributes::Role> - Actions compsed from L<Moose::Role|Roles>.

=item *

L<CatalystX::InjectComponent> - Injects the controller class

=item *

L<HTML::FormHandler> - Generates the login form

=item *

L<Catalyst::Plugin::Authentication> - Responsible for the actual heavy lifting of authenticating the user

=item *

L<Catalyst::Plugin::Session>

=item *

L<Catalyst::Controller::ActionRole> - Allows you to decorate actions with roles (E.g L<Catalyst::ActionRole::NeedsLogin|To force a redirect to the login page>)

=item *

L<CatalystX::Component::Traits> - Allows L<Moose::Role|roles> to be composed onto components from config

=back

=head1 AUTHORS

=over

=item Tomas Doran (t0m) C<< <bobtfish@bobtfish.net> >>

=item Zbigniew Lukasiak

=item Stephan Jauernick (stephan48) C<< <stephan@stejau.de> >>

=item Gerda Shank (gshank) C<< gshank@cpan.org >>

=item Florian Ragwitz C<< rafl@debian.org >>

=back

=head1 LICENSE

Copyright 2009 Tomas Doran. Some rights reserved.

This sofware is free software, and is licensed under the same terms as perl itself.

=cut

1;

