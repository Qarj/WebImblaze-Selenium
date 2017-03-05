#!/usr/bin/perl

# $Id$
# $Revision$
# $Date$

use strict;
use warnings;
use vars qw/ $VERSION /;

$VERSION = '0.0.2';

use File::Copy qw(copy), qw(move);

copy 'plugins/WebInjectSelenium.pm', '../WebInject/plugins/';