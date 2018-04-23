#!/usr/bin/perl

# $Id$
# $Revision$
# $Date$

use strict;
use warnings;
use vars qw/ $VERSION /;

$VERSION = '0.0.4';

use File::Copy qw(copy), qw(move);
use File::Basename;
use POSIX qw(strftime);
use File::Path qw(make_path);

my $this_script_folder_full = dirname(__FILE__);
chdir $this_script_folder_full;

my $dest_folder_path = './../../WebInject/plugins/';

_copy_file('WebInjectSelenium.pm', $dest_folder_path);
make_path ($dest_folder_path.'blocker');
_copy_file('blocker/background.js', $dest_folder_path);
_copy_file('blocker/manifest.json', $dest_folder_path);
make_path ($dest_folder_path.'blocker/images');
_copy_file('blocker/images/Blocker_128.png', $dest_folder_path);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
printf("Updated at %02d:%02d:%02d", $hour, $min, $sec); #HH:MM:SS

sub _copy_file {
    my ($_source_file, $_dest_folder_path) = @_;

    my $_dest_file = $_dest_folder_path.$_source_file;

    copy $_source_file, $_dest_file;
    
    my @_files = glob($_dest_file);
    my $_modified;
    foreach my $_file (@_files) {
        $_modified = strftime("%d/%m/%Y %H:%M:%S",localtime((stat ($_file))[9]));
        print "$_file [$_modified]\n";
    }
    
}
