#!/usr/bin/perl

# $Id$
# $Revision$
# $Date$

use strict;
use warnings;
use vars qw/ $VERSION /;

$VERSION = '0.0.1';

use File::Copy qw(copy), qw(move);
my $is_windows = $^O eq 'MSWin32' ? 1 : 0;

copy 'plugins/WebInjectSelenium.pm', '../WebInject/plugins/';

my $testfile_full = './../WebInject-Selenium/'.$ARGV[0];
print "Debug\n";
my $status = system slash_me('../WebInject/webinject.pl'), $testfile_full, "-o ./../../WebInject-Selenium/output/";


#------------------------------------------------------------------
sub slash_me {
    my ($_string) = @_;

    if ($is_windows) {
        $_string =~ s{/}{\\}g;
    } else {
        $_string =~ s{\\}{/}g;
    }

    return $_string;
}

