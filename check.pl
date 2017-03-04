#!/usr/bin/perl

# $Id$
# $Revision$
# $Date$

use strict;
use warnings;
use vars qw/ $VERSION /;

$VERSION = '0.0.1';

use File::Copy qw(copy), qw(move);

copy 'plugins/WebInjectSelenium.pm', '../WebInject/plugins/';

my $testfile_full = './../WebInject-Selenium/'.$ARGV[0];

my $status = system 'perl ..\WebInject\webinject.pl', $testfile_full, "-o ./../../WebInject-Selenium/output/";