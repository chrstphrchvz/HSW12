#! /usr/bin/env perl
##################################################################################
#                                    HSW12                                       #
##################################################################################
# file:    hsw12asm.pl                                                           #
# author:  Dirk Heisswolf                                                        #
# purpose: HSW12 Command Line Assembler                                          #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12asm.pl - HSW12 Command Line Assembler

=head1 SYNOPSIS

 hsw12asm.pl <src files> -L <library pathes> -D <defines: name=value or name>

=head1 REQUIRES

perl5.005, hsw12_asm, File::Basename, FindBin, Data::Dumper

=head1 DESCRIPTION

This script is a command line frontend to the HSW12 Assembler.

=head1 METHODS

=over 4

=item hsw12.pl <src files> -L <library pathes> -D <defines: name=value or name>

 Starts the HSW12 Assembler. 
 This script reads the following arguments:
     1. src files:      source code files(*.s)
     2. library pathes: directories to search for include files
     3. defines:        assembler defines

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Feb 9, 2003

 initial release

=item V00.01 - Apr 2, 2003

 -added "-s28" and "-s19" command line options

=item V00.02 - Apr 29, 2003

 -making use of the new "verbose mode"

=item V00.03 - Sep 21, 2009

 -made script more platipus friendly

=item V00.04 - Jun 8, 2010

 -truncate all output files

=item V00.05 - Jan 19, 2010

 -support for incremental compiles

=item V00.06 - Feb 14, 2013

 -S-Record files will be generated in the source directory

=cut

#################
# Perl settings #
#################
use 5.005;
use warnings;
use strict;
use File::Basename;
use FindBin qw($RealBin);
use Data::Dumper;
use lib $RealBin;
require hsw12_asm;

###############
# global vars #
###############
our @src_files         = ();
our @lib_files         = ();
our %defines           = ();
our $output_path       = ();
our $prog_name         = "";
our $arg_type          = "src";
our $srec_format;
our $srec_data_length;
our $srec_add_s5;
our $srec_alignment;
# Suppress bogus warning:
# "Name hsw12_asm::%s used only once: possible typo"
{
    no warnings 'once';
    $srec_format       = $hsw12_asm::SREC_DEF_FORMAT;
    $srec_data_length  = $hsw12_asm::SREC_DEF_DATA_LENGTH;
    $srec_add_s5       = $hsw12_asm::SREC_DEF_ADD_S5;
    $srec_alignment    = $hsw12_asm::SREC_DEF_ALIGNMENT;
}
our $symbols           = {};
our $code              = {};

##########################
# read command line args #
##########################
#printf "parsing args: count: %s\n", $#ARGV + 1;
foreach my $arg (@ARGV) {
    #printf "  arg: %s\n", $arg;
    if ($arg =~ /^\s*\-L\s*$/i) {
	$arg_type = "lib";
    } elsif ($arg =~ /^\s*\-D\s*$/i) {
	$arg_type = "def";
    } elsif ($arg =~ /^\s*\-s19\s*$/i) {
	$srec_format = "S19";
	if ($srec_data_length > 32) {
	    $srec_data_length = 32;
	}
    } elsif ($arg =~ /^\s*\-s28\s*$/i) {
	$srec_format      = "S28";
    } elsif ($arg =~ /^\s*\-/) {
	#ignore
    } elsif ($arg_type eq "src") {
	#sourcs file
	push @src_files, $arg;
    } elsif ($arg_type eq "lib") {
	#library path
	if ($arg !~ /\/$/) {$arg = sprintf("%s%s", $arg, $hsw12_asm::PATH_DEL);}
	unshift @lib_files, $arg;
        $arg_type          = "src";
    } elsif ($arg_type eq "def") {
	#precompiler define
	if ($arg =~ /^\s*(\w+)=(\w+)\s*$/) {
	    $defines{uc($1)} = $2;
	} elsif ($arg =~ /^\s*(\w+)\s*$/) {
	    $defines{uc($1)} = "";
	}
        $arg_type          = "src";
    }
}

###################
# print help text #
###################
if ($#src_files < 0) {
    printf "usage: %s [-s19|-s28] [-L <library path>] [-D <define: name=value or name>] <src files> \n", $0;
    print  "\n";
    exit;
}

