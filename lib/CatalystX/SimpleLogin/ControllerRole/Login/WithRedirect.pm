package CatalystX::SimpleLogin::ControllerRole::Login::WithRedirect;
use MooseX::MethodAttributes ();
use Moose::Role -traits => 'MethodAttributes';

with 'CatalystX::SimpleLogin::ControllerRole::Login';

around 'redirect_after_login_uri' => sub { 
		my ($orig, $self, $c) = @_;
		$c->uri_for('/'.$c->session->{redirect_to_after_login} || $self->$orig($c));
	};

sub login_redirect()
{
	my ($self, $c) = @_;
	$c->flash->{error_msg} = 'You need to login to view this page!';
	$c->session->{redirect_to_after_login} =  $c->request->path;
	$c->response->redirect($c->uri_for('/login'));
}
1;

