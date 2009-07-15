package Catalyst::ActionRole::NeedsLogin;
use Moose::Role;
use namespace::autoclean;

around execute => sub {
	my $orig = shift;
	my $self = shift;
	my ($controller, $c, @args) = @_;

	if (!$c->user) {
		$c->controller('Login')->login_redirect($c, @args);
	}
	else {
		return $self->$orig(@_);
	}
};

1;
