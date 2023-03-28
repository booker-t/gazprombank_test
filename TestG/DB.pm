package TestG::DB;

use strict;
use DBI;
use Carp;

our $dbh;

my $DBHost_master = "127.0.0.1";
my $DBPort_master = 3306;
my $DBName_master = 'mails';
my $DBLogin_master = 'game_rancho';
my $DMPWD_master = 'K4%hc75[fdre4';

sub connect {
  $dbh = DBI -> connect(
    "dbi:mysql:database=$DBName_master;host=$DBHost_master;port=$DBPort_master",
    $DBLogin_master,
    $DMPWD_master,
    {
      AutoCommit => 1,
      RaiseError => 1
    }
  ) or die $!;
  $dbh -> do("SET NAMES 'utf8'");
  $dbh -> do("SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'");
}

sub db_query {
  my $sql_query=shift;

  my $sth = $dbh -> prepare($sql_query);

  eval{$sth -> execute(@_)};
  Carp::croak($@) if $@;
  return $sth;
}

return 1;