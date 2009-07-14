package Catalyst::ActionRole::NeedsLogin;
use Moose::Role;
use namespace::autoclean;

=head1 NAME

Catalyst::ActionRole::NeedsLogin

=head1 SYNOPSIS

In a Catalyst controller:

   sub some_method :Local :Does('NeedsLogin') {
       my ($self, $c) = @_;
       ....... 
   }

=cut

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
