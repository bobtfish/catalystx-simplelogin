package TestAppRenderTT::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    WRAPPER => 'wrapper.tt',
    TEMPLATE_EXTENSION => '.tt',
);

1;

