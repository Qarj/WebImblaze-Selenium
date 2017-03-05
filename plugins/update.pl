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

my $this_script_folder_full = dirname(__FILE__);
chdir $this_script_folder_full;

copy 'WebInjectSelenium.pm', './../../WebInject/plugins/';