#######################################
# determine program name and location #
#######################################
$prog_name   = basename($src_files[0], ".s");
$output_path = dirname($src_files[0], ".s");

###################
# add default lib #
###################
#printf "libraries:    %s (%s)\n",join(", ", @lib_files), $#lib_files;
#printf "source files: %s (%s)\n",join(", ", @src_files), $#src_files;
if ($#lib_files < 0) {
  foreach my $src_file (@src_files) {
    #printf "add library:%s/\n", dirname($src_file);
    push @lib_files, sprintf("%s%s", dirname($src_file), $hsw12_asm::PATH_DEL);
  }
}

####################
# load symbol file #
####################
my $symbol_file_name = sprintf("%s%s%s.sym", $output_path, $hsw12_asm::PATH_DEL, $prog_name);
#printf STDERR "Loading: %s\n",  $symbol_file_name;
my $data;
if (open (FILEHANDLE, sprintf("<%s", $symbol_file_name))) {
    $data = join "", <FILEHANDLE>;
    eval $data;
    close FILEHANDLE;
}
#printf STDERR $data;
#printf STDERR "Importing %s\n",  join(",\n", keys %{$symbols});
#exit;

#######################
# compile source code #
#######################
#printf STDERR "src files: \"%s\"\n", join("\", \"", @src_files);  
#printf STDERR "lib files: \"%s\"\n", join("\", \"", @lib_files);  
#printf STDERR "defines:   \"%s\"\n", join("\", \"", @defines);  
$code = hsw12_asm->new(\@src_files, \@lib_files, \%defines, "S12", 1, $symbols);

###################
# write list file #
###################
my $list_file_name = sprintf("%s%s%s.lst", $output_path, $hsw12_asm::PATH_DEL, $prog_name);
my $out_string;
if (open (FILEHANDLE, sprintf("+>%s", $list_file_name))) {
    $out_string = $code->print_listing();
    print FILEHANDLE $out_string;
    #print STDOUT     $out_string;
    #printf "output: %s\n", $list_file_name;
    close FILEHANDLE;
} else {
    printf STDERR "Can't open list file \"%s\"\n", $list_file_name;
    exit;
}

#####################
# check code status #
#####################
if ($code->{problems}) {
    printf STDERR "Problem summary: %s\n", $code->{problems};
    $out_string = $code->print_error_summary();
    print STDERR $out_string;
} else {
    ###################################
    # give memory allocation overview #
    ###################################
    $out_string = $code->print_mem_alloc();
    print STDERR     "\n" . $out_string;
    
    #####################
    # write symbol file #
    #####################
    if (open (FILEHANDLE, sprintf("+>%s", $symbol_file_name))) {
	my $dump = Data::Dumper->new([$code->{comp_symbols}], ['symbols']);
	$dump->Indent(2);
	print FILEHANDLE $dump->Dump;
 	close FILEHANDLE;
    } else {
	printf STDERR "Can't open symbol file \"%s\"\n", $symbol_file_name;
	exit;
    }

    #########################
    # write linear S-record #
    #########################
    my $lin_srec_file_name = sprintf("%s%s%s_lin.%s", $output_path, $hsw12_asm::PATH_DEL, $prog_name, lc($srec_format));
    if (open (FILEHANDLE, sprintf("+>%s", $lin_srec_file_name))) {
	$out_string = $code->print_lin_srec(uc($prog_name),
					    $srec_format,
					    $srec_data_length,
					    $srec_add_s5,
					    $srec_alignment);
	print FILEHANDLE $out_string;
	close FILEHANDLE;
    } else {
	printf STDERR "Can't open S-record file \"%s\"\n", $lin_srec_file_name;
	exit;
    }

    ########################
    # write paged S-record #
    ########################
    my $pag_srec_file_name = sprintf("%s%s%s_pag.%s", $output_path, $hsw12_asm::PATH_DEL, $prog_name, lc($srec_format));
    if (open (FILEHANDLE, sprintf("+>%s", $pag_srec_file_name))) {
	$out_string = $code->print_pag_srec(uc($prog_name),
					    $srec_format,
					    $srec_data_length,
					    $srec_add_s5,
					    $srec_alignment);
	print FILEHANDLE $out_string;
	close FILEHANDLE;
    } else {
	printf STDERR "Can't open S-record file \"%s\"\n", $pag_srec_file_name;
	exit;
    }
}















