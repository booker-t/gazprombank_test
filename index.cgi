#!/usr/bin/perl

BEGIN {
    push @INC, "/var/www/gazprombank/test/";
};

use strict;
use TestG;

&TestG::handler();