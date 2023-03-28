package TestG;

BEGIN {
    push @INC, "/var/www/gazprombank/test/";
};

use strict;
use CGI;

use TestG::DB;

sub handler {
	my $query = new CGI;

	print $query -> header(
		-CHARSET 	    => 'utf-8',
		-type	 	    => 'text/html',
		'Cache-Control' => "no-cache",
	);

	my $email;

	my $list = '';
	
	if ($query -> param('email')) {
	
		TestG::DB::connect();
	
		$email = $query -> param('email');

		my $GetList = TestG::DB::db_query(
			"SELECT
				message.created AS date_mark,
				message.str,
                message.int_id AS internal
			FROM log
				JOIN message ON message.int_id = log.int_id
			WHERE log.address = ?
            UNION ALL
            SELECT
				log.created AS date_mark,
				log.str,
                log.int_id AS internal
			FROM log
            WHERE log.address = ?
            ORDER BY internal, date_mark",
            $email, $email
		);
        
		my $count = 0;
		$list = qq{<table border="0" cellpadding="2" cellspacing="2" style="border: 1px solid black;">};
		while (my ($created, $str, $internal) = $GetList -> fetchrow()) {
			last if $count == 100;
			$count++;
			$list .= qq{<tr><td style="border-right:1px solid black;border-bottom: 1px solid black;">$created</td><td style="border-right:1px solid black;border-bottom: 1px solid black;">$str</td></tr>};
		}
		$list .= qq{</table>};

		my $found_rows = TestG::DB::db_query('select found_rows()') -> fetchrow();	

		if ($found_rows > 100) {
			$list .= qq{<div>Было найдено $found_rows строк. Показано первые 100</div>};
		}
	}
    
	my $header = qq{<html><head><title>Тест</title></head>}.
		qq{<body>}.
		qq{<form method="post">}.
		qq{<table border="0" cellpadding="2" cellspacing="2">}.
		qq{<tr><td>Введите email: </td><td><input type="text" name="email" value="$email"/></td><td><input type="submit" name="find" value="найти"/></td></tr>}.
		qq{</table></form>};

	my $footer = qq{</body></html>};

	print $header.$list.$footer;
}

1;
