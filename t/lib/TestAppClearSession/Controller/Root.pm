
package TestAppClearSession::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'TestAppBase::Controller::Root' }

after index => sub {
    my ($self, $c) = @_;
    $c->res->body("BLARRRMOO");
};

sub setsess :Local
{
    my ($self, $ctx) = @_;
    $ctx->session->{session_var1_set} = 'someval1';
    $ctx->res->body('Set the session');
}

sub needsloginsetsess :Local :Does('NeedsLogin') 
{
    my ($self, $ctx) = @_;
    $ctx->session->{session_var2_set} = 'someval2';
    $ctx->res->body('Logged in and set the session');
}

sub viewsess :Local
{
    my ($self, $ctx) = @_;

    my $session_string = '';
    foreach ( keys %{ $ctx->session } )
    {
        next if $_ =~ /^\_\_/;
        $session_string .= $_ . '=' . $ctx->session->{$_} . ';'
    }
    $ctx->res->body('In the session:' .  $session_string . ':');
}


__PACKAGE__->meta->make_immutable;
