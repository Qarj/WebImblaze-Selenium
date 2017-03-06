#!/usr/bin/perl

# $Id$
# $Revision$
# $Date$

use strict;
use warnings;
use vars qw/ $VERSION /;

$VERSION = '0.0.3';

use File::Copy qw(copy), qw(move);
use File::Basename;
use POSIX qw(strftime);

my $this_script_folder_full = dirname(__FILE__);
chdir $this_script_folder_full;

my $source = 'WebInjectSelenium.pm';
my $dest = './../../WebInject/plugins/';
copy $source, $dest;

my @files = glob($dest.$source);
my $modified;
foreach my $file (@files) {
    $modified = strftime("%d/%m/%Y %H:%M:%S",localtime((stat ($file))[9]));
    print "$file [$modified]\n";
}

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
printf("Updated at %02d:%02d:%02d", $hour, $min, $sec); #HH:MM:SS
