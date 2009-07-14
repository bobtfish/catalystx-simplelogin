
use Test::More;

eval { require Test::NoTabs; };
if ($@) { plan skip_all => 'Test::NoTabs not installed'; exit 0; }

Test::NoTabs::all_perl_files_ok();

