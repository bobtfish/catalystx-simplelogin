package TestAppDBIC::Schema::Result::User;
use strict;
use warnings;
use base qw/DBIx::Class/;
__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table ('user');
__PACKAGE__->add_columns (
  id => { data_type => 'int', is_auto_increment => 1 },
  user_name => { data_type => 'varchar', }, # Note this is not the standard 'username' field used by simplelogin
  password => { data_type => 'varchar', },
);

__PACKAGE__->set_primary_key ('id');

1;
