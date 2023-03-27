#!/usr/bin/perl

BEGIN {
    push @INC, "/var/www/gazprombank/test/";
};

use strict;

use lib '.';
use TestG::DB;
use Data::UUID;

##!! FIXME - не знаю как лучше сделать, поэтому просто жестко впишу директорию и название файла в переменную. По уму конечно нужно куда-то выносить.
my $directory = "/var/www/gazprombank/test/";
my $filename = "out";

TestG::DB::connect();

my $ug = Data::UUID->new;

my $hash;

open(FH, "<", $directory.$filename) || die "Error: $!";
while (<FH>) {
	#print $_, "\n";
	my $line = $_;

	$line =~ /(\w{6}-\w{6}-\w{2})/;
	my $int_id = $1;
	
	unless ($int_id) {
		#print $line, "\n";
		#next;
		$int_id = 'undefined';
	}
	
	if ($line =~ /<=/) {
		my ($date, $time, $id, $other_line);
		#print $line, "\n";
		$line =~ /(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})(.*?)$/;
		$date = $1;
		$time = $2;
		$other_line = $3;
		#print "other : ", $other_line, "\n";
		#print "date : ", $1, "\ttime : ", $2, "\n";
		if ($line =~ /id=(.*?)\s/) {
			#print "id : ", $1, "\n";
			$id = $1;
		} else {
			#print "no id\n";
			my $uuid = $ug->create();
			#print $ug->to_string($uuid), "\n";
			$id = $ug->to_string($uuid);
		}
		
		TestG::DB::db_query(
			"insert into message(id, created, str, int_id) values(?,?,?,?)",
			$id, $date." ".$time, $other_line, $int_id
		);
	} else {
		my ($date, $time, $email, $other_line);

		$line =~ /(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})(.*?)$/;
		$date = $1;
		$time = $2;
		$other_line = $3;

		#print $line, "\n";
		if ($line =~ / ([a-z0-9.\<\>]+\@[a-z0-9.]+\.[a-z\<\>]+) /) {
			#print "Email : ", $1, "\n\n";
			$email = $1;
		}
		
		$line =~ s/\s+/ /g;
		$line =~ s/^\s+//g;
		$line =~ s/\s+$//g;
		
		TestG::DB::db_query(
			"insert into log(created, str, address, int_id) values(?,?,?,?)",
			$date." ".$time, $other_line, $email, $int_id
		);
	}
}
close(FH);

=pod
for my $key (sort keys %$hash) {
	#print $key, "\t : ", $#{$hash -> {$key}}, "\n";
	#print $key, ":\n";
	my $count = 0;
	for (0..$#{$hash -> {$key}}) {
		
		#print $hash -> {$key} -> [$_], "\n";
		my $line = $hash -> {$key} -> [$_];
		#print $line, "\n";
		
		if ($line =~ /<=/) {
			#print $line, "\n";
			$count++;
			#print $count, "\n";
		}
	}
	
	if ($count > 0) {
		print $key, ":\n";
		print $hash -> {$key} -> [$_], "\n";
	}
}
=cut