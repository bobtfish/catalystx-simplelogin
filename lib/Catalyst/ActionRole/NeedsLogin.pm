package Catalyst::ActionRole::NeedsLogin;
use Moose::Role;
use namespace::autoclean;
 
use vars qw($VERSION);
$VERSION = '0.00001';

around execute => sub {
	my $orig = shift;
	my $self = shift;
	my ($controller, $c) = @_;
 
	if (!$c->user) {
		$c->controller('Login')->login_redirect($c);
	}
	else
	{
		return $self->$orig(@_);
	}
};

1;