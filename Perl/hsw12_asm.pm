#! /usr/bin/env perl
##################################################################################
#                             HC(S)12 ASSEMBLER                                  #
##################################################################################
# file:    hsw12_asm.pm                                                          #
# author:  Dirk Heisswolf                                                        #
# purpose: This is the core of the HSW12 Assembler                               #
##################################################################################
# Copyright (C) 2003-2018 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12_asm - HC(S) Assembler

=head1 SYNOPSIS

 require hsw12_asm

 $asm = hsw12_asm->new(\@source_files, \@library_dirs, \%assembler_defines, $cpu, $verbose);
 print FILEHANDLE $asm->print_listing();
 print FILEHANDLE $asm->print_lin_srec();
 print FILEHANDLE $asm->print_pag_srec();

=head1 REQUIRES

perl5.005, File::Basename, FindBin, Text::Tabs

=head1 DESCRIPTION

This module provides subroutines to...

=over 4

 - compile HC(S)12 assembler source code
 - create code lisings
 - create linear and paged S-Records
 - provide access to the symbols used in the source code

=back

=head1 METHODS

=head2 Creation

=over 4

=item hsw12_asm->new(\@source_files, \@library_dirs, \%assembler_defines, $verbose)

 Creates and returns an hsw12_asm object.
 This method requires five arguments:
     1. \@source_files:      a list of files to compile (array reference)
     2. \@library_dirs:      a list of directories to search include files in (array reference)
     3. \%assembler_defines: assembler defines to set before compiling the source code (hash reference)
     4. $cpu:                the target CPU ("HC11", "HC12"/"S12", "S12X", "XGATE") (string)
     5. $verbose:            switch to enable progress messages (boolean)

=back

=head2 Outputs

=over 4

=item $asm_object->print_listing()

 Returns the listing of the assembler source code (string).

=item $asm_object->print_lin_srec($string,
                                  $srec_format,
                                  $srec_length,
                                  $s5,
                                  $alignment)

 Returns a linear S-Record of the compiled code (string).
 This method requires five arguments:
     1. $string:      S0 header                        (string)
     2. $srec_format: address format: S19, S28, or S37 (string)
     3. $srec_length: number of data bytes in S-Record (integer)
     4. $alignment:   phrase size to align S-record to (integer)

=item $asm_object->print_pag_srec($string,
                                  $srec_format,
                                  $srec_length,
                                  $s5,
                                  $alignment)

 Returns a paged S-Record of the compiled code (string).
 This method requires five arguments:
     1. $string:      S0 header                        (string)
     2. $srec_format: address format: S19, S28, or S37 (string)
     3. $srec_length: number of data bytes in S-Record (integer)
     4. $alignment:   phrase size to align S-record to (integer)

=head2 Misc

=over 4

=item $asm_object->reload(boolean)
 This method requires one argument:
     1. $verbose:  switch to enable progress messages (boolean)

 Recompiles the source code files.

=item $asm_object->$evaluate_expression($expr, $pc_lin, $pc_pag, $loc)

 Converts an expression into an integer and resolves compiler symbols.
 This method requires four arguments:
     1. $expr:   expression (string)
     2. $pc_lin: current linear program counter (integer)
     3. $pc_pag: current paged program counter (integer)
     4. $loc:    current "LOC" count (integer)

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Feb 9, 2003

 initial release

=item V00.01 - Feb 23, 2003

 -fixed BCC opcode
 -fixed relative address mode
 -replacing tabs with Text::Tabs::expand()

=item V00.02 - Feb 24, 2003

 -fixed compiler symbol table

=item V00.03 - Feb 28, 2003

 -fixed IDX1 addressing mode
 -fixed IDX2 addressing mode
 -fixed REL9 addressing mode for DBEQ, DBNE, IBEQ, IBNE
 -fixed EXG and TFR command

=item V00.04 - Mar 2, 2003

 -fixed ascii expressions
 -allow value changes of symbols during compilation
 -fixed FCC pseudo opcode
 -fixed long hex codes in listing

=item V00.05 - Mar 11, 2003

 -new default mapping for linear PC:
  $0000 - $3FFF are mapped to flash page $3D

=item V00.06 - Mar 28, 2003

 -fixed S-Record output (data fields used to be one byte too short)

=item V00.07 - Apr 1, 2003

 -added options to configure the S-Record format, including "fill bytes"

=item V00.08 - Apr 23, 2003

 -fixed S0 record format
 -fixd fill byte insertion

=item V00.09 - Apr 29, 2003

 -added member variable "compile_count"
 -undefined symbols will now generate errors
 -accepting "_" on integer numbers
 -added a "verbose mode" to print out progress messages

=item V00.10 - May 6, 2003

 -bugfix in "evaluate_expression"

=item V00.11 - Jun 5, 2003

 -bugfix in "precompile"

=item V00.12 - Sep 22, 2003

 -allow more generic instruction tables

=item V00.13 - Sep 27, 2003

 -added HC11, S12X, and XGATE instruction tables

=item V00.14 - Sep 28, 2003

 -added XGATE pseudo instructions

=item V00.15 - Sep 30, 2003

 -added XGATE "IDO5" address mode

=item V00.16 - Nov 24, 2003

 -fixed relaxed error condition of "REL8" address mode

=item V00.17 - Nov 27, 2003

 -updated S12X SEX instruction

=item V00.18 - Jan 27, 2004

 -fixed missing S12X move address modes
 -various minor fixes

=item V00.19 - Feb 13, 2004

 -fixed regular expressions for parsing pseudo opcodes

=item V00.20 - Mar 9, 2004

 -detect auto in/decrement of PC

=item V00.21 - Aug 4, 2004

 -added XGATE command "TFR RD,PC"

=item V00.22 - Oct 28, 2004

 -fixed "TFR", "EXG", and "SEX" instructions
 -added pseudo opcodes which are to be ignored

=item V00.23 - Nov 26, 2004

 -fixed regular expression "TFR Rx,PC"
 -added 16-bit immediatate pseudo instructions

=item V00.24 - Apr 24, 2005

 -automatically turn branch instructions into long branches
  if out of range
 -added pseudo opcode "JOB" to automatically choose between
  "BRA rel8" and "JMP ext" opcodes
 -added pseudo opcode "JOBSR" to automatically choose between
  "BSR rel8" and "JSR ext" opcodes

=item V00.25 - Oct 19, 2005
 -added workaround for the XGATE "SSEM" bug
 -added "SSSEM" (single/spec conform SSEM) instruction

=item V00.26 - Oct 22, 2005
 -added macro support

=item V00.27 - Oct 27, 2005
 -fixed pseudo opcodes (especially "FILL")

=item V00.28 - Dec 22, 2005
 -fixed evaluation of local symbols (inside macros)

=item V00.29 - Mar 23, 2006
 -added functions print_lin_binary and print_pag_binary

=item V00.30 - Apr 11, 2006
 -fixed "[D,r]" address mode

=item V00.30 - Apr 11, 2006
 -fixed "[D,r]" address mode

=item V00.31 - Jun 23, 2006
 -fixed BGND instruction

=item V00.32 - Apr 9, 2009
 -fixed items on David Armstrongs's bug list
   -added ">"/"<" syntax to disable the automatic BRA/LBRA selection
   -finished implementing the SETDP pseudo-opcode

=item V00.33 - Apr 25, 2009
 -fixed one more item on David Armstrongs's bug list
   -CALL instruction no longer requires a page value for
    indexed-indirect address modes

=item V00.34 - Apr 27, 2009
 -added pseudo-opcode FCS, to generate strings which are terminated by
  setting the MSB in the last character

=item V00.35 - Apr 28, 2009
 -made up address mode "extended-indirect [ext]", which translates into
  indexed-indirect address mode with PC relative addressing

=item V00.36 - Apr 30, 2009
 -added hack to allow semicolons in strings. These strings must have the
  delimeters " or '

=item V00.37 - May 3, 2009
 -fixed regular expression $PRECOMP_OPCODE. Got btoken in V00.37 (did not
  handle expressions with ascii chars correctly
  
=item V00.38 - May 7, 2009
 -macros now accept strings with commas and whitespaces
  
=item V00.39 - May 27, 2010
 -"./" is no longer treated as absolute path
  
=item V00.40 - Jan 19, 2011
 -added support for incremental compiles 
  
=item V00.41 - Oct 5, 2012
 -minor fixes
  
=item V00.42 - Nov 27, 2012
 -improved forced rel8 address mode
  
=item V00.43 - Jan 4, 2013
 -range violations in DBEQ, DBNE, TBEQ, TBNE instructions no longer abort the
  compilation
  
=item V00.44 - Feb 13, 2013
 -fixed directory path format for Windows

=item V00.45 - Feb 18, 2014
 -supporting parenthesized macro arguments (allowing indexed addresses as argument)
 -supporting opcode substitution in macros

=item V00.46 - Aug 28, 2014
 -give hints about symbol redefinition if too many compile runs are required

=item V00.47 - Jan 8, 2015
 -added precompiler directives #ifmac and #ifnmac to check whether a macro has
  already been defined.

=item V00.48 - Jan 25, 2015
 -added pseudo-opcode FLET16 to calculate the Fletcher-16 checksum of a paged
  address range (defined by the two arguments: start address and end address).

=item V00.49 - Feb 5, 2015
 -added subroutine "print_mem_alloc" to print an overview of the memory allocation.

=item V00.50 - Jan 25, 2016
 -added opcode "CLRD"

=item V00.51 - Feb 9, 2016
 -added pseudo-opcode "ERROR".

=item V00.52 - Feb 10, 2016
 -added subroutine "print_error_summary" to print the first 5 error messages.

=item V00.53 - Jun 22, 2016
 -macro enhancement: arg substitution for labels and code listing

=item V00.54 - Aug 13, 2016
 -added precompiler directives #ifcpu and #ifncpu to check the current target 
  processor.
 -Be carefull when using the pseudo-opcode "CPU" inside macros. The precompile
  step may have a different compile order then the remaining compile steps  

=item V00.55 - Dec 09, 2016
 -reduced comment clutter in list files. Comments separated by a blanc line
  are no longer associated with the following instruction.

=item V00.56 - Jan 16, 2017
 -added pseudo-opcode FCZ, to generate strings which are terminated by
  appending a zero character

=item V00.57 - Feb 14, 2018
 -updated insertion of S5-records:
     -S5 records will be inserted by default. 
     -Each S5 record now shows the number of S1/2/3 records after the initial S0-record.
      (Previously the count was reset after each S5 record)
 -enhanced fill byte option in S-record generation (now alinment to phrases > 1 byte supported)     
  
=item V00.58 - Jun 25, 2018
 -fixed precompiler detection of "CPU" pseudo-opcode
 
=cut

#################
# Perl settings #
#################
#use warnings;
#use strict;

####################
# create namespace #
####################
package hsw12_asm;

###########
# modules #
###########
use IO::File;
use Fcntl;
use Text::Tabs;
use File::Basename;
use Readonly;

####################
# global variables #
####################
#@source_files  (array)
#@libraies      (array)
#@initial_defs  (hash)
#$problems      (boolean)
#@code          (array)
#%precomp_defs  (hash)
#%comp_symbols  (hash)
#%lin_addrspace (hash)
#%pag_addrspace (hash)
#$compile_count (integer)
#$verbose       (boolean)

#############
# constants #
#############
################################
# Max. number of compile runs) #
################################
Readonly our $MAX_COMP_RUNS => 200;

###########
# version #
###########
Readonly our $VERSION => "00.58";#"

#############################
# default S-record settings #
#############################
Readonly our $SREC_DEF_FORMAT      => "S28";#"
Readonly our $SREC_DEF_DATA_LENGTH => 64;
Readonly our $SREC_DEF_ADD_S5      => 64;
Readonly our $SREC_DEF_FILL_BYTE   => 0xff;
Readonly our $SREC_DEF_ALIGNMENT   => 8;

###################
# path delimeters #
###################
Readonly our $PATH_DEL         => ($^O =~ /MSWin/i)
    ? "\\"
    : "\/"
;
Readonly our $PATH_ABSOLUTE    => ($^O =~ /MSWin/i)
    ? qr/^[A-Z]\:/
    : qr/^\//
;

########################
# code entry structure #
########################
Readonly our $CODE_ENTRY_LINE     =>  0;
Readonly our $CODE_ENTRY_FILE     =>  1;
Readonly our $CODE_ENTRY_CODE     =>  2;
Readonly our $CODE_ENTRY_LABEL    =>  3;
Readonly our $CODE_ENTRY_OPCODE   =>  4;
Readonly our $CODE_ENTRY_ARGS     =>  5;
Readonly our $CODE_ENTRY_LIN_PC   =>  6;
Readonly our $CODE_ENTRY_PAG_PC   =>  7;
Readonly our $CODE_ENTRY_HEX      =>  8;
Readonly our $CODE_ENTRY_BYTES    =>  9;
Readonly our $CODE_ENTRY_ERRORS   => 10;
Readonly our $CODE_ENTRY_MACROS   => 11;
Readonly our $CODE_ENTRY_SYM_TABS => 12;

###########################
# precompiler expressions #
###########################
Readonly our $PRECOMP_DIRECTIVE    => qr/^\#(\w+)\s*([^\,\s\;]*|\(.*\))\s*[\s,]?\s*([^\,\s\;]*|\(.*\))\s*[;\*]?/;  #$1:directive $2:name $3:value
Readonly our $PRECOMP_DEFINE       => qr/define/i;
Readonly our $PRECOMP_UNDEF        => qr/undef/i;
Readonly our $PRECOMP_IFDEF        => qr/ifdef/i;
Readonly our $PRECOMP_IFNDEF       => qr/ifndef/i;
Readonly our $PRECOMP_IFMAC        => qr/ifmac/i;
Readonly our $PRECOMP_IFNMAC       => qr/ifnmac/i;
Readonly our $PRECOMP_IF           => qr/if/i;
Readonly our $PRECOMP_IFCPU        => qr/ifcpu/i;
Readonly our $PRECOMP_IFNCPU       => qr/ifncpu/i;
Readonly our $PRECOMP_ELSE         => qr/else/i;
Readonly our $PRECOMP_ENDIF        => qr/endif/i;
Readonly our $PRECOMP_INCLUDE      => qr/include/i;
Readonly our $PRECOMP_MACRO        => qr/macro/i;
Readonly our $PRECOMP_EMAC         => qr/emac/i;
Readonly our $PRECOMP_BLANC_LINE   => qr/^\s*$/;
Readonly our $PRECOMP_COMMENT_LINE => qr/^\s*[\;\*]/;
#Readonly our $PRECOMP_OPCODE      => qr/^([^\#][\\\w]*\`?):?\s*([\w\.]*)\s*([^;]*)\s*[;\*]?/;                       #$1:label $2:opcode $3:arguments
Readonly our $PRECOMP_OPCODE       => qr/^([^\#][\\\w]*\`?):?\s*([\\\w\.]*)\s*((?:\".*?\"|\'.*?\'|[^;])*)\s*[;\*]?/; #$1:label $2:opcode $3:arguments

#############
# TFR codes #
#############
Readonly our $TFR_S12               => 0;
Readonly our $TFR_S12X              => 1;
Readonly our $TFR_TFR               => 0;
Readonly our $TFR_SEX               => 1;
Readonly our $TFR_EXG               => 2;

############################
# address mode expressions #
############################
#operands (S12)
Readonly our $OP_KEYWORDS           => qr/^\s*(A|B|D|X|Y|PC|SP|UNMAPPED|R[0-7])\s*$/i; #$1: keyword
#Readonly our $DEL                  => qr/\s*,\s*/;
Readonly our $DEL                   => qr/\s*[\s,]\s*/;
Readonly our $OP_EXPR               => qr/([^\"\'\s\,\<\>\[][^\"\'\s\,]*\'?|\".*\"|\'.*\'|\(.*\))/i;
Readonly our $OP_OFFSET             => qr/([^\"\'\s\,]*\'?|\".*\"|\'.*\'|\(.*\))/i;
Readonly our $OP_IMM                => qr/\#$OP_EXPR/i;
Readonly our $OP_DIR                => qr/\<?$OP_EXPR/i;
Readonly our $OP_EXT                => qr/\>?$OP_EXPR/i;
Readonly our $OP_IDX                => qr/$OP_OFFSET,([\+\-]?)(X|Y|SP|PC)([\+\-]?)/i;                                #$1:offset $2:preop $3:register $4:postop
Readonly our $OP_IDX1               => qr/$OP_OFFSET,(X|Y|SP|PC)/i;                                                  #$1:offset $2:register
Readonly our $OP_IDX2               => qr/$OP_OFFSET,\s*(X|Y|SP|PC)/i;                                               #$1:offset $2:register
Readonly our $OP_IDIDX              => qr/\[\s*D\s*,\s*(X|Y|SP|PC)\s*\]/i;                                           #$1:register
Readonly our $OP_IIDX2              => qr/\[\s*$OP_OFFSET\s*,\s*(X|Y|SP|PC)\s*\]/i;                                  #$1:offset $2:register
Readonly our $OP_IEXT               => qr/\[\s*$OP_EXPR\s*\]/i;                                                      #$1:addresss
Readonly our $OP_PG                 => qr/$OP_EXPR/i;                                                                #$1:page
Readonly our $OP_REL                => qr/$OP_EXPR/i;                                                                #$1:address
Readonly our $OP_MSK                => qr/\#?$OP_EXPR/i;                                                             #$1:mask
Readonly our $OP_TRAP               => qr/$OP_EXPR/i;                                                                #$1:value
Readonly our $OP_REG_SRC            => qr/(A|B|D|X|XL|Y|YL|SP|SPL|CCR|CCRL|TMP3|TMP3L)/i;                            #$1:register
Readonly our $OP_REG_DST            => qr/(A|B|D|X|XL|Y|YL|SP|SPL|CCR|CCRL|TMP2|TMP2L)/i;                            #$1:register
Readonly our $OP_REG_IDX            => qr/(A|B|D|X|Y|SP)/i;                                                          #$1:register
#operands (S12X)
Readonly our $OP_S12X_REG_SRC       => qr/(A|B|D|X|XH|XL|Y|YH|YL|SP|SPH|SPL|CCR|CCRW|CCRH|CCRL|TMP1|TMP3|TMP3H|TMP3L)/i;#$1:register
Readonly our $OP_S12X_REG_DST       => qr/(A|B|D|X|XH|XL|Y|YH|YL|SP|SPH|SPL|CCR|CCRW|CCRH|CCRL|TMP1|TMP2|TMP2H|TMP2L)/i;#$1:register
#operands (HC11)
Readonly our $OP_INDX               => qr/$OP_OFFSET$DEL[X]/i;                                                       #$1:offset $2:preop $3:register $4:postop
Readonly our $OP_INDY               => qr/$OP_OFFSET$DEL[Y]/i;                                                       #$1:offset $2:preop $3:register $4:postop
#operands (XGATE)
Readonly our $OP_XGATE_REG_GPR      => qr/(R[0-7])/i;                                                                #$1:register
Readonly our $OP_XGATE_REG_SRC      => qr/(R[0-7]|CCR)/i;                                                            #$1:register
Readonly our $OP_XGATE_REG_DST      => qr/(R[0-7]|CCR)/i;                                                            #$1:register
#operands (pseudo opcodes)
Readonly our $OP_PSOP               => qr/$OP_EXPR/i;                                                                #$1:operand

#S12 address modes
Readonly our $AMOD_INH          => qr/^\s*$/i;
Readonly our $AMOD_IMM8         => qr/^\s*$OP_IMM\s*$/i;        #$1:data
Readonly our $AMOD_IMM16        => $AMOD_IMM8;
Readonly our $AMOD_DIR          => qr/^\s*$OP_DIR\s*$/i;        #$1:address
Readonly our $AMOD_EXT          => qr/^\s*$OP_EXT\s*$/i;        #$1:address
Readonly our $AMOD_REL8_FORCED  => qr/^\s*\<$OP_REL\s*$/i;      #$1:address
Readonly our $AMOD_REL8         => qr/^\s*\<?$OP_REL\s*$/i;     #$1:address
Readonly our $AMOD_REL16        => qr/^\s*\>?$OP_REL\s*$/i;     #$1:address
Readonly our $AMOD_IDX          => qr/^\s*$OP_IDX\s*$/i;        #$1:offset $2:preop $3:register $4:postop
Readonly our $AMOD_IDX1         => qr/^\s*$OP_IDX1\s*$/i;       #$1:offset $2:register
Readonly our $AMOD_IDX2         => $AMOD_IDX1;
Readonly our $AMOD_IDIDX        => qr/^\s*$OP_IDIDX\s*$/i;      #$1:register
Readonly our $AMOD_IIDX2        => qr/^\s*$OP_IIDX2\s*$/i;      #$1:offset $2:register
Readonly our $AMOD_IEXT         => qr/^\s*$OP_IEXT\s*$/i;       #$1:address

Readonly our $AMOD_DIR_MSK      => qr/^\s*$OP_DIR$DEL$OP_MSK\s*$/i;  #$1:address $2:mask
Readonly our $AMOD_EXT_MSK      => qr/^\s*$OP_EXT$DEL$OP_MSK\s*$/i;  #$1:address $2:mask
Readonly our $AMOD_IDX_MSK      => qr/^\s*$OP_IDX$DEL$OP_MSK\s*$/i;  #$1:offset $2:preop $3:register $4:postop $4:mask
Readonly our $AMOD_IDX1_MSK     => qr/^\s*$OP_IDX1$DEL$OP_MSK\s*$/i; #$1:offset $2:register $3:mask
Readonly our $AMOD_IDX2_MSK     => $AMOD_IDX1_MSK;

Readonly our $AMOD_DIR_MSK_REL  => qr/^\s*$OP_DIR$DEL$OP_MSK$DEL$OP_REL\s*$/i;  #$1:address $2:mask $3:address
Readonly our $AMOD_EXT_MSK_REL  => qr/^\s*$OP_EXT$DEL$OP_MSK$DEL$OP_REL\s*$/i;  #$1:address $2:mask $3:address
Readonly our $AMOD_IDX_MSK_REL  => qr/^\s*$OP_IDX$DEL$OP_MSK$DEL$OP_REL\s*$/i;  #$1:offset $2:preop $3:register $4:postop $5:mask $6:address
Readonly our $AMOD_IDX1_MSK_REL => qr/^\s*$OP_IDX1$DEL$OP_MSK$DEL$OP_REL\s*$/i; #$1:offset $2:register $3:mask $4:address
Readonly our $AMOD_IDX2_MSK_REL => $AMOD_IDX1_MSK_REL;

Readonly our $AMOD_EXT_PGIMPL   => qr/^\s*$OP_EXT\s*$/i;             #$1:address
Readonly our $AMOD_EXT_PG       => qr/^\s*$OP_EXT$DEL$OP_PG\s*$/i;   #$1:address $2:page
Readonly our $AMOD_IDX_PG       => qr/^\s*$OP_IDX$DEL$OP_PG\s*$/i;   #$1:offset $2:preop $3:register $4:postop $5:page
Readonly our $AMOD_IDX1_PG      => qr/^\s*$OP_IDX1$DEL$OP_PG\s*$/i;  #$1:offset $2:register $3:page
Readonly our $AMOD_IDX2_PG      => $AMOD_IDX1_PG;

Readonly our $AMOD_IMM8_EXT     => qr/^\s*$OP_IMM$DEL$OP_EXT\s*$/i; #$1:data $2:address
Readonly our $AMOD_IMM8_IDX     => qr/^\s*$OP_IMM$DEL$OP_IDX\s*$/i; #$1:data $2:offset $3:preop $4:register $5:postop
Readonly our $AMOD_IMM16_EXT    => $AMOD_IMM8_EXT;
Readonly our $AMOD_IMM16_IDX    => $AMOD_IMM8_IDX;
Readonly our $AMOD_EXT_EXT      => qr/^\s*$OP_EXT$DEL$OP_EXT\s*$/i; #$1:address $2:address
Readonly our $AMOD_EXT_IDX      => qr/^\s*$OP_EXT$DEL$OP_IDX\s*$/i; #$1:address $2:offset $3:preop $4:register $5:postop
Readonly our $AMOD_IDX_EXT      => qr/^\s*$OP_IDX$DEL$OP_EXT\s*$/i; #$1:offset $1:preop $3:register $4:postop $5:address
Readonly our $AMOD_IDX_IDX      => qr/^\s*$OP_IDX$DEL$OP_IDX\s*$/i; #$1:offset $2:preop $3:register $4:postop #$5:offset $6:preop $7:register $8:postop

Readonly our $AMOD_EXG          => qr/^\s*$OP_REG_SRC$DEL$OP_REG_DST\s*$/i; #$1:register $1:register
Readonly our $AMOD_TFR          => $AMOD_EXG;                           #$1:register $1:register

Readonly our $AMOD_DBEQ         => qr/^\s*$OP_REG_IDX$DEL$OP_REL\s*$/i;   #$1:register $1:address
Readonly our $AMOD_DBNE         => $AMOD_DBEQ;
Readonly our $AMOD_TBEQ         => $AMOD_DBEQ;
Readonly our $AMOD_TBNE         => $AMOD_DBEQ;
Readonly our $AMOD_IBEQ         => $AMOD_DBEQ;
Readonly our $AMOD_IBNE         => $AMOD_DBEQ;

Readonly our $AMOD_TRAP         => qr/^\s*$OP_TRAP\s*$/i; #$1:value

#HC11 address modes
Readonly our $AMOD_HC11_INDX         => qr/^\s*$OP_INDX\s*$/i; #$1:offset
Readonly our $AMOD_HC11_INDY         => qr/^\s*$OP_INDY\s*$/i; #$1:offset
Readonly our $AMOD_HC11_INDX_MSK     => qr/^\s*$OP_INDX$DEL$OP_MSK\s*$/i; #$1:offset $2:mask
Readonly our $AMOD_HC11_INDY_MSK     => qr/^\s*$OP_INDY$DEL$OP_MSK\s*$/i; #$1:offset $2:mask
Readonly our $AMOD_HC11_INDX_MSK_REL => qr/^\s*$OP_INDX$DEL$OP_MSK$DEL$OP_REL\s*$/i; #$1:offset $2:mask $3:address
Readonly our $AMOD_HC11_INDY_MSK_REL => qr/^\s*$OP_INDY$DEL$OP_MSK$DEL$OP_REL\s*$/i; #$1:offset $2:mask $3:address

#S12X address modes
Readonly our $AMOD_S12X_DIR          => $AMOD_DIR;
Readonly our $AMOD_S12X_DIR_MSK      => $AMOD_DIR_MSK;
Readonly our $AMOD_S12X_DIR_MSK_REL  => $AMOD_DIR_MSK_REL;

Readonly our $AMOD_IMM8_IDX1         => qr/^\s*$OP_IMM$DEL$OP_IDX1\s*$/i; #$1:data $2:offset $3:register;
Readonly our $AMOD_IMM8_IDX2         => $AMOD_IMM8_IDX1;
Readonly our $AMOD_IMM8_IDIDX        => qr/^\s*$OP_IMM$DEL$OP_IDIDX\s*$/i; #$1:data $2:register;
Readonly our $AMOD_IMM8_IIDX2        => qr/^\s*$OP_IMM$DEL$OP_IIDX2\s*$/i; #$1:data $2:offset $3:register;
Readonly our $AMOD_IMM8_IEXT         => qr/^\s*$OP_IMM$DEL$OP_IEXT\s*$/i;  #$1:data $2:address;

Readonly our $AMOD_IMM16_IDX1        => $AMOD_IMM8_IDX1;
Readonly our $AMOD_IMM16_IDX2        => $AMOD_IMM8_IDX2;
Readonly our $AMOD_IMM16_IDIDX       => $AMOD_IMM8_IDIDX;
Readonly our $AMOD_IMM16_IIDX2       => $AMOD_IMM8_IIDX2;
Readonly our $AMOD_IMM16_IEXT        => $AMOD_IMM8_IEXT;

Readonly our $AMOD_EXT_IDX1          => qr/^\s*$OP_EXT$DEL$OP_IDX1\s*$/i;  #$1:address $2:offset $3:register;
Readonly our $AMOD_EXT_IDX2          => $AMOD_EXT_IDX1;
Readonly our $AMOD_EXT_IDIDX         => qr/^\s*$OP_EXT$DEL$OP_IDIDX\s*$/i; #$1:address $2:register;
Readonly our $AMOD_EXT_IIDX2         => qr/^\s*$OP_EXT$DEL$OP_IIDX2\s*$/i; #$1:address $2:offset $3:register;
Readonly our $AMOD_EXT_IEXT          => qr/^\s*$OP_EXT$DEL$OP_IEXT\s*$/i;  #$1:address $2:address;

Readonly our $AMOD_IDX_IDX1          => qr/^\s*$OP_IDX$DEL$OP_IDX1\s*$/i;  #$1:offset $2:preop $3:register $4:postop $5:offset $6:register;
Readonly our $AMOD_IDX_IDX2          => $AMOD_IDX_IDX1;
Readonly our $AMOD_IDX_IDIDX         => qr/^\s*$OP_IDX$DEL$OP_IDIDX\s*$/i; #$1:offset $2:preop $3:register $4:postop $5:register;
Readonly our $AMOD_IDX_IIDX2         => qr/^\s*$OP_IDX$DEL$OP_IIDX2\s*$/i; #$1:offset $2:preop $3:register $4:postop $5:offset $6:register;
Readonly our $AMOD_IDX_IEXT          => qr/^\s*$OP_IDX$DEL$OP_IEXT\s*$/i;  #$1:offset $2:preop $3:register $4:postop $5:address;

Readonly our $AMOD_IDX1_EXT          => qr/^\s*$OP_IDX1$DEL$OP_EXT\s*$/i;  #$1:offset $2:register $3:address;
Readonly our $AMOD_IDX1_IDX          => qr/^\s*$OP_IDX1$DEL$OP_IDX\s*$/i;  #$1:offset $2:register $3:offset $4:preop $5:register $6:postop;
Readonly our $AMOD_IDX1_IDX1         => qr/^\s*$OP_IDX1$DEL$OP_IDX1\s*$/i; #$1:offset $2:register $3:offset $4:register;
Readonly our $AMOD_IDX1_IDX2         => $AMOD_IDX1_IDX1;
Readonly our $AMOD_IDX1_IDIDX        => qr/^\s*$OP_IDX1$DEL$OP_IDIDX\s*$/i;#1$:offset $2:register $3:register;
Readonly our $AMOD_IDX1_IIDX2        => qr/^\s*$OP_IDX1$DEL$OP_IIDX2\s*$/i;#1$:offset $2:register $3:offset $4:register;
Readonly our $AMOD_IDX1_IEXT         => qr/^\s*$OP_IDX1$DEL$OP_IEXT\s*$/i; #1$:offset $2:register $3:address;

Readonly our $AMOD_IDX2_EXT          => $AMOD_IDX1_EXT;
Readonly our $AMOD_IDX2_IDX          => $AMOD_IDX1_IDX;
Readonly our $AMOD_IDX2_IDX1         => $AMOD_IDX1_IDX1;
Readonly our $AMOD_IDX2_IDX2         => $AMOD_IDX1_IDX1;
Readonly our $AMOD_IDX2_IDIDX        => $AMOD_IDX1_IDIDX;
Readonly our $AMOD_IDX2_IIDX2        => $AMOD_IDX1_IIDX2;
Readonly our $AMOD_IDX2_IEXT         => $AMOD_IDX1_IEXT;

Readonly our $AMOD_IDIDX_EXT         => qr/^\s*$OP_IDIDX$DEL$OP_EXT\s*$/i;  #$1:register $2:address;
Readonly our $AMOD_IDIDX_IDX         => qr/^\s*$OP_IDIDX$DEL$OP_IDX\s*$/i;  #$1:register $2:offset $3:preop $4:register $5:postop;
Readonly our $AMOD_IDIDX_IDX1        => qr/^\s*$OP_IDIDX$DEL$OP_IDX1\s*$/i; #$1:register $2:offset $3:register;
Readonly our $AMOD_IDIDX_IDX2        => $AMOD_IDIDX_IDX1;
Readonly our $AMOD_IDIDX_IDIDX       => qr/^\s*$OP_IDIDX$DEL$OP_IDIDX\s*$/i;#$1:register $2:register;
Readonly our $AMOD_IDIDX_IIDX2       => qr/^\s*$OP_IDIDX$DEL$OP_IIDX2\s*$/i;#$1:register $2:offset $3:register;
Readonly our $AMOD_IDIDX_IEXT        => qr/^\s*$OP_IDIDX$DEL$OP_IEXT\s*$/i; #$1:register $2:address;

Readonly our $AMOD_IIDX2_EXT         => qr/^\s*$OP_IIDX2$DEL$OP_EXT\s*$/i;  #$1:offset $2:register $3:address;
Readonly our $AMOD_IIDX2_IDX         => qr/^\s*$OP_IIDX2$DEL$OP_IDX\s*$/i;  #$1:offset $2:register $3:offset $4:preop $5:register $6:postop;
Readonly our $AMOD_IIDX2_IDX1        => qr/^\s*$OP_IIDX2$DEL$OP_IDX1\s*$/i; #$1:offset $2:register $3:offset $4:register;
Readonly our $AMOD_IIDX2_IDX2        => $AMOD_IIDX2_IDX1;
Readonly our $AMOD_IIDX2_IDIDX       => qr/^\s*$OP_IIDX2$DEL$OP_IDIDX\s*$/i;#$1:offset $2:register $3:register;
Readonly our $AMOD_IIDX2_IIDX2       => qr/^\s*$OP_IIDX2$DEL$OP_IIDX2\s*$/i;#$1:offset $2:register $3:offset $4:register;
Readonly our $AMOD_IIDX2_IEXT        => qr/^\s*$OP_IIDX2$DEL$OP_IEXT\s*$/i; #$1:offset $2:register $3:address;

Readonly our $AMOD_IEXT_EXT          => qr/^\s*$OP_IEXT$DEL$OP_EXT\s*$/i;  #$1:address $2:address;
Readonly our $AMOD_IEXT_IDX          => qr/^\s*$OP_IEXT$DEL$OP_IDX\s*$/i;  #$1:address $2:offset $3:preop $4:register $5:postop;
Readonly our $AMOD_IEXT_IDX1         => qr/^\s*$OP_IEXT$DEL$OP_IDX1\s*$/i; #$1:address $2:offset $3:register;
Readonly our $AMOD_IEXT_IDX2         => $AMOD_IEXT_IDX1;
Readonly our $AMOD_IEXT_IDIDX        => qr/^\s*$OP_IEXT$DEL$OP_IDIDX\s*$/i;#$1:address $2:register;
Readonly our $AMOD_IEXT_IIDX2        => qr/^\s*$OP_IEXT$DEL$OP_IIDX2\s*$/i;#$1:address $2:offset $3:register;
Readonly our $AMOD_IEXT_IEXT         => qr/^\s*$OP_IEXT$DEL$OP_IEXT\s*$/i; #$1:address $2:address;

Readonly our $AMOD_S12X_EXG          => qr/^\s*$OP_S12X_REG_SRC$DEL$OP_S12X_REG_DST\s*$/i; #$1:register $1:register
Readonly our $AMOD_S12X_TFR          => $AMOD_S12X_EXG;                                    #$1:register $1:register

Readonly our $AMOD_S12X_TRAP         => $AMOD_TRAP;

#XGATE address modes
Readonly our $AMOD_XGATE_IMM3        => qr/^\s*$OP_IMM\s*$/i;                                                                  #$1:value
Readonly our $AMOD_XGATE_IMM4        => qr/^\s*$OP_XGATE_REG_GPR$DEL$OP_IMM\s*$/i;                                             #$1:register $2:value
Readonly our $AMOD_XGATE_IMM8        => $AMOD_XGATE_IMM4;
Readonly our $AMOD_XGATE_IMM16       => $AMOD_XGATE_IMM4;
Readonly our $AMOD_XGATE_MON         => qr/^\s*$OP_XGATE_REG_GPR\s*$/i;                                                        #$1:register
Readonly our $AMOD_XGATE_DYA         => qr/^\s*$OP_XGATE_REG_GPR$DEL$OP_XGATE_REG_GPR\s*$/i;                                   #$1:register
Readonly our $AMOD_XGATE_TRI         => qr/^\s*$OP_XGATE_REG_GPR$DEL$OP_XGATE_REG_GPR$DEL$OP_XGATE_REG_GPR\s*$/i;              #$1:register
Readonly our $AMOD_XGATE_REL9        => qr/^\s*$OP_REL\s*$/i;                                                                  #$1:address
Readonly our $AMOD_XGATE_REL10       => $AMOD_XGATE_REL9;
Readonly our $AMOD_XGATE_IDO5        => qr/^\s*$OP_XGATE_REG_GPR$DEL\(\s*$OP_XGATE_REG_GPR\s*,\s*$OP_IMM\s*\)\s*$/i;             #$1:register $2:register $3:offset
Readonly our $AMOD_XGATE_IDR         => qr/^\s*$OP_XGATE_REG_GPR$DEL\(\s*$OP_XGATE_REG_GPR\s*,\s*$OP_XGATE_REG_GPR\s*\)\s*$/i;   #$1:register $2:register $3:register
Readonly our $AMOD_XGATE_IDRI        => qr/^\s*$OP_XGATE_REG_GPR$DEL\(\s*$OP_XGATE_REG_GPR\s*,\s*$OP_XGATE_REG_GPR[+]\s*\)\s*$/i;#$1:register $2:register $3:register
Readonly our $AMOD_XGATE_IDRD        => qr/^\s*$OP_XGATE_REG_GPR$DEL\(\s*$OP_XGATE_REG_GPR\s*,\s*[-]$OP_XGATE_REG_GPR\s*\)\s*$/i;#$1:register $2:register $3:register
Readonly our $AMOD_XGATE_TFR_RD_CCR  => qr/^\s*$OP_XGATE_REG_GPR$DEL[C]CR\s*$/i;                                                  #$1:register
Readonly our $AMOD_XGATE_TFR_CCR_RS  => qr/^\s*CCR$DEL$OP_XGATE_REG_GPR\s*$/i;                                                   #$1:register
Readonly our $AMOD_XGATE_TFR_RD_PC   => qr/^\s*$OP_XGATE_REG_GPR$DEL[P]C\s*$/i;                                                  #$1:register

##############################
# pseudo opcocde expressions #
##############################
Readonly our $PSOP_NO_ARG      => qr/^\s*$/i; #
Readonly our $PSOP_1_ARG       => qr/^\s*$OP_PSOP\s*$/i; #$1:arg
Readonly our $PSOP_2_ARGS      => qr/^\s*$OP_PSOP$DEL$OP_PSOP\s*$/i; #$1:arg $2:arg
Readonly our $PSOP_3_ARGS      => qr/^\s*$OP_PSOP$DEL$OP_PSOP$DEL$OP_PSOP\s*$/i; #$1:arg $2:arg $3:arg
Readonly our $PSOP_STRING      => qr/^\s*(.+)\s*$/i; #$1:string

#######################
# operand expressions #
#######################
Readonly our $OP_UNMAPPED           => qr/^\s*UNMAPPED\s*$/i;
Readonly our $OP_OPRTR              => qr/\-|\+|\*|\/|%|&|\||~|<<|>>/;
Readonly our $OP_NO_OPRTR           => qr/[^\-\+\/%&\|~<>\s]/;
Readonly our $OP_TERM               => qr/\%[01]+|[0-9]+|\$[0-9a-fA-F]+|\"(\w)\"|\*|\@/;
Readonly our $OP_BINERY             => qr/^\s*([~\-]?)\s*\%([01_]+)\s*$/; #$1:complement $2:binery number
Readonly our $OP_DEC                => qr/^\s*([~\-]?)\s*([0-9_]+)\s*$/; #$1:complement $2:decimal number
Readonly our $OP_HEX                => qr/^\s*([~\-]?)\s*\$([0-9a-fA-F_]+)\s*$/; #$1:complement $2:hex number
Readonly our $OP_ASCII              => qr/^\s*([~\-]?)\s*[\'\"](.+)[\'\"]\s*$/; #$1:complement $2:ASCII caracter
Readonly our $OP_SYMBOL             => qr/^\s*([~\-]?)\s*([\w]+[\`]?)\s*$/; #$1:complement $2:symbol
#Readonly our $OP_SYMBOL             => qr/^\s*([~\-]?)\s*([\w]+[\`]?|[\`])\s*$/; #$1:complement $2:symbol
Readonly our $OP_CURR_LIN_PC        => qr/^\s*([~\-]?)\s*\@\s*$/;
Readonly our $OP_CURR_PAG_PC        => qr/^\s*([~\-]?)\s*\*\s*$/;
Readonly our $OP_FORMULA            => qr/^\s*($OP_PSOP)\s*$/; #$1:formula
Readonly our $OP_FORMULA_PARS       => qr/^\s*(.*)\s*\(\s*([^\(\)]+)\s*\)\s*(.*)\s*$/; #$1:leftside $2:inside $3:rightside
Readonly our $OP_FORMULA_COMPLEMENT => qr/^\s*([~\-])\s*([~\-].*)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_AND        => qr/^\s*([^\&]*)\s*\&\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_OR         => qr/^\s*([^\|]*)\s*\|\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_EXOR       => qr/^\s*([^\^]*)\s*\^\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_RIGHTSHIFT => qr/^\s*([^>]*)\s*>>\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_LEFTSHIFT  => qr/^\s*([^<]*)\s*<<\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_MUL        => qr/^\s*(.*$OP_NO_OPRTR)\s*\*\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_DIV        => qr/^\s*([^\/]*)\s*\/\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_MOD        => qr/^\s*(.*$OP_NO_OPRTR)\s*\%\s*(.*)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_PLUS       => qr/^\s*([^\+]*)\s*\+\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_FORMULA_MINUS      => qr/^\s*(.*$OP_NO_OPRTR)\s*\-\s*(.+)\s*$/; #$1:leftside $2:rightside
Readonly our $OP_WHITESPACE         => qr/^\s*$/;

########################
# compiler expressions #
########################
Readonly our $CMP_NO_HEXCODE        => qr/^\s*(.*?[^0-9a-fA-F\ ].*?)\s*$/; #$1:string

#############
# cpu types #
#############
Readonly our $CPU_HC11               => qr/^\s*HC11\s*$/i;
Readonly our $CPU_S12                => qr/^\s*((HC)|(S))12\s*$/i;
Readonly our $CPU_S12X               => qr/^\s*S12X\s*$/i;
Readonly our $CPU_XGATE              => qr/^\s*XGATE\s*$/i;

#################
# opcode tables #
#################
#HC11:           MNEMONIC      ADDRESS MODE                                             OPCODE
Readonly our $OPCTAB_HC11 => {
                 "ABA"    => [[$AMOD_INH,               \&check_inh,                    "1B"   ]], #INH
                 "ABX"    => [[$AMOD_INH,               \&check_inh,                    "3A"   ]], #INH
                 "ABY"    => [[$AMOD_INH,               \&check_inh,                    "18 3A"]], #INH
                 "ADCA"   => [[$AMOD_IMM8,              \&check_imm8,                   "89"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "99"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B9"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A9"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A9"]], #IND,Y
                 "ADCB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C9"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D9"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F9"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E9"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E9"]], #IND,Y
                 "ADDA"   => [[$AMOD_IMM8,              \&check_imm8,                   "8B"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9B"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BB"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "AB"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 AB"]], #IND,Y
                 "ADDB"   => [[$AMOD_IMM8,              \&check_imm8,                   "CB"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DB"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FB"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "EB"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 EB"]], #IND,Y
                 "ADDD"   => [[$AMOD_IMM16,             \&check_imm16,                  "C3"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D3"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F3"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E3"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E3"]], #IND,Y
                 "ANDA"   => [[$AMOD_IMM8,              \&check_imm8,                   "84"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "94"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B4"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A4"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A4"]], #IND,Y
                 "ANDB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C4"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D4"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F4"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E4"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E4"]], #IND,Y
                 "ASL"    => [[$AMOD_EXT,               \&check_ext,                    "78"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "68"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 68"]], #IND,Y
                 "ASLA"   => [[$AMOD_INH,               \&check_inh,                    "48"   ]], #INH
                 "ASLB"   => [[$AMOD_INH,               \&check_inh,                    "58"   ]], #INH
                 "ASLD"   => [[$AMOD_INH,               \&check_inh,                    "05"   ]], #INH
                 "ASR"    => [[$AMOD_EXT,               \&check_ext,                    "77"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "67"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 67"]], #IND,Y
                 "ASRA"   => [[$AMOD_INH,               \&check_inh,                    "47"   ]], #INH
                 "ASRB"   => [[$AMOD_INH,               \&check_inh,                    "57"   ]], #INH
                 "BCC"    => [[$AMOD_REL8,              \&check_rel8,                   "24"   ]], #REL
                 "BCLR"   => [[$AMOD_DIR_MSK,           \&check_dir_msk,                "15"   ],  #DIR
                              [$AMOD_HC11_INDX_MSK,     \&check_hc11_indx_msk,          "1D"   ],  #IND,X
                              [$AMOD_HC11_INDY_MSK,     \&check_hc11_indy_msk,          "18 1D"]], #IND,Y
                 "BCS"    => [[$AMOD_REL8,              \&check_rel8,                   "25"   ]], #REL
                 "BEQ"    => [[$AMOD_REL8,              \&check_rel8,                   "27"   ]], #REL
                 "BGE"    => [[$AMOD_REL8,              \&check_rel8,                   "2C"   ]], #REL
                 "BGT"    => [[$AMOD_REL8,              \&check_rel8,                   "2E"   ]], #REL
                 "BHI"    => [[$AMOD_REL8,              \&check_rel8,                   "22"   ]], #REL
                 "BHS"    => [[$AMOD_REL8,              \&check_rel8,                   "24"   ]], #REL
                 "BITA"   => [[$AMOD_IMM8,              \&check_imm8,                   "85"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "95"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B5"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A5"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A5"]], #IND,Y
                 "BITB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C5"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D5"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F5"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E5"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E5"]], #IND,Y
                 "BLE"    => [[$AMOD_REL8,              \&check_rel8,                   "2F"   ]], #REL
                 "BLO"    => [[$AMOD_REL8,              \&check_rel8,                   "25"   ]], #REL
                 "BLS"    => [[$AMOD_REL8,              \&check_rel8,                   "23"   ]], #REL
                 "BLT"    => [[$AMOD_REL8,              \&check_rel8,                   "2D"   ]], #REL
                 "BMI"    => [[$AMOD_REL8,              \&check_rel8,                   "2B"   ]], #REL
                 "BNE"    => [[$AMOD_REL8,              \&check_rel8,                   "26"   ]], #REL
                 "BPL"    => [[$AMOD_REL8,              \&check_rel8,                   "2A"   ]], #REL
                 "BRA"    => [[$AMOD_REL8,              \&check_rel8,                   "20"   ]], #REL
                 "BRCLR"  => [[$AMOD_DIR_MSK_REL,       \&check_dir_msk_rel,            "13"   ],  #DIR
                              [$AMOD_HC11_INDX_MSK_REL, \&check_hc11_indx_msk_rel,      "1F"   ],  #IND,X
                              [$AMOD_HC11_INDY_MSK_REL, \&check_hc11_indy_msk_rel,      "18 1F"]], #IND,Y
                 "BRN"    => [[$AMOD_REL8,              \&check_rel8,                   "21"   ]], #REL
                 "BRSET"  => [[$AMOD_DIR_MSK_REL,       \&check_dir_msk_rel,            "12"   ],  #DIR
                              [$AMOD_HC11_INDX_MSK_REL, \&check_hc11_indx_msk_rel,      "1E"   ],  #IND,X
                              [$AMOD_HC11_INDY_MSK_REL, \&check_hc11_indy_msk_rel,      "18 1E"]], #IND,Y
                 "BSET"   => [[$AMOD_DIR_MSK,           \&check_dir_msk,                "14"   ],  #DIR
                              [$AMOD_HC11_INDX_MSK,     \&check_hc11_indx_msk,          "1C"   ],  #IND,X
                              [$AMOD_HC11_INDY_MSK,     \&check_hc11_indy_msk,          "18 1C"]], #IND,Y
                 "BSR"    => [[$AMOD_REL8,              \&check_rel8,                   "8D"   ]], #REL
                 "BVC"    => [[$AMOD_REL8,              \&check_rel8,                   "28"   ]], #REL
                 "BVS"    => [[$AMOD_REL8,              \&check_rel8,                   "29"   ]], #REL
                 "CBA"    => [[$AMOD_INH,               \&check_inh,                    "11"   ]], #INH
                 "CLC"    => [[$AMOD_INH,               \&check_inh,                    "0C"   ]], #INH
                 "CLI"    => [[$AMOD_INH,               \&check_inh,                    "0E"   ]], #INH
                 "CLR"    => [[$AMOD_EXT,               \&check_ext,                    "7F"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "6F"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 6F"]], #IND,Y
                 "CLRA"   => [[$AMOD_INH,               \&check_inh,                    "4F"   ]], #INH
                 "CLRB"   => [[$AMOD_INH,               \&check_inh,                    "5F"   ]], #INH
                 "CLRD"   => [[$AMOD_INH,               \&check_inh,                    "4F 5F"]], #INH
                 "CLV"    => [[$AMOD_INH,               \&check_inh,                    "0A"   ]], #INH
                 "CMPA"   => [[$AMOD_IMM8,              \&check_imm8,                   "81"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "91"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B1"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A1"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A1"]], #IND,Y
                 "CMPB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C1"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D1"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F1"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E1"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E1"]], #IND,Y
                 "COM"    => [[$AMOD_EXT,               \&check_ext,                    "73"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "63"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 63"]], #IND,Y
                 "COMA"   => [[$AMOD_INH,               \&check_inh,                    "43"   ]], #INH
                 "COMB"   => [[$AMOD_INH,               \&check_inh,                    "53"   ]], #INH
                 "CPD"    => [[$AMOD_IMM16,             \&check_imm16,                  "1A 83"],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "1A 93"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "1A B3"],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "1A A3"],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "CD A3"]], #IND,Y
                 "CPX"    => [[$AMOD_IMM16,             \&check_imm16,                  "8C"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9C"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BC"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "AC"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "CD AC"]], #IND,Y
                 "CPY"    => [[$AMOD_IMM16,             \&check_imm16,                  "18 8D"],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "18 9D"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 BD"],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "1A AC"],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 AC"]], #IND,Y
                 "DAA"    => [[$AMOD_INH,               \&check_inh,                    "19"   ]], #INH
                 "DEC"    => [[$AMOD_EXT,               \&check_ext,                    "7A"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "6A"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 6A"]], #IND,Y
                 "DECA"   => [[$AMOD_INH,               \&check_inh,                    "4A"   ]], #INH
                 "DECB"   => [[$AMOD_INH,               \&check_inh,                    "5A"   ]], #INH
                 "DES"    => [[$AMOD_INH,               \&check_inh,                    "34"   ]], #INH
                 "DEX"    => [[$AMOD_INH,               \&check_inh,                    "09"   ]], #INH
                 "DEY"    => [[$AMOD_INH,               \&check_inh,                    "18 09"]], #INH
                 "EORA"   => [[$AMOD_IMM8,              \&check_imm8,                   "88"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "98"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B8"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A8"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A8"]], #IND,Y
                 "EORB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C8"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D8"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F8"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E8"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E8"]], #IND,Y
                 "FDIV"   => [[$AMOD_INH,               \&check_inh,                    "03"   ]], #INH
                 "IDIV"   => [[$AMOD_INH,               \&check_inh,                    "02"   ]], #INH
                 "INC"    => [[$AMOD_EXT,               \&check_ext,                    "7C"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "6C"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 6C"]], #IND,Y
                 "INCA"   => [[$AMOD_INH,               \&check_inh,                    "4C"   ]], #INH
                 "INCB"   => [[$AMOD_INH,               \&check_inh,                    "5C"   ]], #INH
                 "INS"    => [[$AMOD_INH,               \&check_inh,                    "31"   ]], #INH
                 "INX"    => [[$AMOD_INH,               \&check_inh,                    "08"   ]], #INH
                 "INY"    => [[$AMOD_INH,               \&check_inh,                    "18 08"]], #INH
                 "JMP"    => [[$AMOD_EXT,               \&check_ext,                    "7E"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "6E"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 6E"]], #IND,Y
                 "JSR"    => [[$AMOD_DIR,               \&check_dir,                    "9D"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BD"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "AD"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 AD"]], #IND,Y
                 "LDAA"   => [[$AMOD_IMM8,              \&check_imm8,                   "86"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "96"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B6"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A6"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A6"]], #IND,Y
                 "LDAB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C6"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D6"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F6"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E6"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E6"]], #IND,Y
                 "LDD"    => [[$AMOD_IMM16,             \&check_imm16,                  "CC"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DC"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FC"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "EC"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 EC"]], #IND,Y
                 "LDS"    => [[$AMOD_IMM16,             \&check_imm16,                  "8E"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9E"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BE"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "AE"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 AE"]], #IND,Y
                 "LDX"    => [[$AMOD_IMM16,             \&check_imm16,                  "CE"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DE"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FE"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "EE"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "CD EE"]], #IND,Y
                 "LDY"    => [[$AMOD_IMM16,             \&check_imm16,                  "18 CE"],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "18 DE"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 FE"],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "1A EE"],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 EE"]], #IND,Y
                 "LSL"    => [[$AMOD_EXT,               \&check_ext,                    "78"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "68"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 68"]], #IND,Y
                 "LSLA"   => [[$AMOD_INH,               \&check_inh,                    "48"   ]], #INH
                 "LSLB"   => [[$AMOD_INH,               \&check_inh,                    "58"   ]], #INH
                 "LSLD"   => [[$AMOD_INH,               \&check_inh,                    "05"   ]], #INH
                 "LSR"    => [[$AMOD_EXT,               \&check_ext,                    "74"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "64"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 64"]], #IND,Y
                 "LSRA"   => [[$AMOD_INH,               \&check_inh,                    "44"   ]], #INH
                 "LSRB"   => [[$AMOD_INH,               \&check_inh,                    "54"   ]], #INH
                 "LSRD"   => [[$AMOD_INH,               \&check_inh,                    "04"   ]], #INH
                 "MUL"    => [[$AMOD_INH,               \&check_inh,                    "3D"   ]], #INH
                 "NEG"    => [[$AMOD_EXT,               \&check_ext,                    "70"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "60"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 60"]], #IND,Y
                 "NEGA"   => [[$AMOD_INH,               \&check_inh,                    "40"   ]], #INH
                 "NEGB"   => [[$AMOD_INH,               \&check_inh,                    "50"   ]], #INH
                 "NOP"    => [[$AMOD_INH,               \&check_inh,                    "01"   ]], #INH
                 "ORAA"   => [[$AMOD_IMM8,              \&check_imm8,                   "8A"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9A"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BA"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "AA"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 AA"]], #IND,Y
                 "ORAB"   => [[$AMOD_IMM8,              \&check_imm8,                   "CA"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DA"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FA"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "EA"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 EA"]], #IND,Y
                 "PSHA"   => [[$AMOD_INH,               \&check_inh,                    "36"   ]], #INH
                 "PSHB"   => [[$AMOD_INH,               \&check_inh,                    "37"   ]], #INH
                 "PSHX"   => [[$AMOD_INH,               \&check_inh,                    "3C"   ]], #INH
                 "PSHY"   => [[$AMOD_INH,               \&check_inh,                    "18 3C"]], #INH
                 "PULA"   => [[$AMOD_INH,               \&check_inh,                    "32"   ]], #INH
                 "PULB"   => [[$AMOD_INH,               \&check_inh,                    "33"   ]], #INH
                 "PULX"   => [[$AMOD_INH,               \&check_inh,                    "38"   ]], #INH
                 "PULY"   => [[$AMOD_INH,               \&check_inh,                    "18 38"]], #INH
                 "ROL"    => [[$AMOD_EXT,               \&check_ext,                    "79"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "69"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 69"]], #IND,Y
                 "ROLA"   => [[$AMOD_INH,               \&check_inh,                    "49"   ]], #INH
                 "ROLB"   => [[$AMOD_INH,               \&check_inh,                    "59"   ]], #INH
                 "ROR"    => [[$AMOD_EXT,               \&check_ext,                    "76"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "66"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 66"]], #IND,Y
                 "RORA"   => [[$AMOD_INH,               \&check_inh,                    "46"   ]], #INH
                 "RORB"   => [[$AMOD_INH,               \&check_inh,                    "56"   ]], #INH
                 "RTI"    => [[$AMOD_INH,               \&check_inh,                    "3B"   ]], #INH
                 "RTS"    => [[$AMOD_INH,               \&check_inh,                    "39"   ]], #INH
                 "SBA"    => [[$AMOD_INH,               \&check_inh,                    "10"   ]], #INH
                 "SBCA"   => [[$AMOD_IMM8,              \&check_imm8,                   "82"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "92"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B2"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A2"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A2"]], #IND,Y
                 "SBCB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C2"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D2"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F2"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E2"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E2"]], #IND,Y
                 "SEC"    => [[$AMOD_INH,               \&check_inh,                    "0D"   ]], #INH
                 "SEI"    => [[$AMOD_INH,               \&check_inh,                    "0F"   ]], #INH
                 "SEV"    => [[$AMOD_INH,               \&check_inh,                    "0B"   ]], #INH
                 "STAA"   => [[$AMOD_DIR,               \&check_dir,                    "97"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B7"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A7"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A7"]], #IND,Y
                 "STAB"   => [[$AMOD_DIR,               \&check_dir,                    "D7"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F7"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E7"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E7"]], #IND,Y
                 "STD"    => [[$AMOD_DIR,               \&check_dir,                    "DD"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FD"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "ED"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 ED"]], #IND,Y
                 "STOP"   => [[$AMOD_INH,               \&check_inh,                    "18 3E"]], #INH
                 "STS"    => [[$AMOD_DIR,               \&check_dir,                    "9F"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BF"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "AF"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 AF"]], #IND,Y
                 "STX"    => [[$AMOD_DIR,               \&check_dir,                    "DF"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FF"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "EF"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "CD EF"]], #IND,Y
                 "STY"    => [[$AMOD_DIR,               \&check_dir,                    "18 DF"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 FF"],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "1A EF"],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 EF"]], #IND,Y
                 "SUBA"   => [[$AMOD_IMM8,              \&check_imm8,                   "80"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "90"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B0"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A0"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A0"]], #IND,Y
                 "SUBB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C0"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D0"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F0"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "E0"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 E0"]], #IND,Y
                 "SUBD"   => [[$AMOD_IMM16,             \&check_imm16,                  "83"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "93"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B3"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "A3"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 A3"]], #IND,Y
                 "SWI"    => [[$AMOD_INH,               \&check_inh,                    "3F"   ]], #INH
                 "TAB"    => [[$AMOD_INH,               \&check_inh,                    "16"   ]], #INH
                 "TAP"    => [[$AMOD_INH,               \&check_inh,                    "06"   ]], #INH
                 "TBA"    => [[$AMOD_INH,               \&check_inh,                    "17"   ]], #INH
                 "TEST"   => [[$AMOD_INH,               \&check_inh,                    "00"   ]], #INH
                 "TPA"    => [[$AMOD_INH,               \&check_inh,                    "07"   ]], #INH
                 "TST"    => [[$AMOD_EXT,               \&check_ext,                    "7D"   ],  #EXT
                              [$AMOD_HC11_INDX,         \&check_hc11_indx,              "6D"   ],  #IND,X
                              [$AMOD_HC11_INDY,         \&check_hc11_indy,              "18 6D"]], #IND,Y
                 "TSTA"   => [[$AMOD_INH,               \&check_inh,                    "4D"   ]], #INH
                 "TSTB"   => [[$AMOD_INH,               \&check_inh,                    "5D"   ]], #INH
                 "TSX"    => [[$AMOD_INH,               \&check_inh,                    "30"   ]], #INH
                 "TSY"    => [[$AMOD_INH,               \&check_inh,                    "18 30"]], #INH
                 "TXS"    => [[$AMOD_INH,               \&check_inh,                    "35"   ]], #INH
                 "TYS"    => [[$AMOD_INH,               \&check_inh,                    "18 35"]], #INH
                 "WAI"    => [[$AMOD_INH,               \&check_inh,                    "3E"   ]], #INH
                 "XGDX"   => [[$AMOD_INH,               \&check_inh,                    "8F"   ]], #INH
                 "XGDY"   => [[$AMOD_INH,               \&check_inh,                    "18 8F"]]};#INH

#HC12/S12:      MNEMONIC      ADDRESS MODE                                              OPCODE
Readonly our $OPCTAB_S12 =>  {
                 "ABA"    => [[$AMOD_INH,               \&check_inh,                    "18 06"]], #INH
                 "ABX"    => [[$AMOD_INH,               \&check_inh,                    "1A E5"]], #INH
                 "ABY"    => [[$AMOD_INH,               \&check_inh,                    "19 ED"]], #INH
                 "ADCA"   => [[$AMOD_IMM8,              \&check_imm8,                   "89"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "99"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B9"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A9"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A9"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A9"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A9"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A9"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A9"   ]], #[EXT]
                 "ADCB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C9"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D9"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F9"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E9"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E9"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E9"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E9"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E9"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E9"   ]], #[EXT]
                 "ADDA"   => [[$AMOD_IMM8,              \&check_imm8,                   "8B"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9B"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BB"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AB"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AB"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AB"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AB"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AB"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AB"   ]], #[EXT]
                 "ADDB"   => [[$AMOD_IMM8,              \&check_imm8,                   "CB"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DB"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FB"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EB"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EB"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EB"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EB"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EB"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EB"   ]], #[EXT]
                 "ADDD"   => [[$AMOD_IMM16,             \&check_imm16,                  "C3"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D3"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F3"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E3"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E3"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E3"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E3"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E3"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E3"   ]], #[EXT]
                 "ANDA"   => [[$AMOD_IMM8,              \&check_imm8,                   "84"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "94"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B4"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A4"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A4"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A4"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A4"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A4"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A4"   ]], #[EXT]
                 "ANDB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C4"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D4"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F4"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E4"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E4"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E4"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E4"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E4"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E4"   ]], #[EXT]
                 "ANDCC"  => [[$AMOD_IMM8,              \&check_imm8,                   "10"   ]], #IMM
                 "ASL"    => [[$AMOD_EXT,               \&check_ext,                    "78"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "68"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "68"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "68"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "68"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "68"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "68"   ]], #[EXT]
                 "ASLA"   => [[$AMOD_INH,               \&check_inh,                    "48"   ]], #INH
                 "ASLB"   => [[$AMOD_INH,               \&check_inh,                    "58"   ]], #INH
                 "ASLD"   => [[$AMOD_INH,               \&check_inh,                    "59"   ]], #INH
                 "ASR"    => [[$AMOD_EXT,               \&check_ext,                    "77"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "67"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "67"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "67"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "67"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "67"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "67"   ]], #[EXT]
                 "ASRA"   => [[$AMOD_INH,               \&check_inh,                    "47"   ]], #INH
                 "ASRB"   => [[$AMOD_INH,               \&check_inh,                    "57"   ]], #INH
                 "BCC"    => [[$AMOD_REL8,              \&check_rel8,                   "24"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 24"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "24"   ]], #REL
                 "BCLR"   => [[$AMOD_DIR_MSK,           \&check_dir_msk,                "4D"   ],  #DIR
                              [$AMOD_EXT_MSK,           \&check_ext_msk,                "1D"   ],  #EXT
                              [$AMOD_IDX_MSK,           \&check_idx_msk,                "0D"   ],  #IDX
                              [$AMOD_IDX1_MSK,          \&check_idx1_msk,               "0D"   ],  #IDX1
                              [$AMOD_IDX2_MSK,          \&check_idx2_msk,               "0D"   ]], #IDX2
                 "BCS"    => [[$AMOD_REL8,              \&check_rel8,                   "25"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 25"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "25"   ]], #REL
                 "BEQ"    => [[$AMOD_REL8,              \&check_rel8,                   "27"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 27"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "27"   ]], #REL
                 "BGE"    => [[$AMOD_REL8,              \&check_rel8,                   "2C"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2C"],  #REL
                              [$AMOD_REL8,              \&check_rel8,                   "2C"   ]], #REL
                 "BGND"   => [[$AMOD_INH,               \&check_inh,                    "00"   ]], #INH
                 "BGT"    => [[$AMOD_REL8,              \&check_rel8,                   "2E"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2E"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2E"   ]], #REL
                 "BHI"    => [[$AMOD_REL8,              \&check_rel8,                   "22"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 22"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "22"   ]], #REL
                 "BHS"    => [[$AMOD_REL8,              \&check_rel8,                   "24"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 24"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "24"   ]], #REL
                 "BITA"   => [[$AMOD_IMM8,              \&check_imm8,                   "85"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "95"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B5"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A5"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A5"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A5"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A5"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A5"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A5"   ]], #[EXT]
                 "BITB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C5"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D5"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F5"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E5"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E5"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E5"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E5"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E5"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E5"   ]], #[EXT]
                 "BLE"    => [[$AMOD_REL8,              \&check_rel8,                   "2F"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2F"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2F"   ]], #REL
                 "BLO"    => [[$AMOD_REL8,              \&check_rel8,                   "25"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 25"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "25"   ]], #REL
                 "BLS"    => [[$AMOD_REL8,              \&check_rel8,                   "23"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 23"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "23"   ]], #REL
                 "BLT"    => [[$AMOD_REL8,              \&check_rel8,                   "2D"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2D"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2D"   ]], #REL
                 "BMI"    => [[$AMOD_REL8,              \&check_rel8,                   "2B"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2B"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2B"   ]], #REL
                 "BNE"    => [[$AMOD_REL8,              \&check_rel8,                   "26"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 26"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "26"   ]], #REL
                 "BPL"    => [[$AMOD_REL8,              \&check_rel8,                   "2A"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2A"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2A"   ]], #REL
                 "BRA"    => [[$AMOD_REL8,              \&check_rel8,                   "20"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 20"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "20"   ]], #REL
                 "BRCLR"  => [[$AMOD_DIR_MSK_REL,       \&check_dir_msk_rel,            "4F"   ],  #DIR
                              [$AMOD_EXT_MSK_REL,       \&check_ext_msk_rel,            "1F"   ],  #EXT
                              [$AMOD_IDX_MSK_REL,       \&check_idx_msk_rel,            "0F"   ],  #IDX
                              [$AMOD_IDX1_MSK_REL,      \&check_idx1_msk_rel,           "0F"   ],  #IDX1
                              [$AMOD_IDX2_MSK_REL,      \&check_idx2_msk_rel,           "0F"   ]], #IDX2
                 "BRN"    => [[$AMOD_REL8,              \&check_rel8,                   "21"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 21"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "21"   ]], #REL
                 "BRSET"  => [[$AMOD_DIR_MSK_REL,       \&check_dir_msk_rel,            "4E"   ],  #DIR
                              [$AMOD_EXT_MSK_REL,       \&check_ext_msk_rel,            "1E"   ],  #EXT
                              [$AMOD_IDX_MSK_REL,       \&check_idx_msk_rel,            "0E"   ],  #IDX
                              [$AMOD_IDX1_MSK_REL,      \&check_idx1_msk_rel,           "0E"   ],  #IDX1
                              [$AMOD_IDX2_MSK_REL,      \&check_idx2_msk_rel,           "0E"   ]], #IDX2
                 "BSET"   => [[$AMOD_DIR_MSK,           \&check_dir_msk,                "4C"   ],  #DIR
                              [$AMOD_EXT_MSK,           \&check_ext_msk,                "1C"   ],  #EXT
                              [$AMOD_IDX_MSK,           \&check_idx_msk,                "0C"   ],  #IDX
                              [$AMOD_IDX1_MSK,          \&check_idx1_msk,               "0C"   ],  #IDX1
                              [$AMOD_IDX2_MSK,          \&check_idx2_msk,               "0C"   ]], #IDX2
                 "BSR"    => [[$AMOD_REL8,              \&check_rel8,                   "07"   ]], #REL
                 "BVC"    => [[$AMOD_REL8,              \&check_rel8,                   "28"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 28"]], #REL
                 "BVS"    => [[$AMOD_REL8,              \&check_rel8,                   "29"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 29"]], #REL
                 "CALL"   => [[$AMOD_EXT_PGIMPL,        \&check_ext_pgimpl,             "4A"   ],  #EXT
                              [$AMOD_EXT_PG,            \&check_ext_pg,                 "4A"   ],  #EXT
                              [$AMOD_IDX_PG,            \&check_idx_pg,                 "4B"   ],  #IDX
                              [$AMOD_IDX1_PG,           \&check_idx1_pg,                "4B"   ],  #IDX1
                              [$AMOD_IDX2_PG,           \&check_idx2_pg,                "4B"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "4B"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "4B"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "4B"   ]], #[EXT]
                 "CBA"    => [[$AMOD_INH,               \&check_inh,                    "18 17"]], #INH
                 "CLC"    => [[$AMOD_INH,               \&check_inh,                    "10 FE"]], #INH
                 "CLI"    => [[$AMOD_INH,               \&check_inh,                    "10 EF"]], #INH
                 "CLR"    => [[$AMOD_EXT,               \&check_ext,                    "79"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "69"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "69"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "69"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "69"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "69"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "69"   ]], #[EXT]
                 "CLRA"   => [[$AMOD_INH,               \&check_inh,                    "87"   ]], #INH
                 "CLRB"   => [[$AMOD_INH,               \&check_inh,                    "C7"   ]], #INH
                 "CLRD"   => [[$AMOD_INH,               \&check_inh,                    "87 C7"]], #INH
                 "CLV"    => [[$AMOD_INH,               \&check_inh,                    "10 FD"]], #INH
                 "CMPA"   => [[$AMOD_IMM8,              \&check_imm8,                   "81"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "91"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B1"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A1"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A1"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A1"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A1"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A1"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A1"   ]], #[EXT]
                 "CMPB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C1"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D1"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F1"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E1"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E1"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E1"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E1"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E1"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E1"   ]], #[EXT]
                 "COM"    => [[$AMOD_EXT,               \&check_ext,                    "71"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "61"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "61"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "61"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "61"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "61"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "61"   ]], #[EXT]
                 "COMA"   => [[$AMOD_INH,               \&check_inh,                    "41"   ]], #INH
                 "COMB"   => [[$AMOD_INH,               \&check_inh,                    "51"   ]], #INH
                 "CPD"    => [[$AMOD_IMM16,             \&check_imm16,                  "8C"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9C"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BC"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AC"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AC"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AC"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AC"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AC"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AC"   ]], #[EXT]
                 "CPS"    => [[$AMOD_IMM16,             \&check_imm16,                  "8F"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9F"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BF"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AF"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AF"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AF"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AF"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AF"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AF"   ]], #[EXT]
                 "CPX"    => [[$AMOD_IMM16,             \&check_imm16,                  "8E"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9E"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BE"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AE"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AE"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AE"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AE"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AE"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AE"   ]], #[EXT]
                 "CPY"    => [[$AMOD_IMM16,             \&check_imm16,                  "8D"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9D"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BD"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AD"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AD"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AD"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AD"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AD"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AD"   ]], #[EXT]
                 "DAA"    => [[$AMOD_INH,               \&check_inh,                    "18 07"]], #INH
                 "DBEQ"   => [[$AMOD_DBEQ,              \&check_dbeq,                   "04"   ]], #REL
                 "DBNE"   => [[$AMOD_DBNE,              \&check_dbne,                   "04"   ]], #REL
                 "DEC"    => [[$AMOD_EXT,               \&check_ext,                    "73"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "63"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "63"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "63"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "63"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "63"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "63"   ]], #[EXT]
                 "DECA"   => [[$AMOD_INH,               \&check_inh,                    "43"   ]], #INH
                 "DECB"   => [[$AMOD_INH,               \&check_inh,                    "53"   ]], #INH
                 "DES"    => [[$AMOD_INH,               \&check_inh,                    "1B 9F"]], #INH
                 "DEX"    => [[$AMOD_INH,               \&check_inh,                    "09"   ]], #INH
                 "DEY"    => [[$AMOD_INH,               \&check_inh,                    "03"   ]], #INH
                 "EDIV"   => [[$AMOD_INH,               \&check_inh,                    "11"   ]], #INH
                 "EDIVS"  => [[$AMOD_INH,               \&check_inh,                    "18 14"]], #INH
                 "EMACS"  => [[$AMOD_EXT,               \&check_ext,                    "18 12"]], #EXT
                 "EMAXD"  => [[$AMOD_IDX,               \&check_idx,                    "18 1A"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1A"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1A"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1A"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1A"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1A"]], #[EXT]
                 "EMAXM"  => [[$AMOD_IDX,               \&check_idx,                    "18 1E"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1E"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1E"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1E"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1E"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1E"]], #[EXT]
                 "EMIND"  => [[$AMOD_IDX,               \&check_idx,                    "18 1B"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1B"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1B"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1B"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1B"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1B"]], #[EXT]
                 "EMINM"  => [[$AMOD_IDX,               \&check_idx,                    "18 1F"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1F"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1F"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1F"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1F"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1F"]], #[EXT]
                 "EMUL"   => [[$AMOD_INH,               \&check_inh,                    "13"   ]], #INH
                 "EMULS"  => [[$AMOD_INH,               \&check_inh,                    "18 13"]], #INH
                 "EORA"   => [[$AMOD_IMM8,              \&check_imm8,                   "88"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "98"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B8"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A8"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A8"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A8"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A8"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A8"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A8"   ]], #[EXT]
                 "EORB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C8"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D8"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F8"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E8"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E8"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E8"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E8"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E8"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E8"   ]], #[EXT]
                 "ETBL"   => [[$AMOD_IDX,               \&check_idx,                    "18 3F"]], #IDX
                 "EXG"    => [[$AMOD_EXG,               \&check_exg,                    "B7"   ]], #INH
                 "FDIV"   => [[$AMOD_INH,               \&check_inh,                    "18 11"]], #INH
                 "IBEQ"   => [[$AMOD_IBEQ,              \&check_ibeq,                   "04"   ]], #REL
                 "IBNE"   => [[$AMOD_IBNE,              \&check_ibne,                   "04"   ]], #REL
                 "IDIV"   => [[$AMOD_INH,               \&check_inh,                    "18 10"]], #INH
                 "IDIVS"  => [[$AMOD_INH,               \&check_inh,                    "18 15"]], #INH
                 "INC"    => [[$AMOD_EXT,               \&check_ext,                    "72"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "62"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "62"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "62"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "62"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "62"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "62"   ]], #[EXT]
                 "INCA"   => [[$AMOD_INH,               \&check_inh,                    "42"   ]], #INH
                 "INCB"   => [[$AMOD_INH,               \&check_inh,                    "52"   ]], #INH
                 "INS"    => [[$AMOD_INH,               \&check_inh,                    "1B 81"]], #INH
                 "INX"    => [[$AMOD_INH,               \&check_inh,                    "08"   ]], #INH
                 "INY"    => [[$AMOD_INH,               \&check_inh,                    "02"   ]], #INH
                 "JMP"    => [[$AMOD_EXT,               \&check_ext,                    "06"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "05"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "05"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "05"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "05"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "05"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "05"   ]], #[EXT]
                 "JOB"    => [[$AMOD_REL8,              \&check_rel8,                   "20"   ],  #REL
                              [$AMOD_EXT,               \&check_ext,                    "06"   ]], #EXT
                 "JOBSR"  => [[$AMOD_REL8,              \&check_rel8,                   "07"   ],  #REL
                              [$AMOD_EXT,               \&check_ext,                    "16"   ]], #EXT
                 "JSR"    => [[$AMOD_DIR,               \&check_dir,                    "17"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "16"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "15"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "15"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "15"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "15"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "15"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "15"   ]], #[EXT]
                 "LBCC"   => [[$AMOD_REL16,             \&check_rel16,                  "18 24"]], #REL
                 "LBCS"   => [[$AMOD_REL16,             \&check_rel16,                  "18 25"]], #REL
                 "LBEQ"   => [[$AMOD_REL16,             \&check_rel16,                  "18 27"]], #REL
                 "LBGE"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2C"]], #REL
                 "LBGT"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2E"]], #REL
                 "LBHI"   => [[$AMOD_REL16,             \&check_rel16,                  "18 22"]], #REL
                 "LBHS"   => [[$AMOD_REL16,             \&check_rel16,                  "18 24"]], #REL
                 "LBLE"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2F"]], #REL
                 "LBLO"   => [[$AMOD_REL16,             \&check_rel16,                  "18 25"]], #REL
                 "LBLS"   => [[$AMOD_REL16,             \&check_rel16,                  "18 23"]], #REL
                 "LBLT"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2D"]], #REL
                 "LBMI"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2B"]], #REL
                 "LBNE"   => [[$AMOD_REL16,             \&check_rel16,                  "18 26"]], #REL
                 "LBPL"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2A"]], #REL
                 "LBRA"   => [[$AMOD_REL16,             \&check_rel16,                  "18 20"]], #REL
                 "LBRN"   => [[$AMOD_REL16,             \&check_rel16,                  "18 21"]], #REL
                 "LBVC"   => [[$AMOD_REL16,             \&check_rel16,                  "18 28"]], #REL
                 "LBVS"   => [[$AMOD_REL16,             \&check_rel16,                  "18 29"]], #REL
                 "LDAA"   => [[$AMOD_IMM8,              \&check_imm8,                   "86"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "96"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B6"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A6"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A6"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A6"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A6"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A6"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A6"   ]], #[EXT]
                 "LDAB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C6"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D6"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F6"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E6"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E6"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E6"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E6"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E6"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E6"   ]], #[EXT]
                 "LDD"    => [[$AMOD_IMM16,             \&check_imm16,                  "CC"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DC"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FC"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EC"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EC"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EC"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EC"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EC"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EC"   ]], #[EXT]
                 "LDS"    => [[$AMOD_IMM16,             \&check_imm16,                  "CF"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DF"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FF"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EF"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EF"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EF"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EF"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EF"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EF"   ]], #[EXT]
                 "LDX"    => [[$AMOD_IMM16,             \&check_imm16,                  "CE"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DE"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FE"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EE"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EE"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EE"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EE"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EE"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EE"   ]], #[EXT]
                 "LDY"    => [[$AMOD_IMM16,             \&check_imm16,                  "CD"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DD"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FD"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "ED"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "ED"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "ED"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "ED"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "ED"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "ED"   ]], #[EXT]
                 "LEAS"   => [[$AMOD_IDX,               \&check_idx,                    "1B"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "1B"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "1B"   ]], #IDX2
                 "LEAX"   => [[$AMOD_IDX,               \&check_idx,                    "1A"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "1A"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "1A"   ]], #IDX2
                 "LEAY"   => [[$AMOD_IDX,               \&check_idx,                    "19"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "19"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "19"   ]], #IDX2
                 "LSL"    => [[$AMOD_EXT,               \&check_ext,                    "78"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "68"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "68"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "68"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "68"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "68"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "68"   ]], #[EXT]
                 "LSLA"   => [[$AMOD_INH,               \&check_inh,                    "48"   ]], #INH
                 "LSLB"   => [[$AMOD_INH,               \&check_inh,                    "58"   ]], #INH
                 "LSLD"   => [[$AMOD_INH,               \&check_inh,                    "59"   ]], #INH
                 "LSR"    => [[$AMOD_EXT,               \&check_ext,                    "74"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "64"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "64"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "64"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "64"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "64"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "64"   ]], #[EXT]
                 "LSRA"   => [[$AMOD_INH,               \&check_inh,                    "44"   ]], #INH
                 "LSRB"   => [[$AMOD_INH,               \&check_inh,                    "54"   ]], #INH
                 "LSRD"   => [[$AMOD_INH,               \&check_inh,                    "49"   ]], #INH
                 "MAXA"   => [[$AMOD_IDX,               \&check_idx,                    "18 18"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 18"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 18"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 18"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 18"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 18"]], #[EXT]
                 "MAXM"   => [[$AMOD_IDX,               \&check_idx,                    "18 1C"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1C"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1C"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1C"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1C"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1C"]], #[EXT]
                 "MEM"    => [[$AMOD_INH,               \&check_inh,                    "01"   ]], #INH
                 "MINA"   => [[$AMOD_IDX,               \&check_idx,                    "18 19"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 19"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 19"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 19"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 19"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 19"]], #[EXT]
                 "MINM"   => [[$AMOD_IDX,               \&check_idx,                    "18 1D"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1D"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1D"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1D"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1D"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1D"]], #[EXT]
                 "MOVB"   => [[$AMOD_IMM8_EXT,          \&check_imm8_ext,               "18 0B"],  #IMM-EXT
                              [$AMOD_IMM8_IDX,          \&check_imm8_idx,               "18 08"],  #IMM-IDX
                              [$AMOD_EXT_EXT,           \&check_ext_ext,                "18 0C"],  #EXT-EXT
                              [$AMOD_EXT_IDX,           \&check_ext_idx,                "18 09"],  #EXT-IDX
                              [$AMOD_IDX_EXT,           \&check_idx_ext,                "18 0D"],  #IDX-EXT
                              [$AMOD_IDX_IDX,           \&check_idx_idx,                "18 0A"]], #IDX-IDX
                 "MOVW"   => [[$AMOD_IMM16_EXT,         \&check_imm16_ext,              "18 03"],  #IMM-EXT
                              [$AMOD_IMM16_IDX,         \&check_imm16_idx,              "18 00"],  #IMM-IDX
                              [$AMOD_EXT_EXT,           \&check_ext_ext,                "18 04"],  #EXT-EXT
                              [$AMOD_EXT_IDX,           \&check_ext_idx,                "18 01"],  #EXT-IDX
                              [$AMOD_IDX_EXT,           \&check_idx_ext,                "18 05"],  #IDX-EXT
                              [$AMOD_IDX_IDX,           \&check_idx_idx,                "18 02"]], #IDX-IDX
                 "MUL"    => [[$AMOD_INH,               \&check_inh,                    "12"   ]], #INH
                 "NEG"    => [[$AMOD_EXT,               \&check_ext,                    "70"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "60"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "60"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "60"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "60"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "60"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "60"   ]], #[EXT]
                 "NEGA"   => [[$AMOD_INH,               \&check_inh,                    "40"   ]], #INH
                 "NEGB"   => [[$AMOD_INH,               \&check_inh,                    "50"   ]], #INH
                 "NOP"    => [[$AMOD_INH,               \&check_inh,                    "A7"   ]], #INH
                 "ORAA"   => [[$AMOD_IMM8,              \&check_imm8,                   "8A"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "9A"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BA"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AA"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AA"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AA"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AA"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AA"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AA"   ]], #[EXT]
                 "ORAB"   => [[$AMOD_IMM8,              \&check_imm8,                   "CA"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "DA"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FA"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EA"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EA"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EA"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EA"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EA"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EA"   ]], #[EXT]
                 "ORCC"   => [[$AMOD_IMM8,              \&check_imm8,                   "14"   ]], #INH
                 "PSHA"   => [[$AMOD_INH,               \&check_inh,                    "36"   ]], #INH
                 "PSHB"   => [[$AMOD_INH,               \&check_inh,                    "37"   ]], #INH
                 "PSHC"   => [[$AMOD_INH,               \&check_inh,                    "39"   ]], #INH
                 "PSHD"   => [[$AMOD_INH,               \&check_inh,                    "3B"   ]], #INH
                 "PSHX"   => [[$AMOD_INH,               \&check_inh,                    "34"   ]], #INH
                 "PSHY"   => [[$AMOD_INH,               \&check_inh,                    "35"   ]], #INH
                 "PULA"   => [[$AMOD_INH,               \&check_inh,                    "32"   ]], #INH
                 "PULB"   => [[$AMOD_INH,               \&check_inh,                    "33"   ]], #INH
                 "PULC"   => [[$AMOD_INH,               \&check_inh,                    "38"   ]], #INH
                 "PULD"   => [[$AMOD_INH,               \&check_inh,                    "3A"   ]], #INH
                 "PULX"   => [[$AMOD_INH,               \&check_inh,                    "30"   ]], #INH
                 "PULY"   => [[$AMOD_INH,               \&check_inh,                    "31"   ]], #INH
                 "REV"    => [[$AMOD_INH,               \&check_inh,                    "18 3A"]], #INH
                 "REVW"   => [[$AMOD_INH,               \&check_inh,                    "18 3B"]], #INH
                 "ROL"    => [[$AMOD_EXT,               \&check_ext,                    "75"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "65"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "65"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "65"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "65"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "65"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "65"   ]], #[EXT]
                 "ROLA"   => [[$AMOD_INH,               \&check_inh,                    "45"   ]], #INH
                 "ROLB"   => [[$AMOD_INH,               \&check_inh,                    "55"   ]], #INH
                 "ROR"    => [[$AMOD_EXT,               \&check_ext,                    "76"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "66"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "66"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "66"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "66"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "66"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "66"   ]], #[EXT]
                 "RORA"   => [[$AMOD_INH,               \&check_inh,                    "46"   ]], #INH
                 "RORB"   => [[$AMOD_INH,               \&check_inh,                    "56"   ]], #INH
                 "RTC"    => [[$AMOD_INH,               \&check_inh,                    "0A"   ]], #INH
                 "RTI"    => [[$AMOD_INH,               \&check_inh,                    "0B"   ]], #INH
                 "RTS"    => [[$AMOD_INH,               \&check_inh,                    "3D"   ]], #INH
                 "SBA"    => [[$AMOD_INH,               \&check_inh,                    "18 16"]], #INH
                 "SBCA"   => [[$AMOD_IMM8,              \&check_imm8,                   "82"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "92"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B2"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A2"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A2"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A2"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A2"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A2"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A2"   ]], #[EXT]
                 "SBCB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C2"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D2"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F2"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E2"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E2"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E2"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E2"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E2"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E2"   ]], #[EXT]
                 "SEC"    => [[$AMOD_INH,               \&check_inh,                    "14 01"]], #INH
                 "SEI"    => [[$AMOD_INH,               \&check_inh,                    "14 10"]], #INH
                 "SEV"    => [[$AMOD_INH,               \&check_inh,                    "14 02"]], #INH
                 "SEX"    => [[$AMOD_TFR,               \&check_sex,                    "B7"   ]], #INH
                 "STAA"   => [[$AMOD_DIR,               \&check_dir,                    "5A"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7A"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6A"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6A"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6A"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6A"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6A"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6A"   ]], #[EXT]
                 "STAB"   => [[$AMOD_DIR,               \&check_dir,                    "5B"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7B"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6B"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6B"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6B"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6B"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6B"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6B"   ]], #[EXT]
                 "STD"    => [[$AMOD_DIR,               \&check_dir,                    "5C"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7C"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6C"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6C"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6C"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6C"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6C"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6C"   ]], #[EXT]
                 "STOP"   => [[$AMOD_INH,               \&check_inh,                    "18 3E"]], #INH
                 "STS"    => [[$AMOD_DIR,               \&check_dir,                    "5F"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7F"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6F"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6F"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6F"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6F"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6F"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6F"   ]], #[EXT]
                 "STX"    => [[$AMOD_DIR,               \&check_dir,                    "5E"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7E"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6E"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6E"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6E"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6E"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6E"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6E"   ]], #[EXT]
                 "STY"    => [[$AMOD_DIR,               \&check_dir,                    "5D"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7D"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6D"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6D"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6D"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6D"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6D"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6D"   ]], #[EXT]
                 "SUBA"   => [[$AMOD_IMM8,              \&check_imm8,                   "80"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "90"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B0"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A0"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A0"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A0"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A0"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A0"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A0"   ]], #[EXT]
                 "SUBB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C0"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "D0"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F0"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E0"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E0"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E0"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E0"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E0"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E0"   ]], #[EXT]
                 "SUBD"   => [[$AMOD_IMM16,             \&check_imm16,                  "83"   ],  #IMM
                              [$AMOD_DIR,               \&check_dir,                    "93"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B3"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A3"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A3"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A3"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A3"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A3"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A3"   ]], #[EXT]
                 "SWI"    => [[$AMOD_INH,               \&check_inh,                    "3F"   ]], #INH
                 "TAB"    => [[$AMOD_INH,               \&check_inh,                    "18 0E"]], #INH
                 "TAP"    => [[$AMOD_INH,               \&check_inh,                    "B7 02"]], #INH
                 "TBA"    => [[$AMOD_INH,               \&check_inh,                    "18 0F"]], #INH
                 "TBEQ"   => [[$AMOD_TBEQ,              \&check_tbeq,                   "04"   ]], #REL
                 "TBL"    => [[$AMOD_IDX,               \&check_idx,                    "18 3D"]], #IDX
                 "TBNE"   => [[$AMOD_TBNE,              \&check_tbne,                   "04"   ]], #REL
                 "TFR"    => [[$AMOD_TFR,               \&check_tfr,                    "B7"   ]], #INH
                 "TPA"    => [[$AMOD_INH,               \&check_inh,                    "B7 20"]], #INH
                 "TRAP"   => [[$AMOD_TRAP,              \&check_trap,                   "18"   ]], #INH
                 "TST"    => [[$AMOD_EXT,               \&check_ext,                    "F7"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E7"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E7"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E7"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E7"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E7"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E7"   ]], #[EXT]
                 "TSTA"   => [[$AMOD_INH,               \&check_inh,                    "97"   ]], #INH
                 "TSTB"   => [[$AMOD_INH,               \&check_inh,                    "D7"   ]], #INH
                 "TSX"    => [[$AMOD_INH,               \&check_inh,                    "B7 75"]], #INH
                 "TSY"    => [[$AMOD_INH,               \&check_inh,                    "B7 76"]], #INH
                 "TXS"    => [[$AMOD_INH,               \&check_inh,                    "B7 57"]], #INH
                 "TYS"    => [[$AMOD_INH,               \&check_inh,                    "B7 67"]], #INH
                 "WAI"    => [[$AMOD_INH,               \&check_inh,                    "3E"   ]], #INH
                 "WAV"    => [[$AMOD_INH,               \&check_inh,                    "18 3C"]], #INH
                 "WAVR"   => [[$AMOD_INH,               \&check_inh,                    "3C"   ]], #INH
                 "XGDX"   => [[$AMOD_INH,               \&check_inh,                    "B7 C5"]], #INH
                 "XGDY"   => [[$AMOD_INH,               \&check_inh,                    "B7 C6"]]};#INH

#S12X:           MNEMONIC     ADDRESS MODE                                               OPCODE
Readonly our $OPCTAB_S12X => {
                 "ABA"    => [[$AMOD_INH,               \&check_inh,                    "18 06"]], #INH
                 "ABX"    => [[$AMOD_INH,               \&check_inh,                    "1A E5"]], #INH
                 "ABY"    => [[$AMOD_INH,               \&check_inh,                    "19 ED"]], #INH
                 "ADCA"   => [[$AMOD_IMM8,              \&check_imm8,                   "89"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "99"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B9"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A9"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A9"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A9"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A9"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A9"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A9"   ]], #[EXT]
                 "ADCB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C9"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D9"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F9"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E9"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E9"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E9"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E9"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E9"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E9"   ]], #[EXT]
                 "ADED"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 C3"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 D3"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 F3"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E3"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E3"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E3"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E3"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E3"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E3"]], #[EXT]
                 "ADEX"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 89"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 99"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 B9"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 A9"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 A9"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 A9"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 A9"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E3"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E3"]], #[EXT]
                 "ADEY"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 C9"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 D9"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 F9"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E9"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E9"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E9"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E9"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E9"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E9"]], #[EXT]
                 "ADDA"   => [[$AMOD_IMM8,              \&check_imm8,                   "8B"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "9B"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BB"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AB"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AB"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AB"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AB"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AB"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AB"   ]], #[EXT]
                 "ADDB"   => [[$AMOD_IMM8,              \&check_imm8,                   "CB"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "DB"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FB"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EB"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EB"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EB"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EB"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EB"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EB"   ]], #[EXT]
                 "ADDD"   => [[$AMOD_IMM16,             \&check_imm16,                  "C3"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D3"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F3"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E3"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E3"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E3"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E3"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E3"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E3"   ]], #[EXT]
                 "ADDX"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 8B"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 9B"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 BB"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 AB"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 AB"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 AB"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 AB"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 AB"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 AB"]], #[EXT]
                 "ADDY"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 CB"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 DB"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 FB"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 EB"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 EB"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 EB"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 EB"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 EB"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 EB"]], #[EXT]
                 "ANDA"   => [[$AMOD_IMM8,              \&check_imm8,                   "84"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "94"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B4"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A4"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A4"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A4"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A4"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A4"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A4"   ]], #[EXT]
                 "ANDB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C4"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D4"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F4"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E4"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E4"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E4"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E4"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E4"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E4"   ]], #[EXT]
                 "ANDX"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 84"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 94"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 B4"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 A4"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 A4"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 A4"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 A4"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 A4"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 A4"]], #[EXT]
                 "ANDY"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 C4"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 D4"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 F4"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E4"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E4"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E4"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E4"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E4"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E4"]], #[EXT]
                 "ANDCC"  => [[$AMOD_IMM8,              \&check_imm8,                   "10"   ]], #IMM
                 "ASL"    => [[$AMOD_EXT,               \&check_ext,                    "78"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "68"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "68"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "68"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "68"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "68"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "68"   ]], #[EXT]
                 "ASLA"   => [[$AMOD_INH,               \&check_inh,                    "48"   ]], #INH
                 "ASLB"   => [[$AMOD_INH,               \&check_inh,                    "58"   ]], #INH
                 "ANDCC"  => [[$AMOD_IMM8,              \&check_imm8,                   "10"   ]], #IMM
                 "ASLW"   => [[$AMOD_EXT,               \&check_ext,                    "18 78"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 68"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 68"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 68"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 68"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 68"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 68"]], #[EXT]
                 "ASLX"   => [[$AMOD_INH,               \&check_inh,                    "18 48"]], #INH
                 "ASLY"   => [[$AMOD_INH,               \&check_inh,                    "18 58"]], #INH
                 "ASLD"   => [[$AMOD_INH,               \&check_inh,                    "59"   ]], #INH
                 "ASR"    => [[$AMOD_EXT,               \&check_ext,                    "77"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "67"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "67"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "67"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "67"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "67"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "67"   ]], #[EXT]
                 "ASRA"   => [[$AMOD_INH,               \&check_inh,                    "47"   ]], #INH
                 "ASRB"   => [[$AMOD_INH,               \&check_inh,                    "57"   ]], #INH
                 "ASRW"   => [[$AMOD_EXT,               \&check_ext,                    "18 77"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 67"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 67"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 67"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 67"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 67"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 67"]], #[EXT]
                 "ASRX"   => [[$AMOD_INH,               \&check_inh,                    "18 47"]], #INH
                 "ASRY"   => [[$AMOD_INH,               \&check_inh,                    "18 57"]], #INH
                 "BCC"    => [[$AMOD_REL8,              \&check_rel8,                   "24"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 24"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "24"   ]], #REL
                 "BCLR"   => [[$AMOD_S12X_DIR_MSK,      \&check_s12x_dir_msk,           "4D"   ],  #DIR
                              [$AMOD_EXT_MSK,           \&check_ext_msk,                "1D"   ],  #EXT
                              [$AMOD_IDX_MSK,           \&check_idx_msk,                "0D"   ],  #IDX
                              [$AMOD_IDX1_MSK,          \&check_idx1_msk,               "0D"   ],  #IDX1
                              [$AMOD_IDX2_MSK,          \&check_idx2_msk,               "0D"   ]], #IDX2
                 "BCS"    => [[$AMOD_REL8,              \&check_rel8,                   "25"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 25"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "25"   ]], #REL
                 "BEQ"    => [[$AMOD_REL8,              \&check_rel8,                   "27"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 27"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "27"   ]], #REL
                 "BGE"    => [[$AMOD_REL8,              \&check_rel8,                   "2C"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2C"],  #REL
                              [$AMOD_REL8,              \&check_rel8,                   "2C"   ]], #REL
                 "BGND"   => [[$AMOD_INH,               \&check_inh,                    "00"   ]], #INH
                 "BGT"    => [[$AMOD_REL8,              \&check_rel8,                   "2E"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2E"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2E"   ]], #REL
                 "BHI"    => [[$AMOD_REL8,              \&check_rel8,                   "22"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 22"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "22"   ]], #REL
                 "BHS"    => [[$AMOD_REL8,              \&check_rel8,                   "24"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 24"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "24"   ]], #REL
                 "BITA"   => [[$AMOD_IMM8,              \&check_imm8,                   "85"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "95"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B5"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A5"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A5"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A5"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A5"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A5"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A5"   ]], #[EXT]
                 "BITB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C5"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D5"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F5"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E5"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E5"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E5"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E5"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E5"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E5"   ]], #[EXT]
                 "BITX"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 85"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 95"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 B5"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 A5"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 A5"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 A5"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 A5"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 A5"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 A5"]], #[EXT]
                 "BITY"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 C5"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 D5"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 F5"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E5"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E5"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E5"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E5"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E5"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E5"]], #[EXT]
                 "BLE"    => [[$AMOD_REL8,              \&check_rel8,                   "2F"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2F"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2F"   ]], #REL
                 "BLO"    => [[$AMOD_REL8,              \&check_rel8,                   "25"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 25"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "25"   ]], #REL
                 "BLS"    => [[$AMOD_REL8,              \&check_rel8,                   "23"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 23"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "23"   ]], #REL
                 "BLT"    => [[$AMOD_REL8,              \&check_rel8,                   "2D"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2D"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2D"   ]], #REL
                 "BMI"    => [[$AMOD_REL8,              \&check_rel8,                   "2B"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2B"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2B"   ]], #REL
                 "BNE"    => [[$AMOD_REL8,              \&check_rel8,                   "26"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 26"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "26"   ]], #REL
                 "BPL"    => [[$AMOD_REL8,              \&check_rel8,                   "2A"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 2A"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "2A"   ]], #REL
                 "BRA"    => [[$AMOD_REL8,              \&check_rel8,                   "20"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 20"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "20"   ]], #REL
                 "BRCLR"  => [[$AMOD_S12X_DIR_MSK_REL,  \&check_s12x_dir_msk_rel,       "4F"   ],  #DIR
                              [$AMOD_EXT_MSK_REL,       \&check_ext_msk_rel,            "1F"   ],  #EXT
                              [$AMOD_IDX_MSK_REL,       \&check_idx_msk_rel,            "0F"   ],  #IDX
                              [$AMOD_IDX1_MSK_REL,      \&check_idx1_msk_rel,           "0F"   ],  #IDX1
                              [$AMOD_IDX2_MSK_REL,      \&check_idx2_msk_rel,           "0F"   ]], #IDX2
                 "BRN"    => [[$AMOD_REL8,              \&check_rel8,                   "21"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 21"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "21"   ]], #REL
                 "BRSET"  => [[$AMOD_S12X_DIR_MSK_REL,  \&check_s12x_dir_msk_rel,       "4E"   ],  #DIR
                              [$AMOD_EXT_MSK_REL,       \&check_ext_msk_rel,            "1E"   ],  #EXT
                              [$AMOD_IDX_MSK_REL,       \&check_idx_msk_rel,            "0E"   ],  #IDX
                              [$AMOD_IDX1_MSK_REL,      \&check_idx1_msk_rel,           "0E"   ],  #IDX1
                              [$AMOD_IDX2_MSK_REL,      \&check_idx2_msk_rel,           "0E"   ]], #IDX2
                 "BSET"   => [[$AMOD_S12X_DIR_MSK,      \&check_s12x_dir_msk,           "4C"   ],  #DIR
                              [$AMOD_EXT_MSK,           \&check_ext_msk,                "1C"   ],  #EXT
                              [$AMOD_IDX_MSK,           \&check_idx_msk,                "0C"   ],  #IDX
                              [$AMOD_IDX1_MSK,          \&check_idx1_msk,               "0C"   ],  #IDX1
                              [$AMOD_IDX2_MSK,          \&check_idx2_msk,               "0C"   ]], #IDX2
                 "BSR"    => [[$AMOD_REL8,              \&check_rel8,                   "07"   ]], #REL
                 "BVC"    => [[$AMOD_REL8,              \&check_rel8,                   "28"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 28"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "28"   ]], #REL
                 "BVS"    => [[$AMOD_REL8,              \&check_rel8,                   "29"   ],  #REL
                              [$AMOD_REL16,             \&check_rel16,                  "18 29"],  #REL
                              [$AMOD_REL8_FORCED,       \&check_rel8_forced,            "29"   ]], #REL
                 "BTAS"   => [[$AMOD_S12X_DIR_MSK,      \&check_s12x_dir_msk,           "18 35"],  #DIR
                              [$AMOD_EXT_MSK,           \&check_ext_msk,                "18 36"],  #EXT
                              [$AMOD_IDX_MSK,           \&check_idx_msk,                "18 37"],  #IDX
                              [$AMOD_IDX1_MSK,          \&check_idx1_msk,               "18 37"],  #IDX1
                              [$AMOD_IDX2_MSK,          \&check_idx2_msk,               "18 37"]], #IDX2
                 "CALL"   => [[$AMOD_EXT_PGIMPL,        \&check_ext_pgimpl,             "4A"   ],  #EXT
                              [$AMOD_EXT_PG,            \&check_ext_pg,                 "4A"   ],  #EXT
                              [$AMOD_IDX_PG,            \&check_idx_pg,                 "4B"   ],  #IDX
                              [$AMOD_IDX1_PG,           \&check_idx1_pg,                "4B"   ],  #IDX1
                              [$AMOD_IDX2_PG,           \&check_idx2_pg,                "4B"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "4B"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "4B"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "4B"   ]], #[EXT]
                 "CBA"    => [[$AMOD_INH,               \&check_inh,                    "18 17"]], #INH
                 "CLC"    => [[$AMOD_INH,               \&check_inh,                    "10 FE"]], #INH
                 "CLI"    => [[$AMOD_INH,               \&check_inh,                    "10 EF"]], #INH
                 "CLR"    => [[$AMOD_EXT,               \&check_ext,                    "79"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "69"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "69"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "69"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "69"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "69"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "69"   ]], #[EXT]
                 "CLRA"   => [[$AMOD_INH,               \&check_inh,                    "87"   ]], #INH
                 "CLRB"   => [[$AMOD_INH,               \&check_inh,                    "C7"   ]], #INH
                 "CLRD"   => [[$AMOD_INH,               \&check_inh,                    "87 C7"]], #INH
                 "CLRW"   => [[$AMOD_EXT,               \&check_ext,                    "18 79"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 69"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 69"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 69"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 69"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 69"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 69"]], #[EXT]
                 "CLRX"   => [[$AMOD_INH,               \&check_inh,                    "18 87"]], #INH
                 "CLRY"   => [[$AMOD_INH,               \&check_inh,                    "18 C7"]], #INH
                 "CLV"    => [[$AMOD_INH,               \&check_inh,                    "10 FD"]], #INH
                 "CMPA"   => [[$AMOD_IMM8,              \&check_imm8,                   "81"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "91"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B1"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A1"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A1"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A1"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A1"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A1"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A1"   ]], #[EXT]
                 "CMPB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C1"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D1"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F1"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E1"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E1"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E1"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E1"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E1"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E1"   ]], #[EXT]
                 "COM"    => [[$AMOD_EXT,               \&check_ext,                    "71"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "61"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "61"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "61"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "61"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "61"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "61"   ]], #[EXT]
                 "COMA"   => [[$AMOD_INH,               \&check_inh,                    "41"   ]], #INH
                 "COMB"   => [[$AMOD_INH,               \&check_inh,                    "51"   ]], #INH
                 "COMW"   => [[$AMOD_EXT,               \&check_ext,                    "18 71"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 61"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 61"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 61"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 61"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 61"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 61"]], #[EXT]
                 "COMX"   => [[$AMOD_INH,               \&check_inh,                    "18 41"]], #INH
                 "COMY"   => [[$AMOD_INH,               \&check_inh,                    "18 51"]], #INH
                 "CPED"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 8C"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 9C"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 BC"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 AC"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 AC"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 AC"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 AC"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 AC"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 AC"]], #[EXT]
                 "CPES"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 8F"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 9F"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 BF"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 AF"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 AF"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 AF"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 AF"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 AF"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 AF"]], #[EXT]
                 "CPEX"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 8E"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 9E"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 BE"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 AE"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 AE"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 AE"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 AE"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 AE"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 AE"]], #[EXT]
                 "CPEY"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 8D"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 9D"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 BD"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 AD"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 AD"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 AD"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 AD"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 AD"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 AD"]], #[EXT]
                 "CPD"    => [[$AMOD_IMM16,             \&check_imm16,                  "8C"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "9C"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BC"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AC"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AC"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AC"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AC"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AC"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AC"   ]], #[EXT]
                 "CPS"    => [[$AMOD_IMM16,             \&check_imm16,                  "8F"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "9F"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BF"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AF"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AF"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AF"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AF"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AF"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AF"   ]], #[EXT]
                 "CPX"    => [[$AMOD_IMM16,             \&check_imm16,                  "8E"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "9E"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BE"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AE"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AE"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AE"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AE"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AE"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AE"   ]], #[EXT]
                 "CPY"    => [[$AMOD_IMM16,             \&check_imm16,                  "8D"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "9D"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BD"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AD"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AD"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AD"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AD"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AD"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AD"   ]], #[EXT]
                 "DAA"    => [[$AMOD_INH,               \&check_inh,                    "18 07"]], #INH
                 "DBEQ"   => [[$AMOD_DBEQ,              \&check_dbeq,                   "04"   ]], #REL
                 "DBNE"   => [[$AMOD_DBNE,              \&check_dbne,                   "04"   ]], #REL
                 "DEC"    => [[$AMOD_EXT,               \&check_ext,                    "73"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "63"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "63"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "63"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "63"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "63"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "63"   ]], #[EXT]
                 "DECA"   => [[$AMOD_INH,               \&check_inh,                    "43"   ]], #INH
                 "DECB"   => [[$AMOD_INH,               \&check_inh,                    "53"   ]], #INH
                 "DECW"   => [[$AMOD_EXT,               \&check_ext,                    "18 73"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 63"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 63"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 63"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 63"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 63"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 63"]], #[EXT]
                 "DECX"   => [[$AMOD_INH,               \&check_inh,                    "18 43"]], #INH
                 "DECY"   => [[$AMOD_INH,               \&check_inh,                    "18 53"]], #INH
                 "DES"    => [[$AMOD_INH,               \&check_inh,                    "1B 9F"]], #INH
                 "DEX"    => [[$AMOD_INH,               \&check_inh,                    "09"   ]], #INH
                 "DEY"    => [[$AMOD_INH,               \&check_inh,                    "03"   ]], #INH
                 "EDIV"   => [[$AMOD_INH,               \&check_inh,                    "11"   ]], #INH
                 "EDIVS"  => [[$AMOD_INH,               \&check_inh,                    "18 14"]], #INH
                 "EMACS"  => [[$AMOD_EXT,               \&check_ext,                    "18 12"]], #EXT
                 "EMAXD"  => [[$AMOD_IDX,               \&check_idx,                    "18 1A"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1A"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1A"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1A"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1A"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1A"]], #[EXT]
                 "EMAXM"  => [[$AMOD_IDX,               \&check_idx,                    "18 1E"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1E"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1E"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1E"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1E"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1E"]], #[EXT]
                 "EMIND"  => [[$AMOD_IDX,               \&check_idx,                    "18 1B"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1B"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1B"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1B"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1B"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1B"]], #[EXT]
                 "EMINM"  => [[$AMOD_IDX,               \&check_idx,                    "18 1F"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1F"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1F"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1F"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1F"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1F"]], #[EXT]
                 "EMUL"   => [[$AMOD_INH,               \&check_inh,                    "13"   ]], #INH
                 "EMULS"  => [[$AMOD_INH,               \&check_inh,                    "18 13"]], #INH
                 "EORA"   => [[$AMOD_IMM8,              \&check_imm8,                   "88"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "98"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B8"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A8"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A8"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A8"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A8"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A8"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A8"   ]], #[EXT]
                 "EORB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C8"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D8"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F8"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E8"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E8"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E8"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E8"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E8"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "e8"   ]], #[EXT]
                 "EORX"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 88"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 98"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 B8"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 A8"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 A8"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 A8"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 A8"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 A8"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 A8"]], #[EXT]
                 "EORY"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 C8"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 D8"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 F8"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E8"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E8"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E8"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E8"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E8"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E8"]], #[EXT]
                 "ETBL"   => [[$AMOD_IDX,               \&check_idx,                    "18 3F"]], #IDX
                 "EXG"    => [[$AMOD_S12X_EXG,          \&check_s12x_exg,               "B7"   ]], #INH
                 "FDIV"   => [[$AMOD_INH,               \&check_inh,                    "18 11"]], #INH
                 "GLDAA"  => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 96"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 B6"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 A6"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 A6"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 A6"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 A6"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 A6"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 A6"]], #[EXT]
                 "GLDAB"  => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 D6"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 F6"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E6"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E6"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E6"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E6"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E6"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E6"]], #[EXT]
                 "GLDD"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 DC"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 FC"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 EC"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 EC"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 EC"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 EC"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 EC"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 EC"]], #[EXT]
                 "GLDS"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 DF"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 FF"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 EF"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 EF"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 EF"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 EF"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 EF"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 EF"]], #[EXT]
                 "GLDX"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 DE"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 FE"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 EE"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 EE"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 EE"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 EE"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 EE"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 EE"]], #[EXT]
                 "GLDY"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 DD"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 FD"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 ED"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 ED"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 ED"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 ED"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 ED"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 ED"]], #[EXT]
                 "GSTAA"  => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 5A"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 7A"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 6A"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 6A"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 6A"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 6A"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 6A"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 6A"]], #[EXT]
                 "GSTAB"  => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 5B"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 7B"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 6B"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 6B"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 6B"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 6B"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 6B"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 6B"]], #[EXT]
                 "GSTD"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 5C"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 7C"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 6C"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 6C"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 6C"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 6C"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 6C"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 6C"]], #[EXT]
                 "GSTS"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 5F"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 7F"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 6F"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 6F"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 6F"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 6F"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 6F"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 6F"]], #[EXT]
                 "GSTX"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 5E"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 7E"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 6E"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 6E"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 6E"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 6E"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 6E"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 6E"]], #[EXT]
                 "GSTY"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 5D"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 7D"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 6D"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 6D"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 6D"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 6D"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 6D"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 6D"]], #[EXT]
                 "IBEQ"   => [[$AMOD_IBEQ,              \&check_ibeq,                   "04"   ]], #REL
                 "IBNE"   => [[$AMOD_IBNE,              \&check_ibne,                   "04"   ]], #REL
                 "IDIV"   => [[$AMOD_INH,               \&check_inh,                    "18 10"]], #INH
                 "IDIVS"  => [[$AMOD_INH,               \&check_inh,                    "18 15"]], #INH
                 "INC"    => [[$AMOD_EXT,               \&check_ext,                    "72"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "62"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "62"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "62"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "62"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "62"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "62"   ]], #[EXT]
                 "INCA"   => [[$AMOD_INH,               \&check_inh,                    "42"   ]], #INH
                 "INCB"   => [[$AMOD_INH,               \&check_inh,                    "52"   ]], #INH
                 "INCW"   => [[$AMOD_EXT,               \&check_ext,                    "18 72"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 62"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 62"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 62"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 62"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 62"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 62"]], #[EXT]
                 "INCX"   => [[$AMOD_INH,               \&check_inh,                    "18 42"]], #INH
                 "INCY"   => [[$AMOD_INH,               \&check_inh,                    "18 52"]], #INH
                 "INS"    => [[$AMOD_INH,               \&check_inh,                    "1B 81"]], #INH
                 "INX"    => [[$AMOD_INH,               \&check_inh,                    "08"   ]], #INH
                 "INY"    => [[$AMOD_INH,               \&check_inh,                    "02"   ]], #INH
                 "JMP"    => [[$AMOD_EXT,               \&check_ext,                    "06"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "05"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "05"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "05"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "05"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "05"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "05"   ]], #[EXT]
                 "JOB"    => [[$AMOD_REL8,              \&check_rel8,                   "20"   ],  #REL
                              [$AMOD_EXT,               \&check_ext,                    "06"   ]], #EXT
                 "JOBSR"  => [[$AMOD_REL8,              \&check_rel8,                   "07"   ],  #REL
                              [$AMOD_EXT,               \&check_ext,                    "16"   ]], #EXT
                 "JSR"    => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "17"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "16"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "15"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "15"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "15"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "15"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "15"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "15"   ]], #[EXT]
                 "LBCC"   => [[$AMOD_REL16,             \&check_rel16,                  "18 24"]], #REL
                 "LBCS"   => [[$AMOD_REL16,             \&check_rel16,                  "18 25"]], #REL
                 "LBEQ"   => [[$AMOD_REL16,             \&check_rel16,                  "18 27"]], #REL
                 "LBGE"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2C"]], #REL
                 "LBGT"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2E"]], #REL
                 "LBHI"   => [[$AMOD_REL16,             \&check_rel16,                  "18 22"]], #REL
                 "LBHS"   => [[$AMOD_REL16,             \&check_rel16,                  "18 24"]], #REL
                 "LBLE"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2F"]], #REL
                 "LBLO"   => [[$AMOD_REL16,             \&check_rel16,                  "18 25"]], #REL
                 "LBLS"   => [[$AMOD_REL16,             \&check_rel16,                  "18 23"]], #REL
                 "LBLT"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2D"]], #REL
                 "LBMI"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2B"]], #REL
                 "LBNE"   => [[$AMOD_REL16,             \&check_rel16,                  "18 26"]], #REL
                 "LBPL"   => [[$AMOD_REL16,             \&check_rel16,                  "18 2A"]], #REL
                 "LBRA"   => [[$AMOD_REL16,             \&check_rel16,                  "18 20"]], #REL
                 "LBRN"   => [[$AMOD_REL16,             \&check_rel16,                  "18 21"]], #REL
                 "LBVC"   => [[$AMOD_REL16,             \&check_rel16,                  "18 28"]], #REL
                 "LBVS"   => [[$AMOD_REL16,             \&check_rel16,                  "18 29"]], #REL
                 "LDAA"   => [[$AMOD_IMM8,              \&check_imm8,                   "86"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "96"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B6"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A6"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A6"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A6"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A6"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A6"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A6"   ]], #[EXT]
                 "LDAB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C6"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D6"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F6"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E6"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E6"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E6"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E6"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E6"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E6"   ]], #[EXT]
                 "LDD"    => [[$AMOD_IMM16,             \&check_imm16,                  "CC"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "DC"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FC"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EC"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EC"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EC"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EC"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EC"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EC"   ]], #[EXT]
                 "LDS"    => [[$AMOD_IMM16,             \&check_imm16,                  "CF"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "DF"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FF"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EF"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EF"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EF"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EF"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EF"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EF"   ]], #[EXT]
                 "LDX"    => [[$AMOD_IMM16,             \&check_imm16,                  "CE"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "DE"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FE"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EE"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EE"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EE"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EE"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EE"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EE"   ]], #[EXT]
                 "LDY"    => [[$AMOD_IMM16,             \&check_imm16,                  "CD"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "DD"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FD"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "ED"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "ED"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "ED"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "ED"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "ED"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "ED"   ]], #[EXT]
                 "LEAS"   => [[$AMOD_IDX,               \&check_idx,                    "1B"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "1B"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "1B"   ]], #IDX2
                 "LEAX"   => [[$AMOD_IDX,               \&check_idx,                    "1A"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "1A"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "1A"   ]], #IDX2
                 "LEAY"   => [[$AMOD_IDX,               \&check_idx,                    "19"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "19"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "19"   ]], #IDX2
                 "LSL"    => [[$AMOD_EXT,               \&check_ext,                    "78"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "68"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "68"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "68"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "68"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "68"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "68"   ]], #[EXT]
                 "LSLA"   => [[$AMOD_INH,               \&check_inh,                    "48"   ]], #INH
                 "LSLB"   => [[$AMOD_INH,               \&check_inh,                    "58"   ]], #INH
                 "LSLW"   => [[$AMOD_EXT,               \&check_ext,                    "18 78"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 68"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 68"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 68"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 68"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 68"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 68"]], #[EXT]
                 "LSLX"   => [[$AMOD_INH,               \&check_inh,                    "18 48"]], #INH
                 "LSLY"   => [[$AMOD_INH,               \&check_inh,                    "18 58"]], #INH
                 "LSLD"   => [[$AMOD_INH,               \&check_inh,                    "59"   ]], #INH
                 "LSR"    => [[$AMOD_EXT,               \&check_ext,                    "74"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "64"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "64"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "64"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "64"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "64"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "64"   ]], #[EXT]
                 "LSRA"   => [[$AMOD_INH,               \&check_inh,                    "44"   ]], #INH
                 "LSRB"   => [[$AMOD_INH,               \&check_inh,                    "54"   ]], #INH
                 "LSRW"   => [[$AMOD_EXT,               \&check_ext,                    "18 74"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 64"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 64"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 64"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 64"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 64"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 64"]], #[EXT]
                 "LSRX"   => [[$AMOD_INH,               \&check_inh,                    "18 44"]], #INH
                 "LSRY"   => [[$AMOD_INH,               \&check_inh,                    "18 54"]], #INH
                 "LSRD"   => [[$AMOD_INH,               \&check_inh,                    "49"   ]], #INH
                 "MAXA"   => [[$AMOD_IDX,               \&check_idx,                    "18 18"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 18"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 18"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 18"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 18"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 18"]], #[EXT]
                 "MAXM"   => [[$AMOD_IDX,               \&check_idx,                    "18 1C"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1C"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1C"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1C"],  #[D,IDX]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1C"]], #[EXT]
                 "MEM"    => [[$AMOD_INH,               \&check_inh,                    "01"   ]], #INH
                 "MINA"   => [[$AMOD_IDX,               \&check_idx,                    "18 19"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 19"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 19"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 19"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 19"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 19"]], #[EXT]
                 "MINM"   => [[$AMOD_IDX,               \&check_idx,                    "18 1D"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 1D"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 1D"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 1D"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 1D"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 1D"]], #[EXT]
                 "MOVB"   => [[$AMOD_IMM8_EXT,          \&check_imm8_ext,               "18 0B"],  #IMM-EXT
                              [$AMOD_IMM8_IDX,          \&check_imm8_idx,               "18 08"],  #IMM-IDX
                              [$AMOD_IMM8_IDX1,         \&check_imm8_idx1,              "18 08"],  #IMM-IDX1
                              [$AMOD_IMM8_IDX2,         \&check_imm8_idx2,              "18 08"],  #IMM-IDX2
                              [$AMOD_IMM8_IDIDX,        \&check_imm8_ididx,             "18 08"],  #IMM-[D,IDX]
                              [$AMOD_IMM8_IIDX2,        \&check_imm8_iidx2,             "18 08"],  #IMM-[IDX2]
                              [$AMOD_IMM8_IEXT,         \&check_imm8_iext,              "18 08"],  #IMM-[EXT]
                              [$AMOD_EXT_EXT,           \&check_ext_ext,                "18 0C"],  #EXT-EXT
                              [$AMOD_EXT_IDX,           \&check_ext_idx,                "18 09"],  #EXT-IDX
                              [$AMOD_EXT_IDX1,          \&check_ext_idx1,               "18 09"],  #EXT-IDX1
                              [$AMOD_EXT_IDX2,          \&check_ext_idx2,               "18 09"],  #EXT-IDX2
                              [$AMOD_EXT_IDIDX,         \&check_ext_ididx,              "18 09"],  #EXT-[D,IDX]
                              [$AMOD_EXT_IIDX2,         \&check_ext_iidx2,              "18 09"],  #EXT-[IDX2]
                              [$AMOD_EXT_IEXT,          \&check_ext_iext,               "18 09"],  #EXT-[EXT]
                              [$AMOD_IDX_EXT,           \&check_idx_ext,                "18 0D"],  #IDX-EXT
                              [$AMOD_IDX_IDX,           \&check_idx_idx,                "18 0A"],  #IDX-IDX
                              [$AMOD_IDX_IDX1,          \&check_idx_idx1,               "18 0A"],  #IDX-IDX1
                              [$AMOD_IDX_IDX2,          \&check_idx_idx2,               "18 0A"],  #IDX-IDX2
                              [$AMOD_IDX_IDIDX,         \&check_idx_ididx,              "18 0A"],  #IDX-[D,IDX]
                              [$AMOD_IDX_IIDX2,         \&check_idx_iidx2,              "18 0A"],  #IDX-[IDX2]
                              [$AMOD_IDX_IEXT,          \&check_idx_iext,               "18 0A"],  #IDX-[EXT]
                              [$AMOD_IDX1_EXT,          \&check_idx1_ext,               "18 0D"],  #IDX1-EXT
                              [$AMOD_IDX1_IDX,          \&check_idx1_idx,               "18 0A"],  #IDX1-IDX
                              [$AMOD_IDX1_IDX1,         \&check_idx1_idx1,              "18 0A"],  #IDX1-IDX1
                              [$AMOD_IDX1_IDX2,         \&check_idx1_idx2,              "18 0A"],  #IDX1-IDX2
                              [$AMOD_IDX1_IDIDX,        \&check_idx1_ididx,             "18 0A"],  #IDX1-[D,IDX]
                              [$AMOD_IDX1_IIDX2,        \&check_idx1_iidx2,             "18 0A"],  #IDX1-[IDX2]
                              [$AMOD_IDX1_IEXT,         \&check_idx1_iext,              "18 0A"],  #IDX1-[EXT]
                              [$AMOD_IDX2_EXT,          \&check_idx2_ext,               "18 0D"],  #IDX2-EXT
                              [$AMOD_IDX2_IDX,          \&check_idx2_idx,               "18 0A"],  #IDX2-IDX
                              [$AMOD_IDX2_IDX1,         \&check_idx2_idx1,              "18 0A"],  #IDX2-IDX1
                              [$AMOD_IDX2_IDX2,         \&check_idx2_idx2,              "18 0A"],  #IDX2-IDX2
                              [$AMOD_IDX2_IDIDX,        \&check_idx2_ididx,             "18 0A"],  #IDX2-[D,IDX]
                              [$AMOD_IDX2_IIDX2,        \&check_idx2_iidx2,             "18 0A"],  #IDX2-[IDX2]
                              [$AMOD_IDX2_IEXT,         \&check_idx2_iext,              "18 0A"],  #IDX2-[EXT]
                              [$AMOD_IDIDX_EXT,         \&check_ididx_ext,              "18 0D"],  #[D,IDX]-EXT
                              [$AMOD_IDIDX_IDX,         \&check_ididx_idx,              "18 0A"],  #[D,IDX]-IDX
                              [$AMOD_IDIDX_IDX1,        \&check_ididx_idx1,             "18 0A"],  #[D,IDX]-IDX1
                              [$AMOD_IDIDX_IDX2,        \&check_ididx_idx2,             "18 0A"],  #[D,IDX]-IDX2
                              [$AMOD_IDIDX_IDIDX,       \&check_ididx_ididx,            "18 0A"],  #[D,IDX]-[D,IDX]
                              [$AMOD_IDIDX_IIDX2,       \&check_ididx_iidx2,            "18 0A"],  #[D,IDX]-[IDX2]
                              [$AMOD_IDIDX_IEXT,        \&check_ididx_iext,             "18 0A"],  #[D,IDX]-[EXT]
                              [$AMOD_IIDX2_EXT,         \&check_iidx2_ext,              "18 0D"],  #[IDX2]-EXT
                              [$AMOD_IIDX2_IDX,         \&check_iidx2_idx,              "18 0A"],  #[IDX2]-IDX
                              [$AMOD_IIDX2_IDX1,        \&check_iidx2_idx1,             "18 0A"],  #[IDX2]-IDX1
                              [$AMOD_IIDX2_IDX2,        \&check_iidx2_idx2,             "18 0A"],  #[IDX2]-IDX2
                              [$AMOD_IIDX2_IDIDX,       \&check_iidx2_ididx,            "18 0A"],  #[IDX2]-[D,IDX]
                              [$AMOD_IIDX2_IIDX2,       \&check_iidx2_iidx2,            "18 0A"],  #[IDX2]-[IDX2]
                              [$AMOD_IIDX2_IEXT,        \&check_iidx2_iext,             "18 0A"],  #[IDX2]-[EXT]
                              [$AMOD_IEXT_EXT,          \&check_iext_ext,               "18 0D"],  #[EXT]-EXT
                              [$AMOD_IEXT_IDX,          \&check_iext_idx,               "18 0A"],  #[EXT]-IDX
                              [$AMOD_IEXT_IDX1,         \&check_iext_idx1,              "18 0A"],  #[EXT]-IDX1
                              [$AMOD_IEXT_IDX2,         \&check_iext_idx2,              "18 0A"],  #[EXT]-IDX2
                              [$AMOD_IEXT_IDIDX,        \&check_iext_ididx,             "18 0A"],  #[EXT]-[D,IDX]
                              [$AMOD_IEXT_IIDX2,        \&check_iext_iidx2,             "18 0A"],  #[EXT]-[IDX2]
                              [$AMOD_IEXT_IEXT,         \&check_iext_iext,              "18 0A"]], #[EXT]-[EXT]
                "MOVW"    => [[$AMOD_IMM16_EXT,         \&check_imm16_ext,              "18 03"],  #IMM-EXT
                              [$AMOD_IMM16_IDX,         \&check_imm16_idx,              "18 00"],  #IMM-IDX
                              [$AMOD_IMM16_IDX1,        \&check_imm16_idx1,             "18 00"],  #IMM-IDX1
                              [$AMOD_IMM16_IDX2,        \&check_imm16_idx2,             "18 00"],  #IMM-IDX2
                              [$AMOD_IMM16_IDIDX,       \&check_imm16_ididx,            "18 00"],  #IMM-[D,IDX]
                              [$AMOD_IMM16_IIDX2,       \&check_imm16_iidx2,            "18 00"],  #IMM-[IDX2]
                              [$AMOD_IMM16_IEXT,        \&check_imm16_iext,             "18 00"],  #IMM-[EXT]
                              [$AMOD_EXT_EXT,           \&check_ext_ext,                "18 04"],  #EXT-EXT
                              [$AMOD_EXT_IDX,           \&check_ext_idx,                "18 01"],  #EXT-IDX
                              [$AMOD_EXT_IDX1,          \&check_ext_idx1,               "18 01"],  #EXT-IDX1
                              [$AMOD_EXT_IDX2,          \&check_ext_idx2,               "18 01"],  #EXT-IDX2
                              [$AMOD_EXT_IDIDX,         \&check_ext_ididx,              "18 01"],  #EXT-[D,IDX]
                              [$AMOD_EXT_IIDX2,         \&check_ext_iidx2,              "18 01"],  #EXT-[IDX2]
                              [$AMOD_EXT_IEXT,          \&check_ext_iext,               "18 01"],  #EXT-[EXT]
                              [$AMOD_IDX_EXT,           \&check_idx_ext,                "18 05"],  #IDX-EXT
                              [$AMOD_IDX_IDX,           \&check_idx_idx,                "18 02"],  #IDX-IDX
                              [$AMOD_IDX_IDX1,          \&check_idx_idx1,               "18 02"],  #IDX-IDX1
                              [$AMOD_IDX_IDX2,          \&check_idx_idx2,               "18 02"],  #IDX-IDX2
                              [$AMOD_IDX_IDIDX,         \&check_idx_ididx,              "18 02"],  #IDX-[D,IDX]
                              [$AMOD_IDX_IIDX2,         \&check_idx_iidx2,              "18 02"],  #IDX-[IDX2]
                              [$AMOD_IDX_IEXT,          \&check_idx_iext,               "18 02"],  #IDX-[EXT]
                              [$AMOD_IDX1_EXT,          \&check_idx1_ext,               "18 05"],  #IDX1-EXT
                              [$AMOD_IDX1_IDX,          \&check_idx1_idx,               "18 02"],  #IDX1-IDX
                              [$AMOD_IDX1_IDX1,         \&check_idx1_idx1,              "18 02"],  #IDX1-IDX1
                              [$AMOD_IDX1_IDX2,         \&check_idx1_idx2,              "18 02"],  #IDX1-IDX2
                              [$AMOD_IDX1_IDIDX,        \&check_idx1_ididx,             "18 02"],  #IDX1-[D,IDX]
                              [$AMOD_IDX1_IIDX2,        \&check_idx1_iidx2,             "18 02"],  #IDX1-[IDX2]
                              [$AMOD_IDX1_IEXT,         \&check_idx1_iext,              "18 02"],  #IDX1-[EXT]
                              [$AMOD_IDX2_EXT,          \&check_idx2_ext,               "18 05"],  #IDX2-EXT
                              [$AMOD_IDX2_IDX,          \&check_idx2_idx,               "18 02"],  #IDX2-IDX
                              [$AMOD_IDX2_IDX1,         \&check_idx2_idx1,              "18 02"],  #IDX2-IDX1
                              [$AMOD_IDX2_IDX2,         \&check_idx2_idx2,              "18 02"],  #IDX2-IDX2
                              [$AMOD_IDX2_IDIDX,        \&check_idx2_ididx,             "18 02"],  #IDX2-[D,IDX]
                              [$AMOD_IDX2_IIDX2,        \&check_idx2_iidx2,             "18 02"],  #IDX2-[IDX2]
                              [$AMOD_IDX2_IEXT,         \&check_idx2_iext,              "18 02"],  #IDX2-[EXT]
                              [$AMOD_IDIDX_EXT,         \&check_ididx_ext,              "18 05"],  #[D,IDX]-EXT
                              [$AMOD_IDIDX_IDX,         \&check_ididx_idx,              "18 02"],  #[D,IDX]-IDX
                              [$AMOD_IDIDX_IDX1,        \&check_ididx_idx1,             "18 02"],  #[D,IDX]-IDX1
                              [$AMOD_IDIDX_IDX2,        \&check_ididx_idx2,             "18 02"],  #[D,IDX]-IDX2
                              [$AMOD_IDIDX_IDIDX,       \&check_ididx_ididx,            "18 02"],  #[D,IDX]-[D,IDX]
                              [$AMOD_IDIDX_IIDX2,       \&check_ididx_iidx2,            "18 02"],  #[D,IDX]-[IDX2]
                              [$AMOD_IDIDX_IEXT,        \&check_ididx_iext,             "18 02"],  #[D,IDX]-[EXT]
                              [$AMOD_IIDX2_EXT,         \&check_iidx2_ext,              "18 05"],  #[IDX2]-EXT
                              [$AMOD_IIDX2_IDX,         \&check_iidx2_idx,              "18 02"],  #[IDX2]-IDX
                              [$AMOD_IIDX2_IDX1,        \&check_iidx2_idx1,             "18 02"],  #[IDX2]-IDX1
                              [$AMOD_IIDX2_IDX2,        \&check_iidx2_idx2,             "18 02"],  #[IDX2]-IDX2
                              [$AMOD_IIDX2_IDIDX,       \&check_iidx2_ididx,            "18 02"],  #[IDX2]-[D,IDX]
                              [$AMOD_IIDX2_IIDX2,       \&check_iidx2_iidx2,            "18 02"],  #[IDX2]-[IDX2]
                              [$AMOD_IIDX2_IEXT,        \&check_iidx2_iext,             "18 02"],  #[IDX2]-[EXT]
                              [$AMOD_IEXT_EXT,          \&check_iext_ext,               "18 05"],  #[EXT]-EXT
                              [$AMOD_IEXT_IDX,          \&check_iext_idx,               "18 02"],  #[EXT]-IDX
                              [$AMOD_IEXT_IDX1,         \&check_iext_idx1,              "18 02"],  #[EXT]-IDX1
                              [$AMOD_IEXT_IDX2,         \&check_iext_idx2,              "18 02"],  #[EXT]-IDX2
                              [$AMOD_IEXT_IDIDX,        \&check_iext_ididx,             "18 02"],  #[EXT]-[D,IDX]
                              [$AMOD_IEXT_IIDX2,        \&check_iext_iidx2,             "18 02"],  #[EXT]-[IDX2]
                              [$AMOD_IEXT_IEXT,         \&check_iext_iext,              "18 02"]], #[EXT]-[EXT]
                 "MUL"    => [[$AMOD_INH,               \&check_inh,                    "12"   ]], #INH
                 "NEG"    => [[$AMOD_EXT,               \&check_ext,                    "70"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "60"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "60"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "60"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "60"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "60"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "60"   ]], #[EXT]
                 "NEGA"   => [[$AMOD_INH,               \&check_inh,                    "40"   ]], #INH
                 "NEGB"   => [[$AMOD_INH,               \&check_inh,                    "50"   ]], #INH
                 "NEGW"   => [[$AMOD_EXT,               \&check_ext,                    "18 70"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 60"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 60"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 60"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 60"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 60"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 60"]], #[EXT]
                 "NEGX"   => [[$AMOD_INH,               \&check_inh,                    "18 40"]], #INH
                 "NEGY"   => [[$AMOD_INH,               \&check_inh,                    "18 50"]], #INH
                 "NOP"    => [[$AMOD_INH,               \&check_inh,                    "A7"   ]], #INH
                 "ORAA"   => [[$AMOD_IMM8,              \&check_imm8,                   "8A"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "9A"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "BA"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "AA"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "AA"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "AA"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "AA"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "AA"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "AA"   ]], #[EXT]
                 "ORAB"   => [[$AMOD_IMM8,              \&check_imm8,                   "CA"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "DA"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "FA"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "EA"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "EA"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "EA"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "EA"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "EA"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "EA"   ]], #[EXT]
                 "ORX"    => [[$AMOD_IMM16,             \&check_imm16,                  "18 8A"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 9A"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 BA"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 AA"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 AA"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 AA"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 AA"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 AA"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 AA"]], #[EXT]
                 "ORY"    => [[$AMOD_IMM16,             \&check_imm16,                  "18 CA"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 DA"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 FA"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 EA"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 EA"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 EA"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 EA"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 EA"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 EA"]], #[EXT]
                 "ORCC"   => [[$AMOD_IMM8,              \&check_imm8,                   "14"   ]], #INH
                 "PSHA"   => [[$AMOD_INH,               \&check_inh,                    "36"   ]], #INH
                 "PSHB"   => [[$AMOD_INH,               \&check_inh,                    "37"   ]], #INH
                 "PSHC"   => [[$AMOD_INH,               \&check_inh,                    "39"   ]], #INH
                 "PSHCW"  => [[$AMOD_INH,               \&check_inh,                    "18 39"]], #INH
                 "PSHD"   => [[$AMOD_INH,               \&check_inh,                    "3B"   ]], #INH
                 "PSHX"   => [[$AMOD_INH,               \&check_inh,                    "34"   ]], #INH
                 "PSHY"   => [[$AMOD_INH,               \&check_inh,                    "35"   ]], #INH
                 "PULA"   => [[$AMOD_INH,               \&check_inh,                    "32"   ]], #INH
                 "PULB"   => [[$AMOD_INH,               \&check_inh,                    "33"   ]], #INH
                 "PULC"   => [[$AMOD_INH,               \&check_inh,                    "38"   ]], #INH
                 "PULCW"  => [[$AMOD_INH,               \&check_inh,                    "18 38"]], #INH
                 "PULD"   => [[$AMOD_INH,               \&check_inh,                    "3A"   ]], #INH
                 "PULX"   => [[$AMOD_INH,               \&check_inh,                    "30"   ]], #INH
                 "PULY"   => [[$AMOD_INH,               \&check_inh,                    "31"   ]], #INH
                 "REV"    => [[$AMOD_INH,               \&check_inh,                    "18 3A"]], #INH
                 "REVW"   => [[$AMOD_INH,               \&check_inh,                    "18 3B"]], #INH
                 "ROL"    => [[$AMOD_EXT,               \&check_ext,                    "75"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "65"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "65"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "65"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "65"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "65"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "65"   ]], #[EXT]
                 "ROLA"   => [[$AMOD_INH,               \&check_inh,                    "45"   ]], #INH
                 "ROLB"   => [[$AMOD_INH,               \&check_inh,                    "55"   ]], #INH
                 "ROLW"   => [[$AMOD_EXT,               \&check_ext,                    "18 75"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 65"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 65"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 65"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 65"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 65"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 65"]], #[EXT]
                 "ROLX"   => [[$AMOD_INH,               \&check_inh,                    "18 45"]], #INH
                 "ROLY"   => [[$AMOD_INH,               \&check_inh,                    "18 55"]], #INH
                 "ROR"    => [[$AMOD_EXT,               \&check_ext,                    "76"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "66"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "66"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "66"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "66"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "66"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "66"   ]], #[EXT]
                 "RORA"   => [[$AMOD_INH,               \&check_inh,                    "46"   ]], #INH
                 "RORB"   => [[$AMOD_INH,               \&check_inh,                    "56"   ]], #INH
                 "RORW"   => [[$AMOD_EXT,               \&check_ext,                    "18 76"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 66"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 66"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 66"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 66"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 66"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 66"]], #[EXT]
                 "RORX"   => [[$AMOD_INH,               \&check_inh,                    "18 46"]], #INH
                 "RORY"   => [[$AMOD_INH,               \&check_inh,                    "18 56"]], #INH
                 "RTC"    => [[$AMOD_INH,               \&check_inh,                    "0A"   ]], #INH
                 "RTI"    => [[$AMOD_INH,               \&check_inh,                    "0B"   ]], #INH
                 "RTS"    => [[$AMOD_INH,               \&check_inh,                    "3D"   ]], #INH
                 "SBA"    => [[$AMOD_INH,               \&check_inh,                    "18 16"]], #INH
                 "SBCA"   => [[$AMOD_IMM8,              \&check_imm8,                   "82"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "92"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B2"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A2"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A2"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A2"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A2"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A2"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A2"   ]], #[EXT]
                 "SBCB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C2"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D2"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F2"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E2"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E2"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E2"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E2"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E2"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E2"   ]], #[EXT]
                 "SBED"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 83"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 93"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 B3"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 A3"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 A3"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 A3"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 A3"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 A3"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 A3"]], #[EXT]
                 "SBEX"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 82"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 92"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 B2"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 A2"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 A2"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 A2"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 A2"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 A2"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 A2"]], #[EXT]
                 "SBEY"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 C2"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 D2"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 F2"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E2"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E2"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E2"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E2"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E2"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E2"]], #[EXT]
                 "SEC"    => [[$AMOD_INH,               \&check_inh,                    "14 01"]], #INH
                 "SEI"    => [[$AMOD_INH,               \&check_inh,                    "14 10"]], #INH
                 "SEV"    => [[$AMOD_INH,               \&check_inh,                    "14 02"]], #INH
                 "SEX"    => [[$AMOD_S12X_TFR,          \&check_s12x_sex,               "B7"   ]], #INH
                 "STAA"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "5A"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7A"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6A"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6A"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6A"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6A"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6A"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6A"   ]], #[EXT]
                 "STAB"   => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "5B"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7B"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6B"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6B"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6B"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6B"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6B"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6B"   ]], #[EXT]
                 "STD"    => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "5C"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7C"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6C"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6C"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6C"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6C"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6C"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6C"   ]], #[EXT]
                 "STOP"   => [[$AMOD_INH,               \&check_inh,                    "18 3E"]], #INH
                 "STS"    => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "5F"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7F"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6F"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6F"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6F"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6F"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6F"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6F"   ]], #[EXT]
                 "STX"    => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "5E"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7E"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6E"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6E"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6E"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6E"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6E"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6E"   ]], #[EXT]
                 "STY"    => [[$AMOD_S12X_DIR,          \&check_s12x_dir,               "5D"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "7D"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "6D"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "6D"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "6D"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "6D"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "6D"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "6D"   ]], #[EXT]
                 "SUBA"   => [[$AMOD_IMM8,              \&check_imm8,                   "80"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "90"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B0"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A0"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A0"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A0"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A0"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A0"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A0"   ]], #[EXT]
                 "SUBB"   => [[$AMOD_IMM8,              \&check_imm8,                   "C0"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "D0"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "F0"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E0"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E0"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E0"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E0"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E0"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E0"   ]], #[EXT]
                 "SUBD"   => [[$AMOD_IMM16,             \&check_imm16,                  "83"   ],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "93"   ],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "B3"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "A3"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "A3"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "A3"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "A3"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "A3"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "A3"   ]], #[EXT]
                 "SUBX"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 80"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 90"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 B0"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 A0"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 A0"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 A0"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 A0"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 A0"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 A0"]], #[EXT]
                 "SUBY"   => [[$AMOD_IMM16,             \&check_imm16,                  "18 C0"],  #IMM
                              [$AMOD_S12X_DIR,          \&check_s12x_dir,               "18 D0"],  #DIR
                              [$AMOD_EXT,               \&check_ext,                    "18 F0"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E0"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E0"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E0"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E0"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E0"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E0"]], #[EXT]
                 "SWI"    => [[$AMOD_INH,               \&check_inh,                    "3F"   ]], #INH
                 "TAB"    => [[$AMOD_INH,               \&check_inh,                    "18 0E"]], #INH
                 "TAP"    => [[$AMOD_INH,               \&check_inh,                    "B7 02"]], #INH
                 "TBA"    => [[$AMOD_INH,               \&check_inh,                    "18 0F"]], #INH
                 "TBEQ"   => [[$AMOD_TBEQ,              \&check_tbeq,                   "04"   ]], #REL
                 "TBL"    => [[$AMOD_IDX,               \&check_idx,                    "18 3D"]], #IDX
                 "TBNE"   => [[$AMOD_TBNE,              \&check_tbne,                   "04"   ]], #REL
                 "TFR"    => [[$AMOD_S12X_TFR,          \&check_s12x_tfr,               "B7"   ]], #INH
                 "TPA"    => [[$AMOD_INH,               \&check_inh,                    "B7 20"]], #INH
                 "TRAP"   => [[$AMOD_S12X_TRAP,         \&check_s12x_trap,              "18"   ]], #INH
                 "TST"    => [[$AMOD_EXT,               \&check_ext,                    "F7"   ],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "E7"   ],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "E7"   ],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "E7"   ],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "E7"   ],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "E7"   ],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "E7"   ]], #[EXT]
                 "TSTA"   => [[$AMOD_INH,               \&check_inh,                    "97"   ]], #INH
                 "TSTB"   => [[$AMOD_INH,               \&check_inh,                    "D7"   ]], #INH
                 "TSTW"   => [[$AMOD_EXT,               \&check_ext,                    "18 F7"],  #EXT
                              [$AMOD_IDX,               \&check_idx,                    "18 E7"],  #IDX
                              [$AMOD_IDX1,              \&check_idx1,                   "18 E7"],  #IDX1
                              [$AMOD_IDX2,              \&check_idx2,                   "18 E7"],  #IDX2
                              [$AMOD_IDIDX,             \&check_ididx,                  "18 E7"],  #[D,IDX]
                              [$AMOD_IIDX2,             \&check_iidx2,                  "18 E7"],  #[IDX2]
                              [$AMOD_IEXT,              \&check_iext,                   "18 E7"]], #[EXT]
                 "TSTX"   => [[$AMOD_INH,               \&check_inh,                    "18 97"]], #INH
                 "TSTY"   => [[$AMOD_INH,               \&check_inh,                    "18 D7"]], #INH
                 "TSX"    => [[$AMOD_INH,               \&check_inh,                    "B7 75"]], #INH
                 "TSY"    => [[$AMOD_INH,               \&check_inh,                    "B7 76"]], #INH
                 "TXS"    => [[$AMOD_INH,               \&check_inh,                    "B7 57"]], #INH
                 "TYS"    => [[$AMOD_INH,               \&check_inh,                    "B7 67"]], #INH
                 "WAI"    => [[$AMOD_INH,               \&check_inh,                    "3E"   ]], #INH
                 "WAV"    => [[$AMOD_INH,               \&check_inh,                    "18 3C"]], #INH
                 "WAVR"   => [[$AMOD_INH,               \&check_inh,                    "3C"   ]], #INH
                 "XGDX"   => [[$AMOD_INH,               \&check_inh,                    "B7 C5"]], #INH
                 "XGDY"   => [[$AMOD_INH,               \&check_inh,                    "B7 C6"]]};#INH

#XGATE:           MNEMONIC      ADDRESS MODE                                            OPCODE
Readonly our $OPCTAB_XGATE => {
                  "ADC"    => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "18 03"]],       #TRI
                  "ADD"    => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "18 02"],        #TRI
                               [$AMOD_XGATE_IMM16,      \&check_xgate_imm16,            "E0 00 E8 00"]], #IMM16 pseudo opcode
                  "ADDH"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "E8 00"]],       #IMM8
                  "ADDL"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "E0 00"]],       #IMM8
                  "AND"    => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "10 00"],        #TRI
                               [$AMOD_XGATE_IMM16,      \&check_xgate_imm16,            "80 00 88 00"]], #IMM16 pseudo opcode
                  "ANDH"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "88 00"]],       #IMM8
                  "ANDL"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "80 00"]],       #IMM8
                  "ASR"    => [[$AMOD_XGATE_IMM4,       \&check_xgate_imm4,             "08 09"],        #IMM4
                               [$AMOD_XGATE_DYA,        \&check_xgate_dya,              "08 11"]],       #DYA
                  "BCC"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "20 00"]],       #REL9
                  "BCS"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "22 00"]],       #REL9
                  "BEQ"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "26 00"]],       #REL9
                  "BFEXT"  => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "60 03"]],       #TRI
                  "BFFO"   => [[$AMOD_XGATE_DYA,        \&check_xgate_dya,              "08 10"]],       #DYA
                  "BFINS"  => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "68 03"]],       #TRI
                  "BFINSI" => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "70 03"]],       #TRI
                  "BFINSX" => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "78 03"]],       #TRI
                  "BGE"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "34 00"]],       #REL9
                  "BGT"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "38 00"]],       #REL9
                  "BHI"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "30 00"]],       #REL9
                  "BHS"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "20 00"]],       #REL9 pseudo opcode
                  "BITH"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "98 00"]],       #IMM8
                  "BITL"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "90 00"]],       #IMM8
                  "BLE"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "3A 00"]],       #REL9
                  "BLO"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "22 00"]],       #REL9 pseudo opcode
                  "BLS"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "32 00"]],       #REL9
                  "BLT"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "36 00"]],       #REL9
                  "BMI"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "2A 00"]],       #REL9
                  "BNE"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "24 00"]],       #REL9
                  "BPL"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "28 00"]],       #REL9
                  "BRA"    => [[$AMOD_XGATE_REL10,      \&check_xgate_rel10,            "3C 00"]],       #REL10
                  "BRK"    => [[$AMOD_INH,              \&check_inh,                    "00 00"]],       #INH
                  "BVC"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "2C 00"]],       #REL9
                  "BVS"    => [[$AMOD_XGATE_REL9,       \&check_xgate_rel9,             "2E 00"]],       #REL9
                  "COM"    => [[$AMOD_XGATE_MON,        \&check_xgate_com_mon,          "10 03"],        #TRI pseudo opcode
                               [$AMOD_XGATE_DYA,        \&check_xgate_com_dya,          "10 03"]],       #TRI pseudo opcode
                  "CMP"    => [[$AMOD_XGATE_DYA,        \&check_xgate_cmp_dya,          "18 00"],        #TRI pseudo opcode
                               [$AMOD_XGATE_IMM16,      \&check_xgate_imm16,            "D0 00 D8 00"]], #IMM16 pseudo opcode
                  "CMPL"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "D0 00"]],       #IMM8
                  "CPC"    => [[$AMOD_XGATE_DYA,        \&check_xgate_cmp_dya,          "18 01"]],       #TRI pseudo opcode
                  "CPCH"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "D8 00"]],       #IMM8
                  "CSEM"   => [[$AMOD_XGATE_MON,        \&check_xgate_mon,              "00 F1"],        #MON
                               [$AMOD_XGATE_IMM3,       \&check_xgate_imm3,             "00 F0"]],       #IMM3
                  "CSL"    => [[$AMOD_XGATE_IMM4,       \&check_xgate_imm4,             "08 0A"],        #IMM4
                               [$AMOD_XGATE_DYA,        \&check_xgate_dya,              "08 12"]],       #DYA
                  "CSR"    => [[$AMOD_XGATE_IMM4,       \&check_xgate_imm4,             "08 0B"],        #IMM4
                               [$AMOD_XGATE_DYA,        \&check_xgate_dya,              "08 13"]],       #DYA
                  "JAL"    => [[$AMOD_XGATE_MON,        \&check_xgate_mon,              "00 F6"]],       #MON
                  "LDB"    => [[$AMOD_XGATE_IDO5,       \&check_xgate_ido5,             "40 00"],        #IDO5
                               [$AMOD_XGATE_IDR,        \&check_xgate_idr,              "60 00"],        #IDR
                               [$AMOD_XGATE_IDRI,       \&check_xgate_idri,             "60 01"],        #IDR+
                               [$AMOD_XGATE_IDRD,       \&check_xgate_idrd,             "60 02"]],       #-IDR
                  "LDH"    => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "F8 00"]],       #IMM8
                  "LDL"    => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "F0 00"]],       #IMM8
                  "LDW"    => [[$AMOD_XGATE_IDO5,       \&check_xgate_ido5,             "48 00"],        #IDO5
                               [$AMOD_XGATE_IDR,        \&check_xgate_idr,              "68 00"],        #IDR
                               [$AMOD_XGATE_IDRI,       \&check_xgate_idri,             "68 01"],        #IDR+
                               [$AMOD_XGATE_IDRD,       \&check_xgate_idrd,             "68 02"],        #-IDR
                               [$AMOD_XGATE_IMM16,      \&check_xgate_imm16,            "F0 00 F8 00"]], #IMM16 pseudo opcode
                  "LSL"    => [[$AMOD_XGATE_IMM4,       \&check_xgate_imm4,             "08 0C"],        #IMM4
                               [$AMOD_XGATE_DYA,        \&check_xgate_dya,              "08 14"]],       #DYA
                  "LSR"    => [[$AMOD_XGATE_IMM4,       \&check_xgate_imm4,             "08 0D"],        #IMM4
                               [$AMOD_XGATE_DYA,        \&check_xgate_dya,              "08 15"]],       #DYA
                  "MOV"    => [[$AMOD_XGATE_DYA,        \&check_xgate_com_dya,          "10 02"]],       #TRI pseudo opcode
                  "NEG"    => [[$AMOD_XGATE_MON,        \&check_xgate_com_mon,          "18 00"],        #TRI pseudo opcode
                               [$AMOD_XGATE_DYA,        \&check_xgate_com_dya,          "18 00"]],       #TRI pseudo opcode
                  "NOP"    => [[$AMOD_INH,              \&check_inh,                    "01 00"]],       #INH
                  "OR"     => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "10 02"],        #TRI
                               [$AMOD_XGATE_IMM16,      \&check_xgate_imm16,            "A0 00 A8 00"]], #IMM16 pseudo opcode
                  "ORH"    => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "A8 00"]],       #IMM8
                  "ORL"    => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "A0 00"]],       #IMM8
                  "PAR"    => [[$AMOD_XGATE_MON,        \&check_xgate_mon,              "00 F5"]],       #MON
                  "ROL"    => [[$AMOD_XGATE_IMM4,       \&check_xgate_imm4,             "08 0E"],        #IMM4
                               [$AMOD_XGATE_DYA,        \&check_xgate_dya,              "08 16"]],       #DYA
                  "ROR"    => [[$AMOD_XGATE_IMM4,       \&check_xgate_imm4,             "08 0F"],        #IMM4
                               [$AMOD_XGATE_DYA,        \&check_xgate_dya,              "08 17"]],       #DYA
                  "RTS"    => [[$AMOD_INH,              \&check_inh,                    "02 00"]],       #INH
                  "SBC"    => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "18 01"]],       #TRI
                  "SEX"    => [[$AMOD_XGATE_MON,        \&check_xgate_mon,              "00 F4"]],       #MON
                  "SIF"    => [[$AMOD_INH,              \&check_inh,                    "03 00"],        #INH
                               [$AMOD_XGATE_MON,        \&check_xgate_mon,              "00 F7"]],       #MON
                  "SSSEM"  => [[$AMOD_XGATE_MON,        \&check_xgate_mon,              "00 f3"],        #MON
                  	       [$AMOD_XGATE_IMM3,       \&check_xgate_imm3,             "00 F2"]],       #IMM3
                  "SSEM"   => [[$AMOD_XGATE_MON,        \&check_xgate_mon_twice,        "00 f3"],        #MON
                               [$AMOD_XGATE_IMM3,       \&check_xgate_imm3_twice,       "00 F2"]],       #IMM3
                  "STB"    => [[$AMOD_XGATE_IDO5,       \&check_xgate_ido5,             "50 00"],        #IDO5
                               [$AMOD_XGATE_IDR,        \&check_xgate_idr,              "70 00"],        #IDR
                               [$AMOD_XGATE_IDRI,       \&check_xgate_idri,             "70 01"],        #IDR+
                               [$AMOD_XGATE_IDRD,       \&check_xgate_idrd,             "70 02"]],       #-IDR
                  "STW"    => [[$AMOD_XGATE_IDO5,       \&check_xgate_ido5,             "58 00"],        #IDO5
                               [$AMOD_XGATE_IDR,        \&check_xgate_idr,              "78 00"],        #IDR
                               [$AMOD_XGATE_IDRI,       \&check_xgate_idri,             "78 01"],        #IDR+
                               [$AMOD_XGATE_IDRD,       \&check_xgate_idrd,             "78 02"]],       #-IDR
                  "SUB"    => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "18 00"],        #TRI
                               [$AMOD_XGATE_IMM16,      \&check_xgate_imm16,            "C0 00 C8 00"]], #IMM16 opcode
                  "SUBH"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "C8 00"]],       #IMM8
                  "SUBL"   => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "C0 00"]],       #IMM8
                  "TST"    => [[$AMOD_XGATE_MON,        \&check_xgate_tst_mon,          "18 00"]],       #TRI pseudo opcode
                  "TFR"    => [[$AMOD_XGATE_TFR_RD_CCR, \&check_xgate_tfr_rd_ccr,       "00 F8"],        #MON
                               [$AMOD_XGATE_TFR_CCR_RS, \&check_xgate_tfr_ccr_rs,       "00 F9"],        #MON
                               [$AMOD_XGATE_TFR_RD_PC,  \&check_xgate_tfr_rd_pc,        "00 FA"]],       #MON
                  "XNOR"   => [[$AMOD_XGATE_TRI,        \&check_xgate_tri,              "10 03"],        #TRI
                               [$AMOD_XGATE_IMM16,      \&check_xgate_imm16,            "B0 00 B8 00"]], #IMM16 opcode
                  "XNORH"  => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "B8 00"]],       #IMM8
                  "XNORL"  => [[$AMOD_XGATE_IMM8,       \&check_xgate_imm8,             "B0 00"]]};      #IMM8

##################
# pseudo opcodes #
##################
#                   MNEMONIC       SUBROUTINE
Readonly our $PSEUDO_OPCODES => {
                    "ALIGN"    => \&psop_align,
                    "BSZ"      => \&psop_zmb,
                    "CPU"      => \&psop_cpu,
                    "DB"       => \&psop_db,
                    "DC.B"     => \&psop_db,
                    "DC.W"     => \&psop_dw,
                    "DS"       => \&psop_dsb,
                    "DS.B"     => \&psop_dsb,
                    "DS.W"     => \&psop_dsw,
                    "DW"       => \&psop_dw,
                    "ERROR"    => \&psop_error,
                    "EQU"      => \&psop_equ,
                    "FCB"      => \&psop_db,
                    "FCC"      => \&psop_fcc,
                    "FCS"      => \&psop_fcs,
                    "FCZ"      => \&psop_fcz,
                    "FDB"      => \&psop_dw,
                    "FILL"     => \&psop_fill,
                    "FLET16"   => \&psop_flet16, #Fletcher-16 checksum generation
                    "LOC"      => \&psop_loc,
                    "ORG"      => \&psop_org,
                    "RMB"      => \&psop_dsb,
                    "RMW"      => \&psop_dsw,
                    "UNALIGN"  => \&psop_unalign,
                    "ZMB"      => \&psop_zmb,
                    "SETDP"    => \&psop_setdp,
                    #pseudo opcodes to ignore
                    "NAME"     => \&psop_ignore,
                    "TTL"      => \&psop_ignore,
                    "VER"      => \&psop_ignore,
                    "VERSION"  => \&psop_ignore,
                    "PAG"      => \&psop_ignore,
                    "FUN"      => \&psop_ignore,
                    "FUNA"     => \&psop_ignore,
                    "END"      => \&psop_ignore};

###############
# constructor #
###############
sub new {
    my $proto            = shift @_;
    my $class            = ref($proto) || $proto;
    my $file_list        = shift @_;
    my $library_list     = shift @_;
    my $defines          = shift @_;
    my $cpu              = shift @_;
    my $verbose          = shift @_;
    my $symbols          = shift @_;
    my $self             = {};

    #initalize global variables
    $self->{source_files} = $file_list;
    $self->{libraries}    = $library_list;
    $self->{initial_defs} = $defines;
    $self->{precomp_defs} = $defines;
    $self->{cpu}          = $cpu;
    $self->{verbose}      = $verbose;

    #reset remaining global variables
    $self->{problems}         = "no code";
    $self->{code}             = [];
    $self->{comp_symbols}     = {};
    $self->{macros}           = {};
    $self->{macro_argcs}      = {};
    $self->{macro_symbols}    = {};
    $self->{lin_addrspace}    = {};
    $self->{pag_addrspace}    = {};
    $self->{compile_count}    = 0;
    $self->{opcode_table}     = $OPCTAB_S12;
    $self->{dir_page}         = 0;

    #instantiate object
    bless $self, $class;
    #printf STDERR "libs: %s\n", join(", ", @$library_list);
    
    #compile code
    $self->compile($file_list, [@$library_list, sprintf(".%s", $PATH_DEL)], $symbols);

    return $self;
}

##############
# destructor #
##############
#sub DESTROY {
#    my $self = shift @_;
#}

##########
# reload #
##########
sub reload {
    my $self         = shift @_;
    my $verbose      = shift @_;
    my $symbols      = $self->{comp_symbols};

    #reset global variables
    $self->{problems}         = "no code";
    $self->{code}             = [];
    $self->{precomp_defs}     = %{$self->{initial_defs}};
    $self->{comp_symbols}     = {};
    $self->{macros}           = {};
    $self->{macro_argcs}      = {};
    $self->{macro_symbols}    = {};
    $self->{lin_addrspace}    = {};
    $self->{pag_addrspace}    = {};
    $self->{compile_count}    = 0;
    if (defined $verbose) {
        $self->{verbose}      = $verbose;
    }

    #compile code
    $self->compile($self->{source_files}, $self->{libraries}, $symbols);
}

###########
# compile #
###########
sub compile {
    my $self            = shift @_;
    my $file_list       = shift @_;
    my $library_list    = shift @_;
    my $initial_symbols = shift @_;
    #compile status
    my $old_undef_count;
    my $new_undef_count;
    my $redef_count;
    my $error_count;
    my $compile_count;
    my $keep_compiling;
    my $result_ok;
    #compiler runs
    #my $MAX_COMP_RUNS = 200;

    ##############
    # precompile #
    ##############
    if (!$self->precompile($file_list, $library_list, [[1,1,1]], undef)) {
        #printf "precompiler symbols: %s\n", join("\n         ", keys %{$self->{comp_symbols}});
        #$self->{problems} = "precompiler";

        ##################################################
        # export precompiler defines to compiler symbols #
        ##################################################
        $self->export_precomp_defs();

        ###########
        # compile #
        ###########
        $self->{compile_count} = 0;
        $old_undef_count       = $#{$self->{code}};
        $redef_count           = 0;
        $keep_compiling        = 1;
        $result_ok             = 1;

        #print progress messages
        if ($self->{verbose}) {
            print STDOUT "\n";
            print STDOUT "COMPILE RUN  UNDEFINED SYMBOLS  REDEFINED SYMBOLS\n";
            print STDOUT "===========  =================  =================\n";
        }

        while ($keep_compiling) {
            $self->{compile_count} = ($self->{compile_count} + 1);
            #compile run
            ($error_count, $new_undef_count, $redef_count) = @{$self->compile_run()};
            #print progress messages
            if ($self->{verbose}) {
                printf STDOUT "%8d  %17d  %17d\n", $self->{compile_count}, $new_undef_count, $redef_count;
            }
	    
	    #initialize compiler symbols
	    if ($self->{compile_count} == 1) {
		$self->initialize_symbols($initial_symbols);
	    }

            #printf STDERR "compile run: %d\n", $self->{compile_count};
            #printf STDERR "errors:      %d\n", $error_count;
            #printf STDERR "old undefs:  %d\n", $old_undef_count;
            #printf STDERR "new undefs:  %d\n", $new_undef_count;
            #printf STDERR "redefs:      %d\n", $redef_count;
            #printf STDERR "symbols: \"%s\"\n", join("\", \"", keys %{$self->{comp_symbols}});;

            #################
            # check results #
            #################
            if ($error_count > 0) {
                ###################
                # compiler errors #
                ###################
                $keep_compiling = 0;
                $result_ok      = 0;
                if ($error_count == 1) {
                    $self->{problems} = "1 compiler error!";
                } else {
                    $self->{problems} = sprintf("%d compiler errors!", $error_count);
                }
            } elsif ($self->{compile_count} >= $MAX_COMP_RUNS) {
                ##########################
                # too many compiler runs #
                ##########################
                $keep_compiling = 0;
                $result_ok      = 0;
                $self->{problems} = sprintf("%d assembler runs and no success!", $MAX_COMP_RUNS);
            #} elsif (($new_undef_count > 0) &&
            #          ($new_undef_count >= $old_undef_count)) {
            #    ######################
            #    # unresolved opcodes #
            #    ######################
            #    $keep_compiling = 0;
            #    $result_ok     = 0;
            #    $self->{problems} = sprintf("%d undefined opcodes!", $new_undef_count);
            } elsif (($new_undef_count == 0) &&
                     ($redef_count     == 0)) {
                ##########################
                # compilation successful #
                ##########################
                $keep_compiling = 0;
                $result_ok      = 1;
                $self->{problems} = 0;
            }
            ##########################
            # update old undef count #
            ##########################
            $old_undef_count = $new_undef_count;
        }

        #####################################
        # see if compilation was successful #
        #####################################
        if ($result_ok) {
            ############################
            # determine address spaces #
            ############################
            $self->determine_addrspaces();
        }
    } else {
        $self->{problems} = "precompiler error";
    }
    #print "error_count   = $error_count\n";
    #print "undef_count   = $new_undef_count\n";
    #print "compile_count = $self->{compile_count}\n";

}

##############
# precompile #
##############
sub precompile {
    my $self         = shift @_;
    my $file_list    = shift @_;
    my $library_list = shift @_;
    my $ifdef_stack  = shift @_;
    my $macro        = shift @_;
    #file
    my $file_handle;
    my $file_name;
    my $library_path;
    my $file;
    #errors
    my $error;
    my $error_count;
    #CPU
    my $cpu = $self->{cpu};
    #line
    my $line;
    my $line_count;
    my $label;
    my $opcode;
    my $arguments;
    my $directive;
    my $arg1;
    my $arg2;
    #source code
    my @srccode_sequence;
    #temporary
    my $match;
    my $value;

    #############
    # file loop #
    #############
    foreach $file_name (@$file_list) {
        ############################
        # determine full file name #
        ############################
        #printf "file_name: %s\n", $file_name;
        $error = 0;
        if ($file_name =~ /$PATH_ABSOLUTE/) {
	   #printf "absolute path: %s\n", $file_name;
           #absolute path
            $file = $file_name;
            if (-e $file) {
                if (-r $file) {
                   if ($file_handle = IO::File->new($file, O_RDONLY)) {
                    } else {
                        $error = sprintf("unable to open file \"%s\" (%s)", $file, $!);
                        #print "$error\n";
                    }
                } else {
                    $error = sprintf("file \"%s\" is not readable", $file);
                    #print "$error\n";
                }
            } else {
                $error = sprintf("file \"%s\" does not exist", $file);
                #print "$error\n";
            }
        } else {
	    #printf "relative path: %s\n", $file_name;
            #library path
            $match = 0;
            ################
            # library loop #
            ################
            #printf STDERR "PRECOMPILE: %s\n", join(":", @$library_list);
            foreach $library_path (@$library_list) {
                if (!$match && !$error) {
                    $file = sprintf("%s%s", $library_path, $file_name);
                    #printf STDERR "file: \"%s\"\n", $file;
                    if (-e $file) {
                        $match = 1;
                        if (-r $file) {
                            if ($file_handle = IO::File->new($file, O_RDONLY)) {
                            } else {
                                $error = sprintf("unable to open file \"%s\" (%s)", $file, $!);
                                #print "$error\n";
                            }
                        } else {
                            $error = sprintf("file \"%s\" is not readable", $file);
                            #print "$error\n";
                        }
                    }
                }
            }
            if (!$match) {
                $file  = $file_name;
                $error = sprintf("file \"%s\" does not exist in any library path", $file);
                #print "$error\n";
            }
        }
        #################
        # quit on error #
        #################
        if ($error) {
            #store error message
            push @{$self->{code}}, [undef,      #line count
                                    \$file,     #file name
                                    [],         #code sequence
                                    "",         #label
                                    "",         #opcode
                                    "",         #arguments
                                    undef,      #linear pc
                                    undef,      #paged pc
                                    undef,      #hex code
                                    undef,      #bytes
                                    [$error],   #errors
                                    undef,      #macros
				    undef];     #symbol tables
            return 1;
        }

        #reset variables
        $error            = 0;
        $error_count      = 0;
        $line_count       = 0;
        @srccode_sequence = ();
        #############
        # line loop #
        #############
        while ($line = <$file_handle>) {
            #trim line
            chomp $line;
            $line =~ s/\s*$//;

            #untabify line
            #print STDERR "before:  $line\n";
            $Text::Tabs::tabstop = 8;
            $line = Text::Tabs::expand($line);
            #print STDERR "after:   $line\n";

            #increment line count
            $line_count++;

            #printf "ifds: %d %d %d %d\n", ($#$ifdef_stack,
            #                              $ifdef_stack->[$#$ifdef_stack]->[0],
            #                              $ifdef_stack->[$#$ifdef_stack]->[1],
            #                              $ifdef_stack->[$#$ifdef_stack]->[2]);
            #printf "line: %s\n", $line;
            ##############
            # parse line #
            ##############
            for ($line) {
                ################
                # comment line #
                ################
                /$PRECOMP_COMMENT_LINE/ && do {
                    #print " => is comment\n";
                    #check ifdef stack
                    if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                        #store comment line
                        push @srccode_sequence, $line;
                    }
                    last;};
                ##########
                # opcode #
                ##########
                /$PRECOMP_OPCODE/ && do {
                    #print " => is opcode\n";
                    #line =~  $PRECOMP_OPCODE
                    $label     = $1;
                    $opcode    = $2;
                    $arguments = $3;
                    $label     =~ s/^\s*//;
                    $label     =~ s/\s*$//;
                    $opcode    =~ s/^\s*//;
                    $opcode    =~ s/\s*$//;
                    $arguments =~ s/^\s*//;
                    $arguments =~ s/\s*$//;

                    #printf " ===> \"%s\" \"%s\" \"%s\"\n", $label, $opcode, $arguments;
                    #check ifdef stack
                    if ($ifdef_stack->[$#$ifdef_stack]->[0]){

			#Interpret pseudo opcode CPU
			if (uc($opcode) eq 'CPU') {
			    $cpu = uc($arguments);
			}

                        #store source code line
                        push @srccode_sequence, $line;
			if (defined $macro) {
			    push @{$self->{macros}->{$macro}}, [$line_count,          #line count
								\$file,               #file name
								[@srccode_sequence],  #code sequence
								$label,               #label
								$opcode,              #opcode
								$arguments,           #arguments
								undef,                #linear pc
								undef,                #paged pc
								undef,                #hex code
								undef,                #bytes
								0,                    #errors
								undef,                #macros
								undef];               #symbol tables

			    #add label to precompiler defines (makes HSW12 behave a little more like AS12)
			    if ($label =~ /\S/) {
				$self->{macro_symbols}->{uc($macro)}->{uc($label)} = undef;
			    }
			} else {
			    push @{$self->{code}}, [$line_count,          #line count
						    \$file,               #file name
						    [@srccode_sequence],  #code sequence
						    $label,               #label
						    $opcode,              #opcode
						    $arguments,           #arguments
						    undef,                #linear pc
						    undef,                #paged pc
						    undef,                #hex code
						    undef,                #bytes
						    0,                    #errors
						    undef,                #macros
						    undef];               #symbol tables

			    #add label to precompiler defines (makes HSW12 behave a little more like AS12)
			    if ($label =~ /\S/) {
				$self->{precomp_defs}->{uc($label)} = "";
				#if ($label =~ /^SCI/i) {printf " ===> \"%s\" \"%s\" \"%s\"\n", $label, $opcode, $arguments;}
			    }
			}
                        #reset code buffer
                        @srccode_sequence = ();
                    }
                    last;};
                ##############
                # blanc line #
                ##############
                /$PRECOMP_BLANC_LINE/ && do {
                    #print " => is blanc line\n";
                    #check ifdef stack
                    if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                        #store comment line
                        #push @srccode_sequence, "";
			#clear comment buffer
			@srccode_sequence = ();
                    }
                    last;};
                #########################
                # precompiler directive #
                #########################
                /$PRECOMP_DIRECTIVE/ && do {
                    #print " => is precompiler directive\n";
                    #line =~  $PRECOMP_DIRECTIVE
                    my $directive  = $1;
                    my $arg1       = $2;
                    my $arg2       = $3;
                    #printf "\"%s\" \"%s\" \"%s\"\n", $directive, $arg1, $arg2;

                    for ($directive) {
                        ##########
                        # define #
                        ##########
                        /$PRECOMP_DEFINE/ && do {
                            #print "   => define\n";
                            #print "       $arg1 $arg2\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
				$self->{precomp_defs}->{uc($arg1)} = "";
				#printf "        ==> %s\n", $self->{precomp_defs}->{uc($arg1)};
                            }
                            last;};
                        #########
                        # undef #
                        #########
                        /$PRECOMP_UNDEF/ && do {
                            #print "   => undef\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if (exists $self->{precomp_defs}->{uc($arg1)}) {
                                    delete $self->{precomp_defs}->{uc($arg1)};
                                }
                            }
                            last;};
                        #########
                        # ifdef #
                        #########
                        /$PRECOMP_IFDEF/ && do {
                            #print "   => ifdef\n";
                            #printf "   => %s\n", join(", ", keys %{$self->{precomp_defs}});
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if (exists $self->{precomp_defs}->{uc($arg1)}) {
                                    push @$ifdef_stack, [1, 0, 1];
                                } else {
                                    push @$ifdef_stack, [0, 0, 1];
                                }
                            } else {
                                push @$ifdef_stack, [0, 0, 0];
                            }
                            last;};
                        ##########
                        # ifndef #
                        ##########
                        /$PRECOMP_IFNDEF/ && do {
                            #print "   => ifndef\n";
                            #printf "   => %s\n", join(", ", keys %{$self->{precomp_defs}});
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if (! exists $self->{precomp_defs}->{uc($arg1)}) {
                                    push @$ifdef_stack, [1, 0, 1];
                                } else {
                                    push @$ifdef_stack, [0, 0, 1];
                                }
                            } else {
                                push @$ifdef_stack, [0, 0, 0];
                            }
                            last;};
                        #########
                        # ifmac #
                        #########
                        /$PRECOMP_IFMAC/ && do {
                            #print "   => ifmac\n";
                            #printf "   => %s\n", join(", ", keys %{$self->{macros}});
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if (exists $self->{macros}->{uc($arg1)}) {
                                    push @$ifdef_stack, [1, 0, 1];
                                } else {
                                    push @$ifdef_stack, [0, 0, 1];
                                }
                            } else {
                                push @$ifdef_stack, [0, 0, 0];
                            }
                            last;};
                        ##########
                        # ifnmac #
                        ##########
                        /$PRECOMP_IFNMAC/ && do {
                            #print "   => ifnmac\n";
                            #printf "   => %s\n", join(", ", keys %{$self->{macros}});
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if (! exists $self->{macros}->{uc($arg1)}) {
                                    push @$ifdef_stack, [1, 0, 1];
                                } else {
                                    push @$ifdef_stack, [0, 0, 1];
                                }
                            } else {
                                push @$ifdef_stack, [0, 0, 0];
                            }
                            last;};
                        #########
                        # ifcpu #
                        #########
                        /$PRECOMP_IFCPU/ && do {
                            #print "   => ifcpu\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if ($cpu eq uc($arg1)) {
                                    push @$ifdef_stack, [1, 0, 1];
                                } else {
                                    push @$ifdef_stack, [0, 0, 1];
                                }
                            } else {
                                push @$ifdef_stack, [0, 0, 0];
                            }
                            last;};
                        ##########
                        # ifncpu #
                        ##########
                        /$PRECOMP_IFNCPU/ && do {
                            #print "   => ifncpu\n";
                            #printf "   => %s\n", join(", ", keys %{$self->{macros}});
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if ($cpu ne uc($arg1)) {
                                    push @$ifdef_stack, [1, 0, 1];
                                } else {
                                    push @$ifdef_stack, [0, 0, 1];
                                }
                            } else {
                                push @$ifdef_stack, [0, 0, 0];
                            }
                            last;};
                        ########
                        # else #
                        ########
                        /$PRECOMP_ELSE/ && do {
                            #print "   => else\n";
                            #check ifdef stack
                                if ($ifdef_stack->[$#$ifdef_stack]->[1]){
                                    #unexpected "else"
                                    $error = "unexpected \"#else\" directive";
                                    #print "   => ERROR! $error\n";
                                    #store source code line
                                    push @srccode_sequence, $line;
                                    #store error message
                                    push @{$self->{code}}, [$line_count,         #line count
                                                            \$file,              #file name
                                                            [@srccode_sequence], #code sequence
                                                            "",                  #label
                                                            "",                  #opcode
                                                            "",                  #arguments
                                                            undef,               #linear pc
                                                            undef,               #paged pc
                                                            undef,               #hex code
                                                            undef,               #bytes
                                                            [$error],            #errors
                                                            undef,               #macros
							    undef];              #symbol tables
                                    $file_handle->close();
                                    return ++$error_count;
                                } else {
                                    if ($ifdef_stack->[$#$ifdef_stack]->[2]){
                                        #set else-flag
                                        $ifdef_stack->[$#$ifdef_stack]->[1] = 1;
                                        #invert ifdef-flag
                                        $ifdef_stack->[$#$ifdef_stack]->[0] = (! $ifdef_stack->[$#$ifdef_stack]->[0]);
                                    }
                                }
                            last;};
                        #########
                        # endif #
                        #########
                        /$PRECOMP_ENDIF/ && do {
                            #print "   => endif\n";
                            #check ifdef stack
                            if ($#$ifdef_stack <= 0){
                                #unexpected "else"
                                $error = "unexpected \"#endif\" directive";
                                #print "   => ERROR! $error\n";
                                #store source code line
                                push @srccode_sequence, $line;
                                #store error message
                                push @{$self->{code}}, [$line_count,         #line count
                                                        \$file,              #file name
                                                        [@srccode_sequence], #code sequence
                                                        "",                  #label
                                                        "",                  #opcode
                                                        "",                  #arguments
                                                        undef,               #linear pc
                                                        undef,               #paged pc
                                                        undef,               #hex code
                                                        undef,               #bytes
                                                        [$error],            #errors
                                                        undef,               #macros
							undef];              #symbol tables
                                $file_handle->close();
                                return ++$error_count;
                            } else {
                                pop @$ifdef_stack;
                            }
                            last;};
                        ###########
                        # include #
                        ###########
                        /$PRECOMP_INCLUDE/ && do {
                            #print "   => include $arg1\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]) {
                                #precompile include file
                                #printf STDERR "INCLUDE: %s\n", join(":", (@$library_list, dirname($file_list->[0])));
                                $value = $self->precompile([$arg1], [@$library_list, sprintf("%s%s", dirname($file_list->[0]), $PATH_DEL)], $ifdef_stack, $macro);
                                if ($value) {
                                    $file_handle->close();
                                    return ($value + $error_count);
                                }
                            }
                            last;};
                        #########
                        # macro #
                        #########
                        /$PRECOMP_MACRO/ && do {
			    #print "   => macro\n";
                            #print "       $arg1 $arg2\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
				if (defined $macro) {
                                    #unexpected "macro"
                                    $error = sprintf "unexpected \"#MACRO\" directive (no \"#EMAC\" for macro \"%s\")", uc($macro);
                                    #print "   => ERROR! $error\n";
                                    #store source code line
                                    push @srccode_sequence, $line;
                                    #store error message
                                    push @{$self->{code}}, [$line_count,         #line count
                                                            \$file,              #file name
                                                            [@srccode_sequence], #code sequence
                                                            "",                  #label
                                                            "",                  #opcode
                                                            "",                  #arguments
                                                            undef,               #linear pc
                                                            undef,               #paged pc
                                                            undef,               #hex code
                                                            undef,               #bytes
                                                            [$error],            #errors
                                                            undef,               #macros
							    undef];              #symbol tables
                                    $file_handle->close();
                                    return ++$error_count;
				} elsif (exists $self->{macros}->{uc($arg1)}) {
				    #macro redefined
                                    $error = sprintf "macro %s redefined", $arg1;
                                    #print "   => ERROR! $error\n";
                                    #store source code line
                                    push @srccode_sequence, $line;
                                    #store error message
                                    push @{$self->{code}}, [$line_count,         #line count
                                                            \$file,              #file name
                                                            [@srccode_sequence], #code sequence
                                                            "",                  #label
                                                            "",                  #opcode
                                                            "",                  #arguments
                                                            undef,               #linear pc
                                                            undef,               #paged pc
                                                            undef, ,             #hex code
                                                            undef,               #bytes
                                                            [$error],            #errors
                                                            undef,               #macros
							    undef];              #symbol tables
                                    $file_handle->close();
                                    return ++$error_count;
				} else {
				    ($error, $value) = @{$self->evaluate_expression($arg2, undef, undef, undef, undef)};
				    if (!defined $value) {
					#argument count undefined
					if (!$error) {
					    $error = "number of macro arguments not defined";
					}
					#print "   => ERROR! $error\n";
					#store source code line
					push @srccode_sequence, $line;
					#store error message
					push @{$self->{code}}, [$line_count,         #line count
								\$file,              #file name
								[@srccode_sequence], #code sequence
								"",                  #label
								"",                  #opcode
								"",                  #arguments
								undef,               #linear pc
								undef,               #paged pc
								undef,               #hex code
								undef,               #bytes
								[$error],            #errors
								undef,               #macros
								undef];              #symbol tables
					$file_handle->close();
					return ++$error_count;
				    } else {
					#define new macro
					$macro                           = uc($arg1);
					$self->{macro_symbols}->{$macro} = {}; 
					$self->{macro_argcs}->{$macro}   = $arg2;
					$self->{macros}->{$macro}        = [];
					#print "=> MACRO \"$macro\" defined\n";

				    }
				}
			    }
                            last;};
                        ########
                        # emac #
                        ########
                        /$PRECOMP_EMAC/ && do {
			    #print "   => emac\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
				if (defined $macro) {
				    undef $macro;
				} else {
                                    #unexpected "emac"
                                    $error = "unexpected \"#EMAC\" directive";
                                    #print "   => ERROR! $error\n";
                                    #store source code line
                                    push @srccode_sequence, $line;
                                    #store error message
                                    push @{$self->{code}}, [$line_count,         #line count
                                                            \$file,              #file name
                                                            [@srccode_sequence], #code sequence
                                                            "",                  #label
                                                            "",                  #opcode
                                                            "",                  #arguments
                                                            undef,               #linear pc
                                                            undef,               #paged pc
                                                            undef,               #hex code
                                                            undef,               #bytes
                                                            [$error],            #errors
							    undef,               #macros
							    undef];              #symbol tables
                                    $file_handle->close();
                                    return ++$error_count;
				}
                            }
                            last;};
                        #################################
                        # invalid precompiler directive #
                        #################################
                        // && do {
                            #print "   => invalid precompiler directive\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                #unexpected "else"
                                $error = "invalid precompiler directive";
                                #store source code line
                                push @srccode_sequence, $line;
                                #store error message
                                push @{$self->{code}}, [$line_count,         #line count
                                                        \$file,              #file name
                                                        [@srccode_sequence], #code sequence
                                                        "",                  #label
                                                        "",                  #opcode
                                                        "",                  #arguments
                                                        undef,               #linear pc
                                                        undef,               #paged pc
                                                        undef,               #hex code
                                                        undef,               #bytes
                                                        [$error],            #errors
							undef,               #macros
							undef];              #symbol tables
				$file_handle->close();
				return ++$error_count;
                                #++$error_count;
                                #@srccode_sequence = ();
                            }
                        last;};
                    }
                    last;};

                ##################
                # invalid syntax #
                ##################
                // && do {
                    #print "   => invalid syntax\n";
                    #check ifdef stack
                    if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                        #unexpected "else"
                        $error = "invalid syntax";
                        #store source code line
                        push @srccode_sequence, $line;
                        #store error message
                        push @{$self->{code}}, [$line_count,         #line count
                                                \$file,              #file name
                                                [@srccode_sequence], #code sequence
                                                "",                  #label
                                                "",                  #opcode
                                                "",                  #arguments
                                                undef,               #linear pc
                                                undef,               #paged pc
                                                undef,               #hex code
                                                undef,               #bytes
                                                [$error],            #errors
						undef,               #macros
						undef];              #symbol tables
			$file_handle->close();
			return ++$error_count;
                        #$error_count++;
                        #@srccode_sequence = ();
                    }
                    last;};
            }
        }
    }
    $file_handle->close();
    return $error_count;
}

#######################
# export_precomp_defs #
#######################
sub export_precomp_defs {
    my $self = shift @_;
    my $key;
    my $string;
    my $error;
    my $value;

    ###########################
    # precompiler define loop #
    ###########################
    foreach $key (keys %{$self->{precomp_defs}}) {
        $string = $self->{precomp_defs}->{uc($key)};
        #default value
        if (!defined $string) {
            #$string = "1";
            $string = undef;
        } elsif ($string =~ /^\s*$/) {
            #$string = "1";
            $string = undef;
        } else {
            printf "\"%s\" \"%s\" \n", $key, $string;
	}

        #check if symbol already exists
        if (! exists $self->{comp_symbols}->{uc($key)}) {

            if (!defined $string) {
                $error = 0;
                $value = undef;
            } else {
                ($error, $value) = @{$self->evaluate_expression($string, undef, undef, undef, undef)};
            }
            #export define
            $self->{comp_symbols}->{uc($key)} = $value;
            #printf "\"%s\" \"%s\" \"%s\"\n", $key, $string, $value;
        }
    }
}

######################
# initialize symbols #
######################
sub initialize_symbols {
    my $self    = shift @_;
    my $symbols = shift @_;   
    my $key;
    my $string;
    my $error;
    my $value;

    ###############
    # symbol loop #
    ###############
    foreach $key (keys %{$self->{comp_symbols}}) {
	if (! defined $self->{comp_symbols}->{$key}) {	
	    if (exists $symbols->{$key}) {
		if (defined $symbols->{$key}) {
		    $self->{comp_symbols}->{$key} = $symbols->{$key};
		    #printf STDERR "Importing: %s=%s\n",  $key, $symbols->{$key};
		}
	    }
	}
    }
    #foreach $key (keys %{$self->{comp_symbols}}) {
    #	printf STDERR "COMP: %s\n",  $key;
    #}
}

###############
# compile_run #
###############
sub compile_run {
    my $self          = shift @_;

    #code
    my $code_entry;
    my $code_entry_cnt;
    my $code_label;
    my $code_opcode;
    my $code_args;
    my $code_pc_lin;
    my $code_pc_pag;
    my $code_hex;
    my $code_byte_cnt;
    my $code_macros;
    my $code_sym_tab;
    my $code_sym_tab_key;
    my $code_sym_tab_val;
    my $code_sym_tabs;
    my $code_sym_tab_cnt;
    #opcode
    my $opcode_entries;
    my $opcode_entry;
    my $opcode_entry_cnt;
    my $opcode_entry_total;
    my $opcode_amode_expr;
    my $opcode_amode_check;
    my $opcode_amode_opcode;
    #macros
    my $macro_name;
    my @macro_args;
    my $macro_argc;
    my @macro_comments;
    my $macro_comment;
    my $macro_comment_replace;
    my $macro_comment_keep;
    my $macro_label;
    my $macro_label_replace;
    my $macro_opcode;
    my $macro_opcode_replace;
    my $macro_arg;
    my $macro_arg_replace;
    my $macro_hierarchy;
    my $macro_sym_tab;
    my $macro_sym_tabs;
    my $macro_symbol;
    my $macro_entries;
    my $macro_entry;
    my @macro_code_list;

    #label
    my @label_stack;
    my $prev_macro_depth;
    my $cur_macro_depth;

    my $label_value;
    my $label_ok;
    #program counters
    my $pc_lin;
    my $pc_pag;
    #loc count
    my $loc_cnt;
    #problem counters
    my $error_count;
    my $undef_count;
    my $redef_count;
    #temporary
    my $result;
    my $error;
    my $match;

    #######################
    # initialize counters #
    #######################
    $pc_lin      = undef;
    $pc_pag      = undef;
    $loc_cnt     = 0;
    $error_count = 0;
    $undef_count = 0;
    $redef_count = 0;

    #####################
    # reset labels hash #
    #####################
    @label_stack      = ({});
    $prev_macro_depth = 0;

    #####################
    # reset direct page #
    #####################
    $self->{dir_page} = 0;

    #############
    # code loop #
    #############
    #print "compile_run:\n";

    #foreach $code_entry (@{$self->{code}}) {
    for ($code_entry_cnt = 0;
	 $code_entry_cnt <= $#{$self->{code}};
	 $code_entry_cnt++) {
	$code_entry = $self->{code}->[$code_entry_cnt];
	
        $code_label    = $code_entry->[3];
        $code_opcode   = $code_entry->[4];
        $code_args     = $code_entry->[5];
        $code_pc_lin   = $code_entry->[6];
        $code_pc_pag   = $code_entry->[7];
        $code_hex      = $code_entry->[8];
        $code_byte_cnt = $code_entry->[9];
        $code_macros   = $code_entry->[11];
        $code_sym_tabs = $code_entry->[12];

        #print  STDERR "error_count = $error_count\n";
        #print  STDERR "undef_count = $undef_count\n";
	#if (defined $code_macros) {
	#    printf STDERR "%-8s %-8s %s (%s)\n", $code_label, $code_opcode, $code_args, join(",", @$code_macros);
	#} else {
	#    printf STDERR "%-8s %-8s %s\n", $code_label, $code_opcode, $code_args;
	#}
	#if (defined $code_sym_tabs) {
	#    printf "               sym_tabs defined: (%d)\n", ($#$code_sym_tabs+1);
	#    foreach $code_sym_tab (@{$code_sym_tabs}) {
	#	 print "               -> ";
	#	 foreach $code_sym_tab_key (keys %{$code_sym_tab}) {
	#	     $code_sym_tab_val = $code_sym_tab->{$code_sym_tab_key};
	#	     if (defined $code_sym_tab_val) {
	#		 printf "%s=%x ", $code_sym_tab_key, $code_sym_tab_val;
	#	     } else {
	#		 printf "%s=? ", $code_sym_tab_key;
	#	     }
	#	 }
	#	 print "\n";
	#    }
	#} else {
	#    #print "sym_tabs not defined!\n";
	#}

        ########################
        # set program counters #
        ########################
        if (defined $pc_lin) {
            $code_entry->[6] = $pc_lin;
        }
        if (defined $pc_pag) {
            $code_entry->[7] = $pc_pag;
        }

        ###################
        # set label_value #
        ###################
        $label_value = $pc_pag;

        #####################
        # determine hexcode #
        #####################
        if (exists $self->{opcode_table}->{uc($code_opcode)}) {
            ################
            # valid opcode #
            ################
            $opcode_entries = $self->{opcode_table}->{uc($code_opcode)};
            $match   = 0;
            $error   = 0;
            $result  = 0;
            foreach $opcode_entry (@$opcode_entries) {
                if (!$match && !$error) {
                    $opcode_amode_expr   = $opcode_entry->[0];
                    $opcode_amode_check  = $opcode_entry->[1];
                    $opcode_amode_opcode = $opcode_entry->[2];
                    #check address mode
                    #printf STDERR "valid opcode: %s %s (%s)\n", $code_opcode, $code_args, $opcode_amode_opcode;
                    if ($code_args =~ $opcode_amode_expr) {
                        $error  = 0;
                        $result = 0;
                        #printf STDERR "valid arg format: %s \"%s\" (%s)\n", $code_opcode, $1, $opcode_amode_opcode;
                        if (&{$opcode_amode_check}($self,
                                                   [$1,$2,$3,$4,$5,$6,$7,$8],
                                                   $pc_lin, $pc_pag, $loc_cnt,
                                                   $code_sym_tabs,
                                                   \$opcode_entry->[2],
                                                   \$error,
                                                   \$result)) {
                            #printf STDERR "valid args: %s (%s)\n", $code_opcode, $opcode_amode_opcode;
                            $match = 1;
                            if ($error) {
                                #syntax error
                                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                                $error_count++;
                                #printf STDERR "ERROR: %s %s %s\n", $code_opcode, $opcode_amode_opcode, $opcode_amode_expr;
                            } elsif ($result) {
                                #opcode found
                                $code_entry->[8] = $result;
                                $code_entry->[9] = split " ", $result;
                                if (defined $pc_lin) {
                                    #increment linear PC
                                    $pc_lin = $pc_lin + $code_entry->[9];
                                }
                                if (defined $pc_pag) {
                                    #######################################
                                    # check if a 16k boundary is chrossed #
                                    #######################################
                                    if (($pc_pag >> 14) !=
                                        (($pc_pag + $code_entry->[9]) >> 14)) {
                                        $error = sprintf("16k boundary crossed: %.6X -> %.6X", ($pc_pag,
                                                                                                ($pc_pag + $code_entry->[9])));
                                        $code_entry->[10] = [@{$code_entry->[10]}, $error];
                                        $error_count++;
                                        $pc_lin = undef;
                                    }
                                    #increment paged PC
                                    $pc_pag = $pc_pag + $code_entry->[9];
                                    if ($result =~ $CMP_NO_HEXCODE) {
                                        $undef_count++;
                                        #print "$opcode_hexargs\n";
                                    }
                                } else {
                                    # undefined PC
                                    $undef_count++;
                                }
                            } else {
                                #opcode undefined
                                #$pc_lin = undef; #Better results if program counter keep an approximate value
                                #$pc_pag = undef;
                                $undef_count++;
                                #printf STDERR "OPCODE UNDEFINED\n";
                            }
                        }
                    }#else {printf STDERR "MISMATCH: \"%s\" \"%s\"\n", $code_args, $opcode_amode_expr;}
                }
            }
            if (!$match) {
                if (!$error) {
                    $error = sprintf("invalid address mode for opcode \"%s\" (%s)", (uc($code_opcode),
                                                                                     $code_args));
                }
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $error_count++;
            }
        } elsif (exists $PSEUDO_OPCODES->{uc($code_opcode)}) {
            #######################
            # valid pseudo opcode #
            #######################
            #print "valid pseudo opcode: $code_opcode ($code_entry->[0])\n";
            $PSEUDO_OPCODES->{uc($code_opcode)}($self,
                                                \$pc_lin,
                                                \$pc_pag,
                                                \$loc_cnt,
                                                \$error_count,
                                                \$undef_count,
                                                \$label_value,
                                                $code_entry);
        } elsif (exists $self->{macros}->{uc($code_opcode)}) {
            #########
            # macro #
            #########
	    #set "MACRO" identifier
	    $code_entry->[8] = "MACRO";

	    #determine macro name
	    $macro_name = uc($code_opcode);

	    #check for recursive macro call
	    if (defined $code_macros) {
		$result = grep {$macro_name eq $_} @$code_macros;
		#printf "macros \"%s\", %b: %s\n", $macro_name, $result, join(", ", @$code_macros);
	    } else {
		$result = -1;
	    }

	    if ($result <= 0) {
		#check macro_args
		#@macro_args = split($DEL, $code_args);
	        @macro_args = ();
		while ($code_args =~ /^[,\s]*(\([^\(\)]*?\)|\".*?\"|\'.*?\'|[^\s,]+)/) {
		    #printf "macros args: \"%s\" (%d,%d) => %s\n", $code_args, $#macro_args, $self->{macro_argcs}->{$macro_name}, join(", ", @macro_args);
		    my $code_arg = $1; #set current $code_arg 
		    $code_args = $';#'  #remove current $code_arg from $code_args
		    #remove parenthesis from $current $code_arg		
		    if ($code_arg =~ /^\((.*)\)$/) {
			$code_arg = $1;
		    }
		    push @macro_args, $code_arg;
		}
		#printf "macros args: \"%s\" (%d,%d) => %s\n", $code_args, $#macro_args, $self->{macro_argcs}->{$macro_name}, join(", ", @macro_args);
		if (($#macro_args+1) == $self->{macro_argcs}->{$macro_name}) {
		    #determine macro hierarchy
		    if (defined $code_macros) {
			$macro_hierarchy = [$macro_name, @$code_macros];
		    } else {
			$macro_hierarchy = [$macro_name];
		    }
		    #printf "macros hierarchy: %s\n", join("/", @$macro_hierarchy);

		    #create a new local symbol table
		    $macro_sym_tab = {};
		    foreach $macro_symbol (keys %{$self->{macro_symbols}->{$macro_name}}) {
			$macro_sym_tab->{$macro_symbol} = undef;
			$undef_count++;
		    }
		    #printf "new macro table (%s): (%s) (%s)\n", $macro_name, join(",", keys %$macro_sym_tab), join(",", keys %{$self->{macro_symbols}->{$macro_name}});

		    if (defined $code_sym_tabs) {
			$macro_sym_tabs = [$macro_sym_tab, @$code_sym_tabs];
		    } else {
			$macro_sym_tabs = [$macro_sym_tab];
		    }
		    #printf "macro tables (%s): (%s)\n", join("/", @$macro_hierarchy), ($#$macro_sym_tabs+1);

		    #copy macro elements
		    #printf "macros: %d\n", ($#{$self->{macros}->{$macro_name}}+1);
		    $macro_entries = []; 
		    foreach $macro_entry (@{$self->{macros}->{$macro_name}}) {

			#replace macro comments
			@macro_comments = @{$macro_entry->[2]};
			$macro_comment  = pop @macro_comments;
			if ($macro_comment =~ /^(.*)(\;.*)$/ ) {
			    $macro_comment = $1;
			    $macro_comment_keep = $2;
			} else {
			    $macro_comment_keep = "";
			}
			foreach $macro_argc (1..$self->{macro_argcs}->{$macro_name}) {
			    $macro_comment_replace = $macro_args[$macro_argc-1];
			    $macro_comment =~ s/\\$macro_argc/$macro_comment_replace/g;
			    #printf "replace macro comment: %d \"%s\" => \"%s\"\n", $macro_argc, $macro_comment_replace, $macro_comment;
			}
			$macro_comment .=  $macro_comment_keep;
			
			#replace macro label
			$macro_label = $macro_entry->[3];
			foreach $macro_argc (1..$self->{macro_argcs}->{$macro_name}) {
			    $macro_label_replace = $macro_args[$macro_argc-1];
			    $macro_label =~ s/\\$macro_argc/$macro_label_replace/g;
			    #printf "replace macro label: %d \"%s\", \"%s\" => \"%s\"\n", $macro_argc, $macro_entry->[3], $macro_label_replace, $macro_label;
			}

			#replace macro opcodes
			$macro_opcode = $macro_entry->[4];
			foreach $macro_argc (1..$self->{macro_argcs}->{$macro_name}) {
			    $macro_opcode_replace = $macro_args[$macro_argc-1];
			    $macro_opcode =~ s/\\$macro_argc/$macro_opcode_replace/g;
			    #printf "replace macro opcode: %d \"%s\", \"%s\" => \"%s\"\n", $macro_argc, $macro_entry->[4], $macro_opcode_replace, $macro_opcode;
			}

			#replace macro args
			$macro_arg = $macro_entry->[5];
			foreach $macro_argc (1..$self->{macro_argcs}->{$macro_name}) {
			    $macro_arg_replace = $macro_args[$macro_argc-1];
			    $macro_arg =~ s/\\$macro_argc/$macro_arg_replace/g;
			    #printf "replace macro arg: %d \"%s\", \"%s\" => \"%s\"\n", $macro_argc, $macro_entry->[5], $macro_arg_replace, $macro_arg;
			}

			#copy macro element
			push @$macro_entries , [$macro_entry->[0],
						$macro_entry->[1],
						[@macro_comments, $macro_comment],
						$macro_label,
						$macro_opcode,
						$macro_arg,
						$macro_entry->[6],
						$macro_entry->[7],
						$macro_entry->[8],
						$macro_entry->[9],
						$macro_entry->[10],
						$macro_hierarchy,
						$macro_sym_tabs];
			#printf "copy macro entries: \"%s\" \"%s\" (\"%s\")\n", $macro_entry->[4], $macro_arg, $macro_entry->[5];

		    }
		    
		    #insert macro into code
		    @macro_code_list = splice @{$self->{code}}, $code_entry_cnt+1;
		    push @{$self->{code}}, @$macro_entries;
		    push @{$self->{code}}, @macro_code_list;

		    #remove opcode and args from macro entry
		    $code_entry->[4] = "";
		    $code_entry->[5] = "";

		} else {
		    #wrong number of arguments
                    $error = sprintf("wrong number of arguments for macro \"%s\" (%s)", (uc($code_opcode),
                                                                                         $code_args));
		    $code_entry->[10] = [@{$code_entry->[10]}, $error];
		    $error_count++;
		}
	    } else {
		#nested macro call detected
		$error = sprintf("recursive call of  macro \"%s\"", (uc($code_opcode)));
		$code_entry->[10] = [@{$code_entry->[10]}, $error];
		$error_count++;
	    }
        } elsif ($code_opcode =~ /^\s*$/) {
            ###############
            # plain label #
            ###############
	    if (defined $code_entry->[8]) {
		if ($code_entry->[8] ne "MACRO") {
		    $code_entry->[8] = "";
		}
	    } else {
		$code_entry->[8] = "";
	    }
        } else {
            ##################
            # invalid opcode #
            ##################
            $error = sprintf("invalid opcode \"%s\"", $code_opcode);
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $error_count++;
            $pc_lin = undef;
            $pc_pag = undef;
            #print "$error\n";
        }

	######################
	# update label stack #
	######################
	if (defined $code_macros) {
	    $cur_macro_depth = $#$code_macros + 1;
	} else {
	    $cur_macro_depth = 0;
	}	    
	#printf "macro depth: %d (%d)\n", $cur_macro_depth, $prev_macro_depth;
	if ($prev_macro_depth < $cur_macro_depth) {
	    #nested macro started
	    unshift @label_stack, {};
	    #printf "macro started: (%d), %s\n", $cur_macro_depth, join(", ", @$code_macros);
	}
	if ($prev_macro_depth > $cur_macro_depth) {
	    #nested macro ended
	    shift @label_stack;
	    #if (defined  $code_macros) {
	    #	 printf "macro ended: (%d), %s\n", $cur_macro_depth, join(", ", @$code_macros);
	    #} else {
	    #	 printf "macro ended: (%d)\n", $cur_macro_depth;
	    #}
	}	    
	$prev_macro_depth = $cur_macro_depth;
	    
        #############
        # set label #
        #############
        if ($code_label =~ /\S/) {

            #use upper case symbol names
            $code_label = uc($code_label);
            #substitute LOC count
            if ($code_label =~ /^\s*(.+)\`\s*$/) {
                $code_label = uc(sprintf("%s%.4d", $1, $loc_cnt));
            }

            #################################
            # check for label redefinitions #
            #################################
            $label_ok = 1;
            if (exists $label_stack[0]->{$code_label}) {
                if (defined $label_stack[0]->{$code_label}) {
                    if (defined $label_value) {
                        if ($label_stack[0]->{$code_label} != $label_value) {
                            $error = sprintf("illegal redefinition of symbol \"%s\" (\$%X -> \$%X)", ($code_label,
                                                                                                      $label_stack[0]->{$code_label},
                                                                                                      $label_value));
                            $code_entry->[10] = [@{$code_entry->[10]}, $error];
                            $error_count++;
                            $label_ok = 0;
                        }
                    }
                }
            } else {
                $label_stack[0]->{$code_label} = $label_value;
            }

            if ($label_ok == 1) {
                ###############
                # check label #
                ###############
		if (defined $code_sym_tabs) {
		    $code_sym_tab_cnt = $#$code_sym_tabs;
		} else {
		    $code_sym_tab_cnt = -1;
		}
		if ($code_sym_tab_cnt < 0) {
		    #main code
		    if (exists $self->{comp_symbols}->{$code_label}) {
			if (defined $self->{comp_symbols}->{$code_label}) {
			    if (defined $label_value) {
				if ($self->{comp_symbols}->{$code_label} != $label_value) {
				    ######################
				    # label redefinition #
				    ######################
				    if ($self->{compile_count} >= ($MAX_COMP_RUNS-5)) {
				            printf STDOUT "Hint! Symbol redefinition: %s %X->%X (%s %s)\n", ($code_label,
													     $self->{comp_symbols}->{$code_label},
													     $label_value,
													     ${$code_entry->[1]},
													     $code_entry->[0]);
				    }
				    $redef_count++;
				    $self->{comp_symbols}->{$code_label} = $label_value;
				}
			    } else {
				######################
				# label redefinition #
				######################
				if ($self->{compile_count} >= ($MAX_COMP_RUNS-5)) {
				    printf STDOUT "Hint! Symbol redefinition: %s %X->undef (%s %s)\n", ($code_label,
													$self->{comp_symbols}->{$code_label},
													${$code_entry->[1]},
													$code_entry->[0]);
				}
				$redef_count++;
				$self->{comp_symbols}->{$code_label} = undef;
			    }
			} else {
			    ####################
			    # label definition #
			    ####################
			    $self->{comp_symbols}->{$code_label} = $label_value;
			}
		    } else {
			########################
			# new label definition #
			########################
			$self->{comp_symbols}->{$code_label} = $label_value;
			#printf STDERR "new: %s %s undef (%s %s)\n", ($code_label,
			#	 				      $self->{comp_symbols}->{$code_label},
			#	 				      ${$code_entry->[1]},
			#	 				      $code_entry->[0]);
		    }
		} else {
		    #macro label
		    if (exists $code_sym_tabs->[0]->{$code_label}) {
			if (defined $code_sym_tabs->[0]->{$code_label}) {
			    if (defined $label_value) {
				if ($code_sym_tabs->[0]->{$code_label} != $label_value) {
				    ######################
				    # label redefinition #
				    ######################
				    if ($self->{compile_count} >= ($MAX_COMP_RUNS-5)) {
				            printf STDOUT "Hint! Symbol redefinition within a macro: %s %X->%X (%s %s)\n", ($code_label,
															    $code_sym_tabs->[0]->{$code_label},
															    $label_value,
															    ${$code_entry->[1]},
															    $code_entry->[0]);
				    }
				    $redef_count++;
				    $code_sym_tabs->[0]->{$code_label} = $label_value;
				}
			    } else {
				######################
				# label redefinition #
				######################
				if ($self->{compile_count} >= ($MAX_COMP_RUNS-5)) {
				    printf STDOUT "Hint! Symbol redefinition within a macro: %s %X->undef (%s %s)\n", ($code_label,
														       $code_sym_tabs->[0]->{$code_label},
														       ${$code_entry->[1]},
														       $code_entry->[0]);
				}
				$redef_count++;
				$code_sym_tabs->[0]->{$code_label} = undef;
			    }
			} else {
			    ####################
			    # label definition #
			    ####################
			    $code_sym_tabs->[0]->{$code_label} = $label_value;
			}
		    } else {
			########################
			# new label definition #
			########################
			$code_sym_tabs->[0]->{$code_label} = $label_value;
		    }
		}
            }
        }
    }
    return [$error_count, $undef_count, $redef_count];
}

####################
# set_opcode_table #
####################
sub set_opcode_table {
    my $self    = shift @_;
    my $cpu     = shift @_;
    #print STDERR "CPU: $cpu\n";

    for ($cpu) {
        ########
        # HC11 #
        ########
        /$CPU_HC11/ && do {
            $self->{opcode_table} = $OPCTAB_HC11;
            return 0; last;};
        ############
        # HC12/S12 #
        ############
        /$CPU_S12/ && do {
            $self->{opcode_table} = $OPCTAB_S12;
            return 0; last;};
        ########
        # S12X #
        ########
        /$CPU_S12X/ && do {
             $self->{opcode_table} = $OPCTAB_S12X;
            return 0; last;};
        #########
        # XGATE #
        #########
        /$CPU_XGATE/ && do {
            $self->{opcode_table} = $OPCTAB_XGATE;
            return 0; last;};
        ###############
        # DEFAULT CPU #
        ###############
        $self->{opcode_table} = $OPCTAB_S12;
        return sprintf "invalid CPU \"%s\". Using S12 opcode map instead.", $cpu;
    }
}

#######################
# evaluate_expression #
#######################
sub evaluate_expression {
    my $self     = shift @_;
    my $expr     = shift @_;
    my $pc_lin   = shift @_;
    my $pc_pag   = shift @_;
    my $loc_cnt  = shift @_;
    my $sym_tabs = shift @_;

    #terminal
    my $complement;
    my $string;
    #binery conversion
    my $binery_value;
    my $binery_char;
    #ascii conversion
    my $ascii_value;
    my $ascii_char;
    #symbol lookup
    my @symbol_tabs;
    my $symbol_tab;
    my $symbol_name;
    #formula
    my $formula;
    my $formula_left;
    my $formula_middle;
    my $formula_right;
    my $formula_resolved_left;
    my $formula_resolved_middle;
    my $formula_resolved_right;
    my $formula_error;
    #printf "evaluate_expression: \"%s\"\n", $expr;

    if (defined $expr) {
        #trim expression
        #$expr =~ s/^\s*//;
        #$expr =~ s/\s*$//;

        for ($expr) {
            #################
            # binary number #
            #################
            /$OP_BINERY/ && do {
                $complement = $1;
                $string     = $2;
                #printf "terminal bin: \"%s\" \"%s\"\n", $complement, $string;
                $binery_value = 0;
                foreach $binery_char (split //, $string) {
                    if ($binery_char =~ /^[01]$/) {
                        $binery_value = $binery_value << 1;
                        if ($binery_char ne "0") {
                            $binery_value++;
                        }
                    }
                }
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~$binery_value)];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, ($binery_value * -1)];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, $binery_value];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ##################
            # decimal number #
            ##################
            /$OP_DEC/ && do {
                $complement = $1;
                $string     = $2;
                $string =~ s/_//g;
                #printf "terminal dec: \"%s\" \"%s\"\n", $complement, $string;
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~(int(sprintf("%d", $string))))];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, (int(sprintf("%d", $string)) * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, int(sprintf("%d", $string))];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ######################
            # hexadecimal number #
            ######################
            /$OP_HEX/ && do {
                $complement = $1;
                $string     = $2;
                $string =~ s/_//g;
                #printf "terminal hex: \"%s\" \"%s\"\n", $complement, $string;
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~(hex($string)))];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, (hex($string) * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, hex($string)];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ###################
            # ASCII character #
            ###################
            /$OP_ASCII/ && do {
                $complement = $1;
                $string     = $2;
                #printf "terminal ascii: \"%s\" \"%s\"\n", $complement, $string;

                #replace escaped characters
                $string =~ s/\\,/,/g;   #escaped commas
                #$string =~ s/\\\ /\ /g; #escaped spaces
                #$string =~ s/\\\t/\t/g; #escaped tabss

                $ascii_value = 0;
                foreach $ascii_char (split //, $string) {
                    $ascii_value = $ascii_value << 8;
                    $ascii_value = $ascii_value | ord($ascii_char);
                }
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~$ascii_value)];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, ($ascii_value * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, $ascii_value];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ####################
            # current linear PC #
            ####################
            /$OP_CURR_LIN_PC/ && do {
                $complement = $1;
                #printf "terminal addr: \"%s\" \"%s\"\n", $complement, $comp_pc_paged;
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~$pc_lin)];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, ($pc_lin * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, $pc_lin];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ####################
            # current paged PC #
            ####################
            /$OP_CURR_PAG_PC/ && do {
                $complement = $1;
                #printf "terminal addr: \"%s\" \"%s\"\n", $complement, $comp_pc_paged;
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~$pc_pag)];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, ($pc_pag * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, $pc_pag];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ###################
            # compiler symbol #
            ###################
            /$OP_SYMBOL/ && do {
                $complement = $1;
                $string     = uc($2);
                ########################
                # substitute loc count #
                ########################
                #substitute LOC count
                if ($string =~ /^\s*(.+)\`\s*$/) {
                #if ($string =~ /^\s*(.*)\`\s*$/) {
                    $string = sprintf("%s%.4d", $1, $loc_cnt);
                }
                #printf "terminal symb: \"%s\" \"%s\"\n", $complement, $string;
                if ($string !~ $OP_KEYWORDS) {
		    if (defined $sym_tabs) {
			@symbol_tabs = (@$sym_tabs, $self->{comp_symbols});
			#printf "symbol_tabs: %d\n", ($#symbol_tabs+1);
		    } else {
			@symbol_tabs = ($self->{comp_symbols});
			#printf "symbol_tabs: %d (no sym_tabs)\n", ($#symbol_tabs+1);
		    }
		    
		    foreach $symbol_tab (@symbol_tabs) {
			#printf "\"%s\" -> \"%s\": %s\n", $expr, $string, join(",", keys %$symbol_tab);
			if (exists $symbol_tab->{uc($string)}) {
			    if (defined $symbol_tab->{uc($string)}) {
				#printf STDERR "symbol: \"%s\" \"%s\"\n", uc($string), $symbol_tab->{uc($string)};

				for ($complement) {
				    /^~$/ && do {
					#1's complement
					return [0, (~$symbol_tab->{uc($string)})];
					last;};
				    /^\-$/ && do {
					#2's complement
					return [0, ($symbol_tab->{uc($string)} * (-1))];
					last;};
				    /^\s*$/ && do {
					#no complement
					return [0, $symbol_tab->{uc($string)}];
					last;};
				    #syntax error
				    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
				}
			    } else {
				#printf STDERR "symbol: \"%s\" undefined\n", uc($string);
				return [0, undef];
			    }
			}
		    }

                    if (! exists $self->{compile_count}) {
                        return [sprintf("unknown symbol \"%s\"", $string), undef];
                    } elsif ($self->{compile_count} > 1) {
                        return [sprintf("unknown symbol \"%s\"", $string), undef];
                    } else {
                        return [0, undef];
                    }
                } else {
                    return [sprintf("invalid use of keyword \"%s\"", $string), undef];
                }
                last;};
            ###############
            # parenthesis #
            ###############
            /$OP_FORMULA_PARS/ && do {
                $formula_left   = $1;
                $formula_middle = $2;
                $formula_right  = $3;
                ($formula_error, $formula_resolved_middle) = @{$self->evaluate_expression($formula_middle, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_middle) {
                    return [0, undef];
                } else {
                    $formula = sprintf("%s%d%s", ($formula_left,
                                                  $formula_resolved_middle,
                                                  $formula_right));

                    return $self->evaluate_expression($formula, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs);
                }
                last;};
            #############################
            # double negation/invertion #
            #############################
            /$OP_FORMULA_COMPLEMENT/ && do {
                $complement     = $1;
                $formula_right  = $2;
                ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_right) {
                    return [0, undef];
                } else {
                    for ($complement) {
                        /^~$/ && do {
                            #1's complement
                            return [0, (~$formula_resolved_right)];
                            last;};
                        /^\-$/ && do {
                            #2's complement
                            return [0, ($formula_resolved_right * (-1))];
                            last;};
                        #syntax error
                        return [sprintf("wrong syntax \"%s%s\"", $complement, $formula_right), undef];
                    }
                }
                last;};
            #######
            # and #
            #######
            /$OP_FORMULA_AND/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve ANDs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left & $formula_resolved_right)];
                    }
                }
                last;};
            ######
            # or #
            ######
            /$OP_FORMULA_OR/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve ORs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left | $formula_resolved_right)];
                    }
                }
                last;};
            ########
            # exor #
            ########
            /$OP_FORMULA_EXOR/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve EXORs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left ^ $formula_resolved_right)];
                    }
                }
                last;};
            ##############
            # rightshift #
            ##############
            /$OP_FORMULA_RIGHTSHIFT/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve RIGHTSHIFTSs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left >> $formula_resolved_right)];
                    }
                }
                last;};
            #############
            # leftshift #
            #############
            /$OP_FORMULA_LEFTSHIFT/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve LEFTSHIFTs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left << $formula_resolved_right)];
                    }
                }
                last;};
            ##################
            # multiplication #
            ##################
            /$OP_FORMULA_MUL/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve MULs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left * $formula_resolved_right)];
                    }
                }
                last;};
            ############
            # division #
            ############
            /$OP_FORMULA_DIV/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve DIVs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, int($formula_resolved_left / $formula_resolved_right)];
                    }
                }
                last;};
            ###########
            # modulus #
            ###########
            /$OP_FORMULA_MOD/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve MODs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left % $formula_resolved_right)];
                    }
                }
                last;};
            ########
            # plus #
            ########
            /$OP_FORMULA_PLUS/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve PLUSes: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left + $formula_resolved_right)];
                    }
                }
                last;};
            #########
            # minus #
            #########
            /$OP_FORMULA_MINUS/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve MINUSes: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left - $formula_resolved_right)];
                    }
                }
                last;};
            ##############
            # whitespace #
            ##############
            /$OP_WHITESPACE/ && do {
                return [0, undef];
                last;};
            ##################
            # unknown syntax #
            ##################
            return [sprintf("wrong syntax \"%s\"", $expr), undef];
            #return [sprintf("wrong syntax", $expr), undef];
            }
    } else {
        return [0, undef];
    }
    return [0, undef];
}

########################
# determine_addrspaces #
########################
sub determine_addrspaces {
    my $self      = shift @_;

    #code
    my $code_pc_lin;
    my $code_pc_pag;
    my $code_hex;
    my $code_entry;
    #data
    my $address;
    my $byte;
    my $first_byte;

    ########################
    # reset address spaces #
    ########################
    $self->{lin_addrspace} = {};
    $self->{pag_addrspace} = {};

    #############
    # code loop #
    #############
    #print "compile_run:\n";
    foreach $code_entry (@{$self->{code}}) {
        $code_pc_lin   = $code_entry->[6];
        $code_pc_pag   = $code_entry->[7];
        $code_hex      = $code_entry->[8];

        ########################
        # linear address space #
        ########################
        if (defined $code_pc_lin) {
            $address = $code_pc_lin;
            if (($code_hex !~ /$CMP_NO_HEXCODE/) &&
                ($code_hex !~ /^\s*$/)) {
		$first_byte = 1;
                foreach $byte (split /\s+/, $code_hex) {
                    $self->{lin_addrspace}->{$address} = [hex($byte),
                                                          $code_entry,
							  $first_byte];
		    $first_byte = 0;
                    $address++;
                }
            }
        }

        #######################
        # paged address space #
        #######################
        if (defined $code_pc_pag) {
            $address = $code_pc_pag;
            if (($code_hex !~ /$CMP_NO_HEXCODE/) &&
                ($code_hex !~ /^\s*$/)) {
		$first_byte = 1;
                foreach $byte (split /\s+/, $code_hex) {
                    $self->{pag_addrspace}->{$address} = [hex($byte),
                                                          $code_entry,
							  $first_byte];
		    $first_byte = 0;
                    $address++;
                }
            }
        }
    }
}

###########
# outputs #
###########
#################
# print_listing #
#################
sub print_listing {
    my $self      = shift @_;

    #code
    my $code_entry;
    my $code_file;
    my $code_line;
    my $code_comments;
    my $code_pc_lin;
    my $code_pc_pag;
    my $code_hex;
    my $code_errors;
    my $code_error;
    my $code_macros;
    my $code_pc_lin_string;
    my $code_pc_pag_string;
    my @code_hex_bytes;
    my @code_hex_strings;
    my $code_hex_string;
    #comments
    my @cmt_lines;
    my $cmt_line;
    my $cmt_last_line;
    #output
    my $out_string;

    ############################
    # initialize output string #
    ############################
    $out_string = "";

    #############
    # code loop #
    #############
    foreach $code_entry (@{$self->{code}}) {

        $code_line     = $code_entry->[0];
        $code_file     = $code_entry->[1];
        $code_comments = $code_entry->[2];
        $code_pc_lin   = $code_entry->[6];
        $code_pc_pag   = $code_entry->[7];
        $code_hex      = $code_entry->[8];
        $code_errors   = $code_entry->[10];
        $code_macros   = $code_entry->[11];

        #convert integers to strings
        if (defined $code_pc_lin) {
            $code_pc_lin_string = sprintf("%.6X", $code_pc_lin);
        } else {
            #$code_pc_lin_string = "??????";
            $code_pc_lin_string = "      ";

        }
        if (defined $code_pc_pag) {
            $code_pc_pag_string = sprintf("%.6X", $code_pc_pag);
        } else {
            $code_pc_pag_string = "??????";
        }

        if (defined $code_hex) {
            for ($code_hex) {
                ##################################
                # whitespaces instead of hexcode #
                ##################################
                /^\s*$/ && do {
                    @code_hex_strings = ("");
                    last;};
                #############################
                # string instead of hexcode #
                #############################
                /$CMP_NO_HEXCODE/ && do {
                    @code_hex_strings = ($1);
                    last;};
                ###########
                # hexcode #
                ###########
                @code_hex_strings = ();
                @code_hex_bytes = split /\s+/, $code_hex;
                while ($#code_hex_bytes >= 0) {
                    $code_hex_string = "";
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    #trim string
                    $code_hex_string =~ s/^\s*//;
                    $code_hex_string =~ s/\s*$//;
                    push @code_hex_strings, $code_hex_string;
                }
            }
	    #printf "\"%s\" \"%s\" (%s)\n", $code_hex, $code_hex_strings[0], $code_comments->[0]
        } else {
            @code_hex_strings = ("??");
        }

        ##################
        # print comments #
        ##################
        @cmt_lines = @$code_comments;
        $cmt_last_line = pop @cmt_lines;
        foreach $cmt_line (@cmt_lines) {
	    if (defined $code_macros) {
		if ($#$code_macros < 0) {
		    $out_string .= sprintf("%-6s %-6s %-23s %ls\n", "", "", "", $cmt_line);
		} else {
		    $out_string .= sprintf("%-6s %-6s %-23s %-80s (%ls)\n", "", "", "", $cmt_line, join("/", reverse @$code_macros));
		}
	    } else {
		$out_string .= sprintf("%-6s %-6s %-23s %ls\n", "", "", "", $cmt_line);
	    }
        }

        ###################
        # print code line #
        ###################
	if (defined $code_macros ) {
	    if ($#$code_macros < 0) {
		$out_string .= sprintf("%-6s %-6s %-23s %ls\n", ($code_pc_pag_string,
								 $code_pc_lin_string,
								 shift @code_hex_strings,
								 $cmt_last_line));
	    } else {
		$out_string .= sprintf("%-6s %-6s %-23s %-80s (%ls)\n", ($code_pc_pag_string,
									 $code_pc_lin_string,
									 shift @code_hex_strings,
									 $cmt_last_line,
				                                         join("/", reverse @$code_macros)));
	    }
	} else {
	    $out_string .= sprintf("%-6s %-6s %-23s %ls\n", ($code_pc_pag_string,
							     $code_pc_lin_string,
							     shift @code_hex_strings,
							     $cmt_last_line));
	} 

        ##############################
        # print additional hex bytes #
        ##############################
        foreach $code_hex_string (@code_hex_strings) {
            $out_string .= sprintf("%-6s %-6s %-23s %ls\n", "", "", $code_hex_string, "");
        }

        ################
        # print errors #
        ################
        foreach $code_error (@$code_errors) {
            $out_string .= sprintf("%-6s %-6s %-23s ERROR! %s (%s, line: %d)\n", ("", "", "",
                                                                                  $code_error,
                                                                                  $$code_file,
                                                                                  $code_line));
        }
    }
    return $out_string;
}

##################
# print_lin_srec #
##################
sub print_lin_srec {
    my $self              = shift @_;
    my $string            = shift @_;
    my $srec_format       = shift @_;
    my $srec_data_length  = shift @_;
    my $srec_add_s5       = shift @_;
    my $srec_alignment    = shift @_;

    #S-records
    my $srec_count;
    my @srec_bytes;
    my $srec_addr;
    #memoryspace
    my $mem_addr;
    my $mem_entry;
    my $mem_byte;
    #output
    my $out_string;

    ############################
    # initialize output string #
    ############################
    $out_string = "";

    ################
    # print header #
    ################
    $out_string .= sprintf("%s", $self->gen_header_srec($string, $srec_data_length));

    ################
    # address loop #
    ################
    $srec_count = 0;
    @srec_bytes = ();
    foreach $mem_addr (sort {$a <=> $b} keys %{$self->{lin_addrspace}}) {
        $mem_entry = $self->{lin_addrspace}->{$mem_addr};
        $mem_byte  = $mem_entry->[0];

        #printf STDERR "address: %X\n", $mem_addr;
        if ($#srec_bytes < 0) {
            ##########################
            # new group of S-records #
            ##########################
            #print STDERR "new S-Record\n";
	    $srec_addr = $mem_addr;
            if ($srec_alignment > 1) {
		#add fill bytes
		while (($srec_addr % $srec_alignment) > 0) {
		    $srec_addr--;
		    push @srec_bytes, $SREC_DEF_FILL_BYTE;
		}
	    }
	    push @srec_bytes, $mem_byte;
        } elsif ($mem_addr == ($srec_addr + $#srec_bytes + 1)) {
            #######################################
            # add data byte to group of S-records #
            #######################################
            #printf STDERR "  => add byte (%X %X)\n", $srec_addr, ($#srec_bytes + 1);
            push @srec_bytes, $mem_byte;
        } elsif (($srec_alignment > 1) &&                               #phrase alignment is enabled
		 ((int($mem_addr/$srec_alignment) ==                    #gap within one phrase
		   int(($srec_addr+$#srec_bytes+1)/$srec_alignment)) ||
		  (int($mem_addr/$srec_alignment) ==                    #gap across two phrases
		   int((($srec_addr+$#srec_bytes+1)/$srec_alignment)+1)))) {
	    #################################################
            # add disjoined data byte to group of S-records #
            #################################################
	    while ($mem_addr > ($srec_addr + $#srec_bytes + 1)) {
		push @srec_bytes, $SREC_DEF_FILL_BYTE;
	    }
	    push @srec_bytes, $mem_byte;
        } else {
            ############################
            # print group of S-records #
            ############################
	    while (($srec_alignment > 1) &&
		   ((($srec_addr+$#srec_bytes+1)%$srec_alignment) > 0)) {
		############################################
                # add fill byte at the end of the S-Record #
                ############################################
                #printf STDERR "  => add ending fill bytes (%X)\n", ($#srec_bytes + 1);
                push @srec_bytes, $SREC_DEF_FILL_BYTE;
	    }
            while ($#srec_bytes >= 0) {
                if (($#srec_bytes + 1) <= $srec_data_length) {
                    $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_addr,
                                                                        \@srec_bytes,
                                                                        $srec_format));
                    @srec_bytes = ();
                } else {
                    $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_addr,
                                                                        [splice(@srec_bytes, 0,
                                                                                $srec_data_length)],
                                                                        $srec_format));
                    $srec_addr = $srec_addr + $srec_data_length;
                }
                $srec_count++;
                if (($srec_add_s5 > 0) &&
                    ($srec_count%$srec_add_s5 == 0)) {
                    $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
                }
            }
            ##########################
            # new group of S-records #
            ##########################
            #print STDERR "next S-Record\n";
  	    $srec_addr = $mem_addr;
            if ($srec_alignment > 1) {
		#add fill bytes
		while (($srec_addr % $srec_alignment) > 0) {
		    $srec_addr--;
		    push @srec_bytes, $SREC_DEF_FILL_BYTE;
		}
	    }
	    push @srec_bytes, $mem_byte;
        }
    }
    #############################
    # print remaining S-records #
    #############################
    while (($srec_alignment > 1) &&
	   ((($srec_addr+$#srec_bytes+1)%$srec_alignment) > 0)) {
	############################################
	# add fill byte at the end of the S-Record #
	############################################
	#printf STDERR "  => add ending fill bytes (%X)\n", ($#srec_bytes + 1);
	push @srec_bytes, $SREC_DEF_FILL_BYTE;
    }
    while ($#srec_bytes >= 0) {
        if (($#srec_bytes + 1) <= $srec_data_length) {
            $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_addr,
                                                                \@srec_bytes,
                                                                $srec_format));
            @srec_bytes = ();
        } else {
            $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_addr,
                                                                [splice(@srec_bytes, 0,
                                                                        $srec_data_length)],
                                                                $srec_format));
            $srec_addr = $srec_addr + $srec_data_length;
        }
        $srec_count++;
        if (($srec_add_s5 > 0) &&
	    ($srec_count%$srec_add_s5 == 0)) {
            $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
        }
    }
    ####################################
    # print S5 for remaining S-records #
    ####################################
    if (($srec_add_s5 > 0) &&
	($srec_count%$srec_add_s5 > 0)) {
        $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
    }

    ################
    # print ending #
    ################
    $out_string .= sprintf("%s\n", $self->gen_end_srec($srec_format));
    return $out_string;
}

##################
# print_pag_srec #
##################
sub print_pag_srec {
    my $self              = shift @_;
    my $string            = shift @_;
    my $srec_format       = shift @_;
    my $srec_data_length  = shift @_;
    my $srec_add_s5       = shift @_;
    my $srec_alignment    = shift @_;

    #S-records
    my $srec_count;
    my @srec_bytes;
    my $srec_addr;
    #memoryspace
    my $mem_addr;
    my $mem_entry;
    my $mem_byte;
    #output
    my $out_string;

    ############################
    # initialize output string #
    ############################
    $out_string = "";

    ################
    # print header #
    ################
    $out_string .= sprintf("%s", $self->gen_header_srec($string, $srec_data_length));

    ################
    # address loop #
    ################
    $srec_count = 0;
    @srec_bytes = ();
    foreach $mem_addr (sort {$a <=> $b} keys %{$self->{pag_addrspace}}) {
        $mem_entry = $self->{pag_addrspace}->{$mem_addr};
        $mem_byte  = $mem_entry->[0];

        #printf STDERR "address: %X\n", $mem_addr;
        if ($#srec_bytes < 0) {
            ##########################
            # new group of S-records #
            ##########################
            #print STDERR "new S-Record\n";
 	    $srec_addr = $mem_addr;
            if ($srec_alignment > 1) {
		#add fill bytes
		while (($srec_addr % $srec_alignment) > 0) {
		    $srec_addr--;
		    push @srec_bytes, $SREC_DEF_FILL_BYTE;
		}
	    }
	    push @srec_bytes, $mem_byte;
        } elsif ($mem_addr == ($srec_addr + $#srec_bytes + 1)) {
            #######################################
            # add data byte to group of S-records #
            #######################################
            #printf STDERR "  => add byte (%X %X)\n", $srec_addr, ($#srec_bytes + 1);
            push @srec_bytes, $mem_byte;
        } elsif (($srec_alignment > 1) &&                               #phrase alignment is enabled
		 ((int($mem_addr/$srec_alignment) ==                    #gap within one phrase
		   int(($srec_addr+$#srec_bytes)/$srec_alignment)) ||
		  (int($mem_addr/$srec_alignment) ==                    #gap across two phrases
		   int((($srec_addr+$#srec_bytes)/$srec_alignment)+1)))) {
	    #################################################
            # add disjoined data byte to group of S-records #
            #################################################
	    while ($mem_addr > ($srec_addr + $#srec_bytes + 1)) {
		push @srec_bytes, $SREC_DEF_FILL_BYTE;
	    }
	    push @srec_bytes, $mem_byte;
        } else {
            ############################
            # print group of S-records #
            ############################
 	    while (($srec_alignment > 1) &&
		   ((($srec_addr+$#srec_bytes+1)%$srec_alignment) > 0)) {
		############################################
                # add fill byte at the end of the S-Record #
                ############################################
                #printf STDERR "  => add ending fill bytes (%X)\n", ($#srec_bytes + 1);
                push @srec_bytes, $SREC_DEF_FILL_BYTE;
	    }
            while ($#srec_bytes >= 0) {
                if (($#srec_bytes + 1) <= $srec_data_length) {
                    $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_addr,
                                                                        \@srec_bytes,
                                                                        $srec_format));
                    @srec_bytes = ();
                } else {
                    $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_addr,
                                                                        [splice(@srec_bytes, 0,
                                                                                $srec_data_length)],
                                                                        $srec_format));
                    $srec_addr = $srec_addr + $srec_data_length;
                }
                $srec_count++;
                if (($srec_add_s5 > 0) &&
                    ($srec_count%$srec_add_s5 == 0)) {
                    $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
                }
            }
            ##########################
            # new group of S-records #
            ##########################
            #print STDERR "next S-Record\n";
  	    $srec_addr = $mem_addr;
            if ($srec_alignment > 1) {
		#add fill bytes
		while (($srec_addr % $srec_alignment) > 0) {
		    $srec_addr--;
		    push @srec_bytes, $SREC_DEF_FILL_BYTE;
		}
	    }
	    push @srec_bytes, $mem_byte;
        }
    }
    #############################
    # print remaining S-records #
    #############################
    while (($srec_alignment > 1) &&
	   ((($srec_addr+$#srec_bytes+1)%$srec_alignment) > 0)) {
	############################################
	# add fill byte at the end of the S-Record #
	############################################
	#printf STDERR "  => add ending fill bytes (%X)\n", ($#srec_bytes + 1);
	push @srec_bytes, $SREC_DEF_FILL_BYTE;
    }
    while ($#srec_bytes >= 0) {
        if (($#srec_bytes + 1) <= $srec_data_length) {
            $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_addr,
                                                                \@srec_bytes,
                                                                $srec_format));
            @srec_bytes = ();
        } else {
            $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_addr,
                                                                [splice(@srec_bytes, 0,
                                                                        $srec_data_length)],
                                                                $srec_format));
            $srec_addr = $srec_addr + $srec_data_length;
        }
        $srec_count++;
        if (($srec_add_s5 > 0) &&
            ($srec_count%$srec_add_s5 == 0)) {
            $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
        }
    }
    ####################################
    # print S5 for remaining S-records #
    ####################################
    if (($srec_add_s5 > 0) &&
        ($srec_count%$srec_add_s5 > 0)) {
        $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
    }

    ################
    # print ending #
    ################
    $out_string .= sprintf("%s\n", $self->gen_end_srec($srec_format));
    return $out_string;
}

###################
# gen_header_srec #
###################
sub gen_header_srec {
    my $self             = shift @_;
    my $string           = shift @_;
    my $srec_data_length = shift @_;

    #data
    my $char;
    #hex codes
    my @hex_string;
    my @hex_line;
    my $hex_code;
    #checksum
    my $sum;
    #S-record
    my $record;

    ########################
    # conver string to hex #
    ########################
    @hex_string = ();
    foreach $char (split //, $string) {
        push @hex_string, ord($char);
    }
    #printf STDERR "hex string length: %s \"%s\"\n", $#hex_string, $string;

    #################
    # hex code loop #
    #################
    while ($#hex_string >= 0) {
        @hex_line = splice @hex_string, 0, $srec_data_length;
        #printf STDERR "srec_data_length: \"%s\"\n", $srec_data_length;
        #printf STDERR "hex line: \"%s\"\n", join("\", \"", @hex_line);
        #printf STDERR "hex line length: %s\n", $#hex_line;

        #####################
        # add address field #
        #####################
        unshift @hex_line, 0;
        unshift @hex_line, 0;

        ####################
        # add length field #
        ####################
        unshift @hex_line, ($#hex_line + 2);

        ######################
        # add checksum field #
        ######################
        $sum = 0;
        foreach $hex_code (@hex_line) {
            $sum = $sum + $hex_code;
        }
        push @hex_line, (0xff - ($sum & 0xff));

        #####################
        # generate S-record #
        #####################
        $record = "S0";
        foreach $hex_code (@hex_line) {
            $record = sprintf("%s%.2X", $record, $hex_code);
        }
        $record = sprintf("%s\n", $record);
    }

    ########################
    # return header string #
    ########################
    return $record;
}

#################
# gen_data_srec #
#################
sub gen_data_srec {
    my $self      = shift @_;
    my $address   = shift @_;
    my $data      = shift @_;
    my $format    = shift @_;

    #hex codes
    my @hex_codes;
    my $hex_code;
    #checksum
    my $sum;
    #S-record
    my $record;

    #######################
    # write address field #
    #######################
    for ($format) {
        /^S3.$/i && do {
            #############
            # S3 record #
            #############
            $record = "S3";
            @hex_codes = ((($address >> 24) & 0xff),
                          (($address >> 16) & 0xff),
                          (($address >>  8) & 0xff),
                          ( $address        & 0xff));
            last;};
        /^S2.$/i && do {
            #############
            # S2 record #
            #############
            $record = "S2";
            @hex_codes = ((($address >> 16) & 0xff),
                          (($address >>  8) & 0xff),
                          ( $address        & 0xff));
            last;};
        /^S1.$/i && do {
            #############
            # S1 record #
            #############
            $record = "S1";
            @hex_codes = ((($address >>  8) & 0xff),
                          ( $address        & 0xff));
            last;};
        ##################
        # invalid format #
        ##################
        return 0;
    }

    ##################
    # add data field #
    ##################
    push @hex_codes, @$data;

    ####################
    # add length field #
    ####################
    unshift @hex_codes, ($#hex_codes + 2);

    ######################
    # add checksum field #
    ######################
    $sum = 0;
    foreach $hex_code (@hex_codes) {
        $sum = $sum + $hex_code;
    }
    push @hex_codes, (0xff - ($sum & 0xff));

    #####################
    # generate S-record #
    #####################
    foreach $hex_code (@hex_codes) {
        $record = sprintf("%s%.2X", $record, $hex_code);
    }

    ########################
    # return header string #
    ########################
    return $record;
}

#############
# gen_s5rec #
#############
sub gen_s5rec {
    my $self      = shift @_;
    my $number    = shift @_;

    #hex codes
    my @hex_codes;
    my $hex_code;
    #checksum
    my $sum;
    #S-record
    my $record;

    #######################
    # write address field #
    #######################
    @hex_codes = ((($number >>  8) & 0xff),
                  ( $number        & 0xff));

    ####################
    # add length field #
    ####################
    unshift @hex_codes, 3;

    ######################
    # add checksum field #
    ######################
    $sum = 0;
    foreach $hex_code (@hex_codes) {
        $sum = $sum + $hex_code;
    }
    push @hex_codes, (0xff - ($sum & 0xff));

    #####################
    # generate S-record #
    #####################
    $record = "S5";
    foreach $hex_code (@hex_codes) {
        $record = sprintf("%s%.2X", $record, $hex_code);
    }

    ########################
    # return header string #
    ########################
    return $record;
}

################
# gen_end_srec #
################
sub gen_end_srec {
    my $self      = shift @_;
    my $format    = shift @_;

    for ($format) {
        /^S.7$/i && do {
            #############
            # S7 record #
            #############
            return "S70500000000FA";
            last;};
        /^S.8$/i && do {
            #############
            # S8 record #
            #############
            return "S804000000FB";
            last;};
        /^S.9$/i && do {
            #############
            # S9 record #
            #############
            return "S9030000FC";
            last;};
        ##################
        # invalid format #
        ##################
        return 0;
    }
}

####################
# print_lin_binary #
####################
sub print_lin_binary {
    my $self              = shift @_;
    my $start_addr        = shift @_;
    my $end_addr          = shift @_;

    #memoryspace
    my $mem_addr;
    my $mem_entry;
    my $mem_byte;
    #output
    my @out_list;

    ##########################
    # initialize output list #
    ##########################
    @out_list = ();

    ################
    # address loop #
    ################
    for ($mem_addr =  $start_addr; 
	 $mem_addr <= $end_addr;
	 $mem_addr++) {

	if (exists $self->{lin_addrspace}->{$mem_addr}) {
	    $mem_entry = $self->{lin_addrspace}->{$mem_addr};
	    $mem_byte  = hex($mem_entry->[0]);
	} else {
	    $mem_byte  = 0;
	}

	push  @out_list, $mem_byte;
	
	return pack "C*", @out_list;   
    }
}

####################
# print_pag_binary #
####################
sub print_pag_binary {
    my $self              = shift @_;
    my $start_addr        = shift @_;
    my $end_addr          = shift @_;

    #memoryspace
    my $mem_addr;
    my $mem_entry;
    my $mem_byte;
    #output
    my @out_list;

    ##########################
    # initialize output list #
    ##########################
    @out_list = ();

    ################
    # address loop #
    ################
    for ($mem_addr =  $start_addr; 
	 $mem_addr <= $end_addr;
	 $mem_addr++) {

	if (exists $self->{pag_addrspace}->{$mem_addr}) {
	    $mem_entry = $self->{pag_addrspace}->{$mem_addr};
	    $mem_byte  = hex($mem_entry->[0]);
	} else {
	    $mem_byte  = 0;
	}

	push  @out_list, $mem_byte;
	
	return pack "C*", @out_list;   
    }
}

#######################
# print_error_summary #
#######################
sub print_error_summary {
    my $self      = shift @_;

    #code
    my $code_entry;
    my $code_file;
    my $code_line;
    my $code_comments;
    my $code_pc_lin;
    my $code_pc_pag;
    my $code_hex;
    my $code_errors;
    my $code_error;
    my $code_macros;
    #comments
    my @cmt_lines;
    my $cmt_last_line;
   #output
   my $out_string;
   my $out_count;

    ############################
    # initialize output string #
    ############################
    $out_string = "";
    $out_count  = 0;

    #############
    # code loop #
    #############
    foreach $code_entry (@{$self->{code}}) {

        $code_line     = $code_entry->[0];
        $code_file     = $code_entry->[1];
        $code_comments = $code_entry->[2];
        $code_pc_lin   = $code_entry->[6];
        $code_pc_pag   = $code_entry->[7];
        $code_hex      = $code_entry->[8];
        $code_errors   = $code_entry->[10];
        $code_macros   = $code_entry->[11];

        ################
        # print errors #
        ################
        foreach $code_error (@$code_errors) {
	    $out_count++;
	    if ($out_count <= 5) {
		#extract source code
		#@cmt_lines = @$code_comments;
		#$cmt_last_line = pop @cmt_lines;
		#print error message
		#$out_string .= sprintf("ERROR! %s (%s, line: %d) -> %s\n", ($code_error,
		#						            $$code_file,
		#						            $code_line,
                #                                                            $cmt_last_line));
		$out_string .= sprintf("ERROR! %s (%s, line: %d)\n", ($code_error,
								      $$code_file,
								      $code_line));
	    } elsif ($out_count == 6) {
		$out_string .= "...\n";
	    } else {
		last;
	    }
        }
    }
    return $out_string;
}

###################
# print_mem_alloc #
###################
sub print_mem_alloc {
    my $self              = shift @_;

    #code entries
    my $code_entry;
    my $code_pc_lin;
    my $code_pc_pag;
    my $code_hex;
    my $code_bytes;
    #allocation tracking
    my $offset;
    my %var_alloc  = ();
    my %code_alloc = ();
    #address parser
    my $cur_pag_addr;
    my $cur_lin_addr;
    my $last_pag_addr;
    my $last_lin_addr;
    #address segments
    my $pag_seg_start;
    my $pag_seg_end;
    my $lin_seg_start;
    my $lin_seg_end;	
    #output
    my $out_string;
    #flag
    my $first_segment;

    #############
    # code loop #
    #############
    foreach $code_entry (@{$self->{code}}) {
        $code_pc_lin   = $code_entry->[6];
        $code_pc_pag   = $code_entry->[7];
        $code_hex      = $code_entry->[8];
        $code_bytes    = $code_entry->[9];
	if (defined $code_bytes) {
	    if ($code_hex !~ /^\s*$/) {
		#code
		foreach $offset (0..($code_bytes-1)) {
		    if (defined $code_pc_lin) {
			$code_alloc{$code_pc_pag+$offset}=$code_pc_lin+$offset;
		    } else {
			$code_alloc{$code_pc_pag+$offset}=undef;
		    }
		    #printf STDERR "code: %X %X\n", $code_pc_pag+$offset, $code_alloc{$code_pc_pag+$offset};
		}
	    } else {
		#variables	
		#printf STDERR "VAR! %X\n", $code_pc_pag;
		foreach $offset (0..($code_bytes-1)) {
		    if (defined $code_pc_lin) {
			$var_alloc{$code_pc_pag+$offset}=$code_pc_lin+$offset;
		    } else {
			$var_alloc{$code_pc_pag+$offset}=undef;
		    }
		    #printf STDERR "var: %X %X %X\n", $code_pc_pag, $code_pc_lin, $offset;
		}
	    }
	}
    }
   #printf STDERR "var hash: %s\n", join(",", keys{%var_alloc});
 
    #############################
    # variable allocation table #
    #############################
    $out_string  = "Variable Allocation:\n";
    $out_string .= "Paged             Linear\n";
    $out_string .= "---------------   ---------------\n";
    $first_segment = 1;
    foreach $cur_pag_addr (sort {$a <=> $b} keys %var_alloc) {
	$cur_lin_addr = $var_alloc{$cur_pag_addr};
	#printf STDERR "VAR: %X %X\n", $cur_pag_addr, $cur_lin_addr;
	if ($first_segment) {
	    $first_segment = 0;
	    $pag_seg_start = $cur_pag_addr;
	    $lin_seg_start = $cur_lin_addr;
	} elsif ((($last_pag_addr+1) != $cur_pag_addr)   ||
		 ((defined  $cur_lin_addr)  &&
		  (defined  $last_lin_addr) &&
		  (($last_lin_addr+1) != $cur_lin_addr)) ||
		 ( (defined  $cur_lin_addr) && !(defined  $last_lin_addr)) ||
		 (!(defined  $cur_lin_addr) &&  (defined  $last_lin_addr))) {
	#} elsif (($last_pag_addr+1) != $cur_pag_addr) {
	    #printf STDERR "NEW: %X %X %X %X\n", $cur_pag_addr, $cur_lin_addr, $last_pag_addr, $last_lin_addr;
	    $pag_seg_end = $last_pag_addr;
	    $lin_seg_end = $last_lin_addr;
	    #print segment boundaries
	    if ((defined $lin_seg_start) && (defined $lin_seg_end)) {
		$out_string .= sprintf("%.6X - %.6X   %.6X - %.6X\n", $pag_seg_start,
				                                      $pag_seg_end,
			             	                              $lin_seg_start,
				                                      $lin_seg_end);
	    } else {
		$out_string .= sprintf("%.6X - %.6X\n", $pag_seg_start,
				                        $pag_seg_end);
	    }
	    #start new segment
	    $pag_seg_start = $cur_pag_addr;
	    $lin_seg_start = $cur_lin_addr;	    
	}
	$last_pag_addr = $cur_pag_addr;
	$last_lin_addr = $cur_lin_addr;
    }
    $pag_seg_end = $last_pag_addr;
    $lin_seg_end = $last_lin_addr;
    #print segment boundaries
    if ((defined $lin_seg_start) && (defined $lin_seg_end)) {
	$out_string .= sprintf("%.6X - %.6X   %.6X - %.6X\n", $pag_seg_start,
			                                      $pag_seg_end,
			                                      $lin_seg_start,
			                                      $lin_seg_end);
    } else {
	$out_string .= sprintf("%.6X - %.6X\n", $pag_seg_start,
			                        $pag_seg_end);
    }
    #print STDERR $out_string;
    #exit;
    #########################
    # code allocation table #
    #########################
    $out_string .= "\n";
    $out_string .= "Code Allocation:\n";
    $out_string .= "Paged             Linear\n";
    $out_string .= "---------------   ---------------\n";
    $first_segment = 1;
    foreach $cur_pag_addr (sort {$a <=> $b} keys %code_alloc) {
	$cur_lin_addr = $code_alloc{$cur_pag_addr};
	#printf STDERR "CODE: %X %X\n", $cur_pag_addr, $cur_lin_addr;
	if ($first_segment) {
	    $first_segment = 0;
	    $pag_seg_start = $cur_pag_addr;
	    $lin_seg_start = $cur_lin_addr;
	} elsif ((($last_pag_addr+1) != $cur_pag_addr)   ||
		 ((defined  $cur_lin_addr)  &&
		  (defined  $last_lin_addr) &&
		  (($last_lin_addr+1) != $cur_lin_addr)) ||
		 ( (defined  $cur_lin_addr) && !(defined  $last_lin_addr)) ||
		 (!(defined  $cur_lin_addr) &&  (defined  $last_lin_addr))) {
	#} elsif (($last_pag_addr+1) != $cur_pag_addr) {
	    $pag_seg_end = $last_pag_addr;
	    $lin_seg_end = $last_lin_addr;
	    #print segment boundaries
	    if ((defined $lin_seg_start) && (defined $lin_seg_end)) {
		$out_string .= sprintf("%.6X - %.6X   %.6X - %.6X\n", $pag_seg_start,
				                                      $pag_seg_end,
			             	                              $lin_seg_start,
				                                      $lin_seg_end);
	    } else {
		$out_string .= sprintf("%.6X - %.6X\n", $pag_seg_start,
				                        $pag_seg_end);
	    }
	    #start new segment
	    $pag_seg_start = $cur_pag_addr;
	    $lin_seg_start = $cur_lin_addr;	    
	}
	$last_pag_addr = $cur_pag_addr;
	$last_lin_addr = $cur_lin_addr;
    }
    $pag_seg_end = $last_pag_addr;
    $lin_seg_end = $last_lin_addr;
    #print segment boundaries
    if ((defined $lin_seg_start) && (defined $lin_seg_end)) {
	$out_string .= sprintf("%.6X - %.6X   %.6X - %.6X\n", $pag_seg_start,
			                                      $pag_seg_end,
			                                      $lin_seg_start,
			                                      $lin_seg_end);
    } else {
	$out_string .= sprintf("%.6X - %.6X\n", $pag_seg_start,
			                        $pag_seg_end);
    }
    return $out_string;
}
   
#########################
# pseudo opcode handler #
#########################
##############
# psop_align #
##############
sub psop_align {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $bit_mask;
    my $bit_mask_res;
    my $fill_byte;
    my $fill_byte_res;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;
    my $count;
    
    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    $code_args =~ s/^\s*//;
    $code_args =~ s/\s*$//;
    for ($code_args) {
        ############
        # bit mask #
        ############
        /$PSOP_1_ARG/ && do {
            $bit_mask        = $1;
            #printf STDERR "ALLIGN: \"%X\"\n", $bit_mask;

            ######################
            # determine bit mask #
            ######################
            ($error, $bit_mask_res) = @{$self->evaluate_expression($bit_mask,
                                                                   $$pc_lin_ref,
                                                                   $$pc_pag_ref,
                                                                   $$loc_cnt_ref,
								   $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } elsif (! defined $bit_mask_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } elsif (! defined $$pc_pag_ref) {
                ######################
                # undefined paged PC #
                ######################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } else {
                ##################
                # valid bit mask #
                ##################
		$count = 0;	
                while ($$pc_pag_ref & $bit_mask_res) {
                    if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                    if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
		    $count++;
                }
                #$code_entry->[6]  = $$pc_lin_ref;
                #$code_entry->[7]  = $$pc_pag_ref;
                $code_entry->[8]  = "";
                $code_entry->[9]  = $count;
                #$$label_value_ref = $$pc_pag_ref;
            }
            last;};
        #######################
        # bit mask, fill byte #
        #######################
        /$PSOP_2_ARGS/ && do {
            $bit_mask  = $1;
            $fill_byte = $2;
            ######################
            # determine bit mask #
            ######################
            ($error, $bit_mask_res) = @{$self->evaluate_expression($bit_mask,
                                                                   $$pc_lin_ref,
                                                                   $$pc_pag_ref,
                                                                   $$loc_cnt_ref,
								   $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $$label_value_ref = undef;
            } elsif (! defined $bit_mask_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $$label_value_ref = undef;
                $$undef_count_ref++;
            } else {
                ##################
                # valid bit mask #
                ##################
                #######################
                # determine fill byte #
                #######################
                ($error, $fill_byte_res) = @{$self->evaluate_expression($fill_byte,
                                                                        $$pc_lin_ref,
                                                                        $$pc_pag_ref,
                                                                        $$loc_cnt_ref,
								        $code_entry->[12])};
                if ($error) {
                    ################
                    # syntax error #
                    ################
                    $code_entry->[10] = [@{$code_entry->[10]}, $error];
                    $$error_count_ref++;
                    return;
                } elsif (! defined $fill_byte_res) {
                    ###################
                    # undefined value #
                    ###################
                    while ($$pc_pag_ref & $bit_mask_res) {
                        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                    }
                    #$$label_value_ref = $$pc_pag_ref;
                    #undefine hexcode
                    $code_entry->[8] = undef;
                    $$undef_count_ref++;
                } else {
                    ###################
                    # valid fill byte #
                    ###################
                    @hex_code = ();
                    while ($$pc_pag_ref & $bit_mask_res) {
                        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                        push @hex_code, sprintf("%.2X", ($fill_byte_res & 0xff));
                    }
                    #set hex code and byte count
                    $code_entry->[8]  = join " ", @hex_code;
                    $code_entry->[9]  = ($#hex_code + 1);
                }
            }
            last;};
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode ALIGN (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref     = undef;
        $$pc_pag_ref     = undef;
        $code_entry->[8] = undef;
    }
}

############
# psop_cpu #
############
sub psop_cpu {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_label;
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_label = $code_entry->[1];
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_1_ARG/) {
        ################
        # one argument #
        ################
        $value = $1;
        #print STDERR "CPU: $value\n";
        $error = $self->set_opcode_table($value);
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } else {
            ##################
            # valid argument #
            ##################
            #check if symbol already exists
            $code_entry->[8]  = sprintf("%s CODE:", $value);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode CPU (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

###########
# psop_db #
###########
sub psop_db {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $code_arg;
    my @code_args_res;
    my $code_args_defined;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];

    #####################
    # resolve arguments #
    #####################
    @code_args_res     = ();
    $code_args_defined = 1;
    foreach $code_arg (split $DEL, $code_args) {
        ($error, $value) = @{$self->evaluate_expression($code_arg,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
            push @code_args_res, 0;
            $code_args_defined = 0;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
            push @code_args_res, 0;
            $code_args_defined = 0;
        } else {
            ##################
            # valid argument #
            ##################
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
            push @code_args_res, sprintf("%.2X", ($value & 0xff));
        }
    }

    #set hex code and byte count
    if ($code_args_defined) {
        $code_entry->[8] = join " ", @code_args_res;
    } else {
        $$undef_count_ref++;
    }
    $code_entry->[9] = ($#code_args_res + 1);
}

###########
# psop_dw #
###########
sub psop_dw {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;


    #arguments
    my $code_args;
    my $code_arg;
    my @code_args_res;
    my $code_args_defined;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];

    #####################
    # resolve arguments #
    #####################
    @code_args_res     = ();
    $code_args_defined = 1;
    foreach $code_arg (split $DEL, $code_args) {
        ($error, $value) = @{$self->evaluate_expression($code_arg,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            if (defined $$pc_lin_ref) {$$pc_lin_ref += 2;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref += 2;}
            push @code_args_res, 0;
            $code_args_defined = 0;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            if (defined $$pc_lin_ref) {$$pc_lin_ref += 2;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref += 2;}
            push @code_args_res, 0;
            $code_args_defined = 0;
        } else {
            ##################
            # valid argument #
            ##################
            if (defined $$pc_lin_ref) {$$pc_lin_ref += 2;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref += 2;}
            push @code_args_res, sprintf("%.2X", (($value >> 8) & 0xff));
            push @code_args_res, sprintf("%.2X", ( $value       & 0xff));
        }
    }

    #set hex code and byte count
    if ($code_args_defined) {
        $code_entry->[8] = join " ", @code_args_res;
    } else {
        $$undef_count_ref++;
    }
    $code_entry->[9] = ($#code_args_res + 1);
}


############
# psop_dsb #
############
sub psop_dsb {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_1_ARG/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } else {
            ##################
            # valid argument #
            ##################
            if (defined $$pc_lin_ref) {$$pc_lin_ref = $$pc_lin_ref + $value;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref = $$pc_pag_ref + $value;}
            $code_entry->[8] = "";
            $code_entry->[9] = $value;	    
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode DS (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
    }
}

############
# psop_dsw #
############
sub psop_dsw {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_1_ARG/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } else {
            ##################
            # valid argument #
            ##################
            if (defined $$pc_lin_ref) {$$pc_lin_ref = $$pc_lin_ref + ($value * 2);}
            if (defined $$pc_pag_ref) {$$pc_pag_ref = $$pc_pag_ref + ($value * 2);}
            $code_entry->[8] = "";
            $code_entry->[9] = ($value * 2);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode DS.W (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
    }
}

##############
# psop_error #
##############
sub psop_error {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $string;
    my $first_char;
    #hex code
    my $char;
    my @hex_code;
    #temporary
    my $error;

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_STRING/) {
        $string = $1;

        #trim string
        $string =~ s/^\s*//;
        $string =~ s/\s*$//;

        #trim first character
        $string     =~ s/^(.)//;
        $first_char = $1;

        #trim send of string
        if ($string =~ /^(.*)$first_char/) {$string = $1;}
        #printf STDERR "fcc: \"%s\" \"%s\"\n", $first_char, $string;

        $error = $string;
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
	
    } else {
        ################
        # syntax error #
        ################
        $error = "intentional compile error";
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

############
# psop_equ #
############
sub psop_equ {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_label;
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_label = $code_entry->[1];
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_1_ARG/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            $$label_value_ref = undef;
            $code_entry->[8]  = sprintf("-> ????", $value);
        } else {
            ##################
            # valid argument #
            ##################
            #check if symbol already exists
            $$label_value_ref = $value;
            $code_entry->[8]  = sprintf("-> \$%.4X", $value);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode EQU (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

############
# psop_fcc #
############
sub psop_fcc {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $string;
    my $first_char;
    #hex code
    my $char;
    my @hex_code;
    #temporary
    my $error;

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_STRING/) {
        $string = $1;

        #trim string
        $string =~ s/^\s*//;
        $string =~ s/\s*$//;

        #trim first character
        $string     =~ s/^(.)//;
        $first_char = $1;

        #trim send of string
        if ($string =~ /^(.*)$first_char/) {$string = $1;}
        #printf STDERR "fcc: \"%s\" \"%s\"\n", $first_char, $string;

        #convert string
        @hex_code = ();
        foreach $char (split //, $string) {
            push @hex_code, sprintf("%.2X", ord($char));
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
        }
        #set hex code and byte count
        $code_entry->[8] = join " ", @hex_code;
        $code_entry->[9] = ($#hex_code + 1);

    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode FCC (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

############
# psop_fcs #
############
sub psop_fcs {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $string;
    my $first_char;
    my $last_char;
    #hex code
    my $char;
    my @hex_code;
    #temporary
    my $error;

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_STRING/) {
        $string = $1;

        #trim string
        $string =~ s/^\s*//;
        $string =~ s/\s*$//;

        #trim first character
        $string     =~ s/^(.)//;
        $first_char = $1;

        #trim send of string
        if ($string =~ /^(.*)$first_char/) {$string = $1;}
        #printf STDERR "fcs: \"%s\" \"%s\"\n", $first_char, $string;

        #trim last character
        $string     =~ s/(.)$//;
        $last_char = $1;
	
        #convert string
        @hex_code = ();
        foreach $char (split //, $string) {
            push @hex_code, sprintf("%.2X", ord($char));
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
        }

        #convert last character
        push @hex_code, sprintf("%.2X", (ord($last_char)|0x80));
        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}

        #set hex code and byte count
        $code_entry->[8] = join " ", @hex_code;
        $code_entry->[9] = ($#hex_code + 1);

    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode FCS (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

############
# psop_fcz #
############
sub psop_fcz {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $string;
    my $first_char;
    #hex code
    my $char;
    my @hex_code;
    #temporary
    my $error;

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_STRING/) {
        $string = $1;

        #trim string
        $string =~ s/^\s*//;
        $string =~ s/\s*$//;

        #trim first character
        $string     =~ s/^(.)//;
        $first_char = $1;

        #trim send of string
        if ($string =~ /^(.*)$first_char/) {$string = $1;}
        #printf STDERR "fcs: \"%s\" \"%s\"\n", $first_char, $string;

        #convert string
        @hex_code = ();
        foreach $char (split //, $string) {
            push @hex_code, sprintf("%.2X", ord($char));
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
        }

        #append zero termination
	push @hex_code, sprintf("%.2X", 0);
	if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
	if (defined $$pc_pag_ref) {$$pc_pag_ref++;}

        #set hex code and byte count
        $code_entry->[8] = join " ", @hex_code;
        $code_entry->[9] = ($#hex_code + 1);

    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode FCZ (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

#############
# psop_fill #
#############
sub psop_fill {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $byte_count;
    my $byte_count_res;
    my $fill_byte;
    my $fill_byte_res;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;
    my $i;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    if ($code_args =~ /$PSOP_2_ARGS/) {
        $fill_byte  = $1;
        $byte_count = $2;

        ########################
        # determine byte count #
        ########################
        ($error, $byte_count_res) = @{$self->evaluate_expression($byte_count,
                                                                 $$pc_lin_ref,
                                                                 $$pc_pag_ref,
                                                                 $$loc_cnt_ref,
						                 $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } elsif (! defined $byte_count_res) {
            ###################
            # undefined value #
            ###################
            $$pc_lin_ref      = undef;
            $$pc_pag_ref      = undef;
            $$label_value_ref = undef;
            $$undef_count_ref++;
        } else {
            ####################
            # valid byte count #
            ####################
            #######################
            # determine fill byte #
            #######################
            ($error, $fill_byte_res) = @{$self->evaluate_expression($fill_byte,
                                                                    $$pc_lin_ref,
                                                                    $$pc_pag_ref,
                                                                    $$loc_cnt_ref,
						                    $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                return;
            } elsif (! defined $fill_byte_res) {
                ###################
                # undefined value #
                ###################
                if (defined $$pc_lin_ref) {$$pc_lin_ref = $$pc_lin_ref + $byte_count_res;}
                if (defined $$pc_pag_ref) {$$pc_pag_ref = $$pc_pag_ref + $byte_count_res;}
                #undefine hexcode
                $code_entry->[8] = undef;
                $$undef_count_ref++;
            } else {
                ###################
                # valid fill byte #
                ###################
                @hex_code = ();
                foreach $i (1..$byte_count_res) {
                    push @hex_code, sprintf("%.2X", ($fill_byte_res & 0xff));
                }
                if (defined $$pc_lin_ref) {$$pc_lin_ref = $$pc_lin_ref + $byte_count_res;}
                if (defined $$pc_pag_ref) {$$pc_pag_ref = $$pc_pag_ref + $byte_count_res;}
                #set hex code and byte count
                $code_entry->[8] = join " ", @hex_code;
                $code_entry->[9] = ($#hex_code + 1);
            }
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode FILL (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
    }
}

###############
# psop_flet16 #
###############
sub psop_flet16 {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $start_addr;
    my $start_addr_res;
    my $end_addr;
    my $end_addr_res;
    my $c0;
    my $c1;

    #temporary
    my $error;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    if ($code_args =~ /$PSOP_2_ARGS/) {
        $start_addr = $1;
        $end_addr   = $2;

	#printf STDERR "RAW: start addr:%s end addr:%s\n", $start_addr, $end_addr;
        ###########################
        # determine start address #
        ###########################
        ($error, $start_addr_res) = @{$self->evaluate_expression($start_addr,
                                                                 $$pc_lin_ref,
                                                                 $$pc_pag_ref,
                                                                 $$loc_cnt_ref,
						                 $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } elsif (! defined $start_addr_res) {
            ###################
            # undefined value #
            ###################
            $$pc_lin_ref      = undef;
            $$pc_pag_ref      = undef;
            $$label_value_ref = undef;
            $$undef_count_ref++;
        } else {
            #######################
            # valid start address #
            #######################
	    #printf STDERR "start addr found: start addr:%X end addr:%s\n", $start_addr_res, $end_addr;
	    #########################
	    # determine end address #
	    #########################
	    ($error, $end_addr_res) = @{$self->evaluate_expression($end_addr,
								   $$pc_lin_ref,
								   $$pc_pag_ref,
								   $$loc_cnt_ref,
								   $code_entry->[12])};
	    if ($error) {
		################
		# syntax error #
		################
		$code_entry->[10] = [@{$code_entry->[10]}, $error];
		$$error_count_ref++;
	    } elsif (! defined $end_addr_res) {
		###################
		# undefined value #
		###################
		$$pc_lin_ref      = undef;
		$$pc_pag_ref      = undef;
		$$label_value_ref = undef;
		$$undef_count_ref++;
	    } else {
		#####################
		# valid end address #
		#####################
		#printf STDERR "end addr found: start addr:%X end addr:%X PC:%X\n", $start_addr_res, $end_addr_res, $$pc_pag_ref;		
		#######################################################################
		# make sure that the current PC is not inside the given address range #
		#######################################################################
		if ((($start_addr_res <= $end_addr_res) && ($$pc_pag_ref >= $start_addr_res) && ($$pc_pag_ref <= $end_addr_res)) ||
		    (($start_addr_res >= $end_addr_res) && ($$pc_pag_ref <= $start_addr_res) && ($$pc_pag_ref >= $end_addr_res))) {
		    $error = sprintf("recursive FLET16 checksum calculation (%s)",$code_args);
		    $code_entry->[10] = [@{$code_entry->[10]}, $error];
		    $$undef_count_ref++;
		    $$pc_lin_ref = undef;
		    $$pc_pag_ref = undef;
		} else {
		    #######################
		    # build address space #
		    #######################
		    my %pag_addrspace = {};
		    foreach my $code_entry (@{$self->{code}}) {
			#my $code_pc_lin   = $code_entry->[6];
			my $code_pc_pag   = $code_entry->[7];
			my $code_hex      = $code_entry->[8];
			if (defined $code_pc_pag) {
			    my $address = $code_pc_pag;
			    if (($code_hex !~ /$CMP_NO_HEXCODE/) &&
				($code_hex !~ /^\s*$/)) {
				foreach my $byte (split /\s+/, $code_hex) {
				    if ((($start_addr_res <= $end_addr_res) && ($address >= $start_addr_res) && ($address <= $end_addr_res)) ||
					(($start_addr_res >= $end_addr_res) && ($address <= $start_addr_res) && ($address >= $end_addr_res))) {
					$pag_addrspace{$address} = hex($byte);
					#printf STDERR "%X: %X (%s)\n", $address, $pag_addrspace{$address}, $byte;		
				    }
				    $address++;	
				}
			    }
			}
		    }
		    ######################
		    # calculate checksum #
		    ######################
		    $c0 = 0;
		    $c1 = 0;		    
		    my $is_undefined = 0;
		    foreach  my $address ($start_addr_res..$end_addr_res) {			
			if (exists $pag_addrspace{$address}) {
			    $c0 += $pag_addrspace{$address};
			    $c0 &= 0xff;
			    $c1 += $c0;
			    $c1 &= 0xff;
			} else {
			    $is_undefined = 1;
			    last;
			}
			#printf STDERR "C1:%X C0:%X\n", $c1, $c0;		
		    }
		    ##################
		    # add code entry #
		    ##################
		    if (defined $$pc_lin_ref) {$$pc_lin_ref = ($$pc_lin_ref + 2);}
		    if (defined $$pc_pag_ref) {$$pc_pag_ref = ($$pc_pag_ref + 2);}
		    $code_entry->[9] = 2;
		    if ($is_undefined) {
			$code_entry->[8] = "?? ??";
			$$undef_count_ref++;
		    } else {
			$code_entry->[8] = sprintf("%.2X %.2X", $c1, $c0);
		    }
		    $code_entry->[9] = 2;
		}		    
	    }
	}
   } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode FLET16 (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
    }
}

############
# psop_loc #
############
sub psop_loc {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    #temporary
    my $error;

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_NO_ARG/) {

        #increment LOC count
        $$loc_cnt_ref++;

        $code_entry->[8]  = sprintf("\"`\" = %.4d", $$loc_cnt_ref);

    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode LOC (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

############
# psop_org #
############
sub psop_org {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $pc_lin;
    my $pc_lin_res;
    my $pc_pag;
    my $pc_pag_res;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    for ($code_args) {
        ############
        # paged pc #
        ############
        /$PSOP_1_ARG/ && do {
            $pc_pag          = $1;
            $code_entry->[8] = "";
            ######################
            # determine paged PC #
            ######################
            ($error, $pc_pag_res) = @{$self->evaluate_expression($pc_pag,
                                                                 $$pc_lin_ref,
                                                                 $$pc_pag_ref,
                                                                 $$loc_cnt_ref,
						                 $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                #print "$error\n";
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
            } elsif (! defined $pc_pag_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } else {
                ##################
                # valid paged pc #
                ##################
                $$pc_pag_ref      = $pc_pag_res;
                $code_entry->[7]  = $pc_pag_res;
                $$label_value_ref = $pc_pag_res;
                #######################
                # determine linear pc #
                #######################
                if ((($pc_pag_res & 0xffff) >= 0x0000) &&
                    (($pc_pag_res & 0xffff) <  0x4000)) {
                    #####################
                    # fixed page => $3D #
                    #####################
                    $$pc_lin_ref      = ((0x3d * 0x4000) + (($pc_pag_res - 0x0000) & 0xffff));
                    $code_entry->[6]  = $$pc_lin_ref;
                } elsif ((($pc_pag_res & 0xffff) >= 0x4000) &&
                         (($pc_pag_res & 0xffff) <  0x8000)) {
                    #####################
                    # fixed page => $3E #
                    #####################
                    $$pc_lin_ref      = ((0x3e * 0x4000) + (($pc_pag_res - 0x4000) & 0xffff));
                    $code_entry->[6]  = $$pc_lin_ref;
                } elsif ((($pc_pag_res & 0xffff) >= 0x8000) &&
                         (($pc_pag_res & 0xffff) <  0xC000)) {
                    #####################
                    # paged memory area #
                    #####################
                    $$pc_lin_ref      = (((($pc_pag_res >> 16) & 0xff) * 0x4000) + (($pc_pag_res - 0x8000) & 0xffff));
                    $code_entry->[6]  = $$pc_lin_ref;
                } else {
                    ####################
                    # fixed page => 3F #
                    ####################
                    $$pc_lin_ref      = ((0x3f * 0x4000) + (($pc_pag_res - 0xc000) & 0xffff));
                    $code_entry->[6]  = $$pc_lin_ref;
                }
            }
            last;};
        #######################
        # paged and linear PC #
        #######################
        /$PSOP_2_ARGS/ && do {
            $pc_pag = $1;
            $pc_lin = $2;
            #printf STDERR "ORG %s ->\n",  $code_args;
            #printf STDERR "ORG %s %s ->\n",  $pc_pag, $pc_lin;
            $code_entry->[8]  = "";
            ######################
            # determine paged PC #
            ######################
            ($error, $pc_pag_res) = @{$self->evaluate_expression($pc_pag,
                                                                 $$pc_lin_ref,
                                                                 $$pc_pag_ref,
                                                                 $$loc_cnt_ref,
						                 $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                #print "$error\n";
                $$pc_pag_ref      = undef;
                $code_entry->[7]  = undef;
            } elsif (! defined $pc_pag_res) {
                ###################
                # undefined value #
                ###################
                $$pc_pag_ref      = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } else {
                ##################
                # valid paged pc #
                ##################
                $$pc_pag_ref      = $pc_pag_res;
                $code_entry->[7]  = $pc_pag_res;
                $$label_value_ref = $pc_pag_res;
            }
            #######################
            # determine linear PC #
            #######################
            if ($pc_lin =~ /$OP_UNMAPPED/) {
                #########################
                # linear pc is unmapped #
                #########################
                $$pc_lin_ref      = undef;
                $code_entry->[6]  = undef;
            } else {
                #######################
                # evaluate expression #
                #######################
                ($error, $pc_lin_res) = @{$self->evaluate_expression($pc_lin,
                                                                     $$pc_lin_ref,
                                                                     $$pc_pag_ref,
                                                                     $$loc_cnt_ref,
						                     $code_entry->[12])};
                if ($error) {
                    ################
                    # syntax error #
                    ################
                    $code_entry->[10] = [@{$code_entry->[10]}, $error];
                    $$error_count_ref++;
                    #print "$error\n";
                    $$pc_lin_ref      = undef;
                    $code_entry->[6]  = undef;
                } elsif (! defined $pc_pag_res) {
                    ###################
                    # undefined value #
                    ###################
                    $$pc_lin_ref      = undef;
                    $code_entry->[6]  = undef;
                } else {
                    ###################
                    # valid linear pc #
                    ###################
                    $$pc_lin_ref      = $pc_lin_res;
                    $code_entry->[6]  = $pc_lin_res;
                }
            }
            #printf STDERR "ORG %X %X\n",  $pc_pag_res, $pc_lin_res;
            last;};
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode ORG (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        #print "$error\n";
        $$error_count_ref++;
        $$pc_lin_ref     = undef;
        $$pc_pag_ref     = undef;
        $code_entry->[6] = undef;
        $code_entry->[7] = undef;
        $code_entry->[8] = undef;
    }
}

##############
# psop_setdp #
##############
sub psop_setdp {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_label;
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_label = $code_entry->[1];
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_1_ARG/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } else {
            ##################
            # valid argument #
            ##################
            #set direct page
            $self->{dir_page} = $value;
            $code_entry->[8]  = sprintf("DIRECT PAGE = \$%2X:", $value);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode CPU (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

################
# psop_unalign #
################
sub psop_unalign {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $bit_mask;
    my $bit_mask_res;
    my $fill_byte;
    my $fill_byte_res;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;
    my $count;
    
    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    for ($code_args) {
        ############
        # bit mask #
        ############
        /$PSOP_1_ARG/ && do {
            $bit_mask         = $1;
            ######################
            # determine bit mask #
            ######################
            ($error, $bit_mask_res) = @{$self->evaluate_expression($bit_mask,
                                                                   $$pc_lin_ref,
                                                                   $$pc_pag_ref,
                                                                   $$loc_cnt_ref,
						                   $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } elsif (! defined $bit_mask_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } elsif (! defined $$pc_pag_ref) {
                ######################
                # undefined paged PC #
                ######################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } else {
                ##################
                # valid bit mask #
                ##################
		$count = 0;
                while (~$$pc_pag_ref & $bit_mask_res) {
                    if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                    if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
		    $count++;
                }
                #$code_entry->[6]  = $$pc_lin_ref;
                #$code_entry->[7]  = $$pc_pag_ref;
                $code_entry->[8]  = "";
                $code_entry->[9]  = $count;
                #$$label_value_ref = $$pc_pag_ref;
            }
            last;};
        #######################
        # bit mask, fill byte #
        #######################
        /$PSOP_2_ARGS/ && do {
            $bit_mask = $1;
            $fill_byte = $2;
            ######################
            # determine bit mask #
            ######################
            ($error, $bit_mask_res) = @{$self->evaluate_expression($bit_mask,
                                                                   $$pc_lin_ref,
                                                                   $$pc_pag_ref,
                                                                   $$loc_cnt_ref,
						                   $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $$label_value_ref = undef;
            } elsif (! defined $bit_mask_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $$label_value_ref = undef;
                $$undef_count_ref++;
            } else {
                ##################
                # valid bit mask #
                ##################
                #######################
                # determine fill byte #
                #######################
                ($error, $fill_byte_res) = @{$self->evaluate_expression($fill_byte,
                                                                        $$pc_lin_ref,
                                                                        $$pc_pag_ref,
                                                                        $$loc_cnt_ref,
						                        $code_entry->[12])};
                if ($error) {
                    ################
                    # syntax error #
                    ################
                    $code_entry->[10] = [@{$code_entry->[10]}, $error];
                    $$error_count_ref++;
                    return;
                } elsif (! defined $fill_byte_res) {
                    ###################
                    # undefined value #
                    ###################
                    while (~$$pc_pag_ref & $bit_mask_res) {
                        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                    }
                    #$$label_value_ref = $$pc_pag_ref;
                    #undefine hexcode
                    $code_entry->[8] = undef;
                    $$undef_count_ref++;
                } else {
                    ###################
                    # valid fill byte #
                    ###################
                    @hex_code = ();
                    while (~$$pc_pag_ref & $bit_mask_res) {
                        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                        push @hex_code, sprintf("%.2X", ($fill_byte_res & 0xff));
                    }
                    #set hex code and byte count
                    $code_entry->[8] = join " ", @hex_code;
                    $code_entry->[9] = ($#hex_code + 1);
                }
            }
            last;};
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode UNALIGN (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
        $code_entry->[8] = undef;
    }
}

############
# psop_zmb #
############
sub psop_zmb {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_label;
    my $code_args;
    #byte count
    my $byte_count;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$PSOP_1_ARG/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            #undefine hexcode
            $$undef_count_ref++;
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } else {
            ##################
            # valid argument #
            ##################
            @hex_code = ();
            foreach $byte_count (1..$value) {
                push @hex_code, "00";
            }
            if (defined $$pc_lin_ref) {$$pc_lin_ref = ($$pc_lin_ref + $value);}
            if (defined $$pc_pag_ref) {$$pc_pag_ref = ($$pc_lin_ref + $value);}
            #set hex code and byte count
            $code_entry->[8] = join " ", @hex_code;
            $code_entry->[9] = ($#hex_code + 1);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode ZMB (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

###############
# psop_ignore #
###############
sub psop_ignore {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    ##################
    # valid argument #
    ##################
    #check if symbol already exists
    $code_entry->[8]  = sprintf("IGNORED!");
}

########################
# address mode ckecker #
########################
#############
# check_inh #
#############
sub check_inh {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;

    $$result_ref = $$hex_ref;
    return 1;
}

##############
# check_imm8 #
##############
sub check_imm8 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###############
# check_imm16 #
###############
sub check_imm16 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#############
# check_dir #
#############
sub check_dir {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_dir(0, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_s12x_dir #
##################
sub check_s12x_dir {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_dir($self->{dir_page}, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#############
# check_ext #
#############
sub check_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

##############
# check_rel8 #
##############
sub check_rel8 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "check_rel8: %s\n", $arg_ref->[0];
    if ($self->get_rel8(2, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_rel8_forced #
#####################
sub check_rel8_forced {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "check_rel8: %s\n", $arg_ref->[0];
    if ($self->get_rel8_forced(2, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_rel8_job #
##################
#sub check_rel8_job {
#    my $self       = shift @_;
#    my $arg_ref    = shift @_;
#    my $pc_lin     = shift @_;
#    my $pc_pag     = shift @_;
#    my $loc_cnt    = shift @_;
#    my $sym_tabs   = shift @_;
#    my $hex_ref    = shift @_;
#    my $error_ref  = shift @_;
#    my $result_ref = shift @_;
#    #temporary
#    my $value;
#
#    #printf STDERR "check_rel8_job: %s\n", $arg_ref->[0];
#    if ($self->get_rel8_job(2, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
#        if (defined $value) {
#            $$result_ref = join(" ", ($$hex_ref, $value));
#        } else {
#            $$result_ref = undef;
#        }
#        return 1;
#    }
#    return 0;
#}

###############
# check_rel16 #
###############
sub check_rel16 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_rel16(4, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#############
# check_idx #
#############
sub check_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "IDX: \"%s\"\n", join("\", \"",
    #                                     $arg_ref->[0],
    #                                     $arg_ref->[1],
    #                                     $arg_ref->[2],
    #                                     $arg_ref->[3]);

    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_idx1 #
##############
sub check_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_idx2 #
##############
sub check_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "check_idx2: \"%s\"\n", join("\", \"", $arg_ref->[0],
    #                                                     $arg_ref->[1]);

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###############
# check_ididx #
###############
sub check_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###############
# check_iidx2 #
###############
sub check_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_iext #
##############
sub check_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $offset;
    my $value;

    $offset = 3 + split(" ", $$hex_ref); 
    #printf "check_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[0],
                        $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_dir_msk #
#################
sub check_dir_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_dir(0, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

######################
# check_s12x_dir_msk #
######################
sub check_s12x_dir_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_dir($self->{dir_page}, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_ext_msk #
#################
sub check_ext_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
    return 1;
}

#################
# check_idx_msk #
#################
sub check_idx_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_idx1_msk #
##################
sub check_idx1_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_idx2_msk #
##################
sub check_idx2_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_dir_msk_rel #
#####################
sub check_dir_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_dir(0, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
       $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
       $self->get_rel8(4, \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
       if ((defined $rel) && (defined $mask) && (defined $address)) {
          $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
       } else {
          $$result_ref = undef;
       }
       return 1;
    }
    return 0;
}

##########################
# check_s12x_dir_msk_rel #
##########################
sub check_s12x_dir_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    #printf STDERR "check_s12x_dir_msk_rel: \"%s\" %X\n", $arg_ref->[0], $dir_pag;
    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_dir($self->{dir_page}, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
        $self->get_rel8(4, \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
        if ((defined $rel) && (defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_ext_msk_rel #
#####################
sub check_ext_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    $self->get_rel8(5, \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    if ((defined $rel) && (defined $mask) && (defined $address)) {
       $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
    } else {
       $$result_ref = undef;
    }
    return 1;
}

#####################
# check_idx_msk_rel #
#####################
sub check_idx_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    $self->get_rel8(4, \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
    $self->get_byte(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
       if ((defined $rel) && (defined $mask) && (defined $address)) {
          $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
       } else {
          $$result_ref = undef;
       }
       return 1;
    }
    return 0;
}

######################
# check_idx1_msk_rel #
######################
sub check_idx1_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    $self->get_rel8(5, \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
       if ((defined $rel) && (defined $mask) && (defined $address)) {
          $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
       } else {
          $$result_ref = undef;
       }
       return 1;
    }
    return 0;
}

######################
# check_idx2_msk_rel #
######################
sub check_idx2_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    $self->get_rel8(6, \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
       if ((defined $rel) && (defined $mask) && (defined $address)) {
          $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
       } else {
          $$result_ref = undef;
       }
       return 1;
    }
    return 0;
}

####################
# check_ext_pgimpl #
####################
sub check_ext_pgimpl {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $address;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    $self->get_ext_pgimpl(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    if (defined $address) {
        $$result_ref = join(" ", ($$hex_ref, $address));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

################
# check_ext_pg #
################
sub check_ext_pg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $page;
    my $address;

    #printf "check_ext_pg: \"%s\", \"%s\"\n", $arg_ref->[0], $arg_ref->[1];
    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$page);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    $$result_ref = join(" ", ($$hex_ref, $address, $page));
    return 1;
}

################
# check_idx_pg #
################
sub check_idx_pg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $page;
    my $address;

    #printf "check_idx_pg: \"%s\", \"%s\", \"%s\", \"%s\", \"%s\"\n", $arg_ref->[0], 
    #                                                                 $arg_ref->[1], 
    #                                                                 $arg_ref->[2], 
    #                                                                 $arg_ref->[3], 
    #                                                                 $arg_ref->[4];
    $self->get_byte(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$page);
    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $page) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $page));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_idx1_pg #
#################
sub check_idx1_pg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $page;
    my $address;

    #printf "check_idx1_pg: \"%s\", \"%s\", \"%s\"\n", $arg_ref->[0], $arg_ref->[1], $arg_ref->[2];
    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$page);
    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $page) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $page));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_idx2_pg #
#################
sub check_idx2_pg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $page;
    my $address;

    #printf "check_idx2_pg: \"%s\", \"%s\", \"%s\"\n", $arg_ref->[0], $arg_ref->[1], $arg_ref->[2];
    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$page);
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $page) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $page));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_imm8_ext #
##################
sub check_imm8_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($arg_ref->[1] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
    if ((defined $data) && (defined $address)) {
        $$result_ref = join(" ", ($$hex_ref, $data, $address));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

##################
# check_imm8_idx #
##################
sub check_imm8_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_imm8_idx1 #
###################
sub check_imm8_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_imm8_idx2 #
###################
sub check_imm8_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm8_ididx #
####################
sub check_imm8_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm8_iidx2 #
####################
sub check_imm8_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_imm8_iext #
###################
sub check_imm8_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_imm8_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[1], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_imm16_ext #
###################
sub check_imm16_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($arg_ref->[1] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
    if ((defined $data) && (defined $address)) {
        $$result_ref = join(" ", ($$hex_ref, $data, $address));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###################
# check_imm16_idx #
###################
sub check_imm16_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm16_idx1 #
####################
sub check_imm16_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm16_idx2 #
####################
sub check_imm16_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_imm16_ididx #
#####################
sub check_imm16_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_imm16_iidx2 #
#####################
sub check_imm16_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm16_iext #
####################
sub check_imm16_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;
    my $offset;

    $offset = 5 + split(" ", $$hex_ref); 
    #printf "check_imm16_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[1], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_ext_ext #
#################
sub check_ext_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($arg_ref->[1] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
    if ((defined $addr0) && (defined $addr1)) {
        $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#################
# check_ext_idx #
#################
sub check_ext_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_idx: \"$arg_ref->[0]\" \"$arg_ref->[1]\" \"$arg_ref->[2]\" \"$arg_ref->[3]\" \"$arg_ref->[4]\"\n";

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_ext_idx1 #
##################
sub check_ext_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_idx1: \"$arg_ref->[0]\" \"$arg_ref->[1]\" \"$arg_ref->[2]\"\n";

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_ext_idx2 #
##################
sub check_ext_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_idx2: \"$arg_ref->[0]\" \"$arg_ref->[1]\" \"$arg_ref->[2]\"\n";

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_ext_ididx #
###################
sub check_ext_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_ididx: \"$arg_ref->[0]\" \"$arg_ref->[1]\"\n";

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_ext_iidx2 #
###################
sub check_ext_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_iidx2: \"$arg_ref->[0]\" \"$arg_ref->[1]\" \"$arg_ref->[2]\"\n";

    if ($arg_ref->[0] =~ $OP_KEYWORDS) {return 0;}
    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_ext_iext #
##################
sub check_ext_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 5 + split(" ", $$hex_ref); 
    #printf "check_ext_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[1], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_idx_ext #
#################
sub check_idx_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[4] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_idx_idx #
#################
sub check_idx_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[4],
                       \$arg_ref->[5],
                       \$arg_ref->[6],
                       \$arg_ref->[7], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

##################
# check_idx_idx1 #
##################
sub check_idx_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[4],
                        \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

##################
# check_idx_idx2 #
##################
sub check_idx_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[4],
                        \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx_ididx #
###################
sub check_idx_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx_iidx2 #
###################
sub check_idx_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    #printf "check_idx_iidx2: %s, %s, %s, %s, %s, %s\n", $arg_ref->[0],
    #                                                    $arg_ref->[1],
    #                                                    $arg_ref->[2],
    #                                                    $arg_ref->[3],
    #                                                    $arg_ref->[4],
    #                                                    $arg_ref->[5];
    if ($self->get_idx2(0xe3,
                        \$arg_ref->[4],
                        \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {

            #printf "check_idx_iidx2 result: \"%s\", \"%s\"\n", (defined $addr0) ? $addr0 : "undefined", 
            #                                                   (defined $addr1) ? $addr1 : "undefined";

            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
        #printf "check_idx_iidx2: fail idx!\n";
    }
    #printf "check_idx_iidx2: fail!\n";
    return 0;
}

##################
# check_idx_iext #
##################
sub check_idx_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_idx_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[4], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {

            #printf "check_idx_iidx2 result: \"%s\", \"%s\"\n", (defined $addr0) ? $addr0 : "undefined", 
            #                                                   (defined $addr1) ? $addr1 : "undefined";

            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
        #printf "check_idx_iidx2: fail idx!\n";
    }
    #printf "check_idx_iidx2: fail!\n";
    return 0;
}

##################
# check_idx1_ext #
##################
sub check_idx1_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[2] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_idx1_idx #
##################
sub check_idx1_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4],
                       \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx1_idx1 #
###################
sub check_idx1_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx1_idx2 #
###################
sub check_idx1_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_idx1_ididx #
####################
sub check_idx1_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_idx1_iidx2 #
####################
sub check_idx1_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx1_iext #
###################
sub check_idx1_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 5 + split(" ", $$hex_ref); 
    #printf "check_idx1_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[2], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

##################
# check_idx2_ext #
##################
sub check_idx2_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    #printf "check_idx2_ext: %s, %s, %s\n", $arg_ref->[0],
    #                                       $arg_ref->[1],
    #                                       $arg_ref->[2];

    if ($arg_ref->[2] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    printf "check_idx2_ext: addr1=%s, addr2=%s\n", $addr1, $addr2;
    return 0;
}

##################
# check_idx2_idx #
##################
sub check_idx2_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4],
                       \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx2_idx1 #
###################
sub check_idx2_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx2_idx2 #
###################
sub check_idx2_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_idx2_ididx #
####################
sub check_idx2_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_idx2_iidx2 #
####################
sub check_idx2_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx2_iext #
###################
sub check_idx2_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 6 + split(" ", $$hex_ref); 
    #printf "check_idx2_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[2], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_ididx_ext #
###################
sub check_ididx_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[1] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_ididx_idx #
###################
sub check_ididx_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_ididx_idx1 #
####################
sub check_ididx_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_ididx_idx2 #
####################
sub check_ididx_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

#####################
# check_ididx_ididx #
#####################
sub check_ididx_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

#####################
# check_ididx_iidx2 #
#####################
sub check_ididx_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_ididx_iext #
####################
sub check_ididx_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_ididx_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[1], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_iidx2_ext #
###################
sub check_iidx2_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[2] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_idx2(0xe3,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_iidx2_idx #
###################
sub check_iidx2_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4],
                       \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_iidx2_idx1 #
####################
sub check_iidx2_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_iidx2_idx2 #
####################
sub check_iidx2_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

#####################
# check_iidx2_ididx #
#####################
sub check_iidx2_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

#####################
# check_iidx2_iidx2 #
#####################
sub check_iidx2_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_iidx2_iext #
####################
sub check_iidx2_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 6 + split(" ", $$hex_ref); 
    #printf "check_iidx2_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[2], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

##################
# check_iext_ext #
##################
sub check_iext_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 5 + split(" ", $$hex_ref); 
    #printf "check_iext_ext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($arg_ref->[1] =~ $OP_KEYWORDS) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_iext_idx #
##################
sub check_iext_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_idx: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

###################
# check_iext_idx1 #
###################
sub check_iext_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_idx1: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

####################
# check_iext_idx2 #
####################
sub check_iext_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_idx1: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

####################
# check_iext_ididx #
####################
sub check_iext_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_idx1: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

####################
# check_iext_iidx2 #
####################
sub check_iext_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_iidx2: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

###################
# check_iext_iext #
###################
sub check_iext_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset0;
    my $offset1;

    $offset0 = 4 + split(" ", $$hex_ref); 
    $offset1 = 6 + split(" ", $$hex_ref); 
    #printf "check_iext_idx1: hex0=%s,  pcpag=%x, dest=%s, offse0t=%d, offset1=%d\n", $$hex_ref, 
    #                                                                                 $pc_pag,
    #                                                                                 $arg_ref->[0],
    #                                                                                 $offset0,
    #                                                                                 $offset1;

    if ($self->get_iext($offset1,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset0,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

#############
# check_exg #
#############
sub check_exg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($TFR_S12,
                       $TFR_EXG,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_s12x_exg #
##################
sub check_s12x_exg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($TFR_S12X,
                       $TFR_EXG,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#############
# check_tfr #
#############
sub check_tfr {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($TFR_S12,
                       $TFR_TFR,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_s12x_tfr #
##################
sub check_s12x_tfr {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($TFR_S12X,
                       $TFR_TFR,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#############
# check_sex #
#############
sub check_sex {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($TFR_S12,
                       $TFR_SEX,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_s12x_sex #
##################
sub check_s12x_sex {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($TFR_S12X,
                       $TFR_SEX,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_dbeq #
##############
sub check_dbeq {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x00,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_dbne #
##############
sub check_dbne {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x20,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_tbeq #
##############
sub check_tbeq {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x40,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_tbne #
##############
sub check_tbne {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x60,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_ibeq #
##############
sub check_ibeq {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x80,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_ibne #
##############
sub check_ibne {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0xa0,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_trap #
##############
sub check_trap {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_trap(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###################
# check_s12x_trap #
###################
sub check_s12x_trap {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_s12x_trap(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###################
# check_hc11_indx #
###################
sub check_hc11_indx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "check_hc11_indx: %s \"%s\"\n", $#$arg_ref, $arg_ref->[0];
    if ($arg_ref->[0] =~ /^\s*$/) {
        $value = "00";
    } else {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    }
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###################
# check_hc11_indy #
###################
sub check_hc11_indy {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($arg_ref->[0] =~ /^\s*$/) {
        $value = "00";
    } else {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    }
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#######################
# check_hc11_indx_msk #
#######################
sub check_hc11_indx_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    if ((defined $mask) && (defined $address)) {
        $$result_ref = join(" ", ($$hex_ref, $address, $mask));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#######################
# check_hc11_indy_msk #
#######################
sub check_hc11_indy_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    if ((defined $mask) && (defined $address)) {
        $$result_ref = join(" ", ($$hex_ref, $address, $mask));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###########################
# check_hc11_indx_msk_rel #
###########################
sub check_hc11_indx_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    if ($self->get_rel8(4, \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel)) {
        $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###########################
# check_hc11_indy_msk_rel #
###########################
sub check_hc11_indy_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    if ($self->get_rel8(5, \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel)) {
        $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
        $self->get_bute(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_xgate_imm3 #
####################
sub check_xgate_imm3 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $hex;

    $self->get_xgate_imm(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    $hex = $$hex_ref;
    $hex =~ s/\s//g;
    $hex = hex($hex);
    if (defined $value) {
        if ($value == ($value & 0x7)) {
            $value = (($value<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            $$error_ref = "invalid semaphore index";
            return 1;
        }
    } else {
        $$result_ref = sprintf("%.1X? %.2X", (($hex>>12) & 0xf), ($hex & 0xff));
        return 1;
    }
}

##########################
# check_xgate_imm3_twice #
##########################
sub check_xgate_imm3_twice {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $hex;

    $self->get_xgate_imm(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    $hex = $$hex_ref;
    $hex =~ s/\s//g;
    $hex = hex($hex);
    if (defined $value) {
        if ($value == ($value & 0x7)) {
            $value = (($value<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X %.2X %.2X", (($value>>8) & 0xff), 
				                           ($value     & 0xff),
                                                          (($value>>8) & 0xff), 
				                           ($value & 0xff));
            return 1;
        } else {
            $$error_ref = "invalid semaphore index";
            return 1;
        }
    } else {
        $$result_ref = sprintf("%.1X? %.2X %.1X? %.2X", (($hex>>12) & 0xf), 
                                                         ($hex      & 0xff),
                                                        (($hex>>12) & 0xf), 
                                                         ($hex & 0xff));
        return 1;
    }
}

####################
# check_xgate_imm4 #
####################
sub check_xgate_imm4 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $reg;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg)) {
        $self->get_xgate_imm(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
        $hex = $$hex_ref;
        $hex =~ s/\s//g;
        $hex = hex($hex);
        if (defined $value) {
            $value = $value & 0xf;
            $value = (($reg<<8) | ($value<<4) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            $value       = (($reg<<8) | $hex);
            $$result_ref = sprintf("%.2X ?%.1X", (($value>>8) & 0xff), ($value & 0x0f));
            return 1;
        }
    }
    return 0;
}

####################
# check_xgate_imm8 #
####################
sub check_xgate_imm8 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $reg;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg)) {
        $self->get_xgate_imm(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
        $hex = $$hex_ref;
        $hex =~ s/\s//g;
        $hex = hex($hex);
        if (defined $value) {
            $value = $value & 0xff;
            $value = (($reg<<8) | $value | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0x0f));
            return 1;
        }
    }
    return 0;
}

#####################
# check_xgate_imm16 #
#####################
sub check_xgate_imm16 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $lvalue;
    my $hvalue;
    my $reg;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg)) {
        $self->get_xgate_imm(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
        $hex = $$hex_ref;
        $hex =~ s/\s//g;
        $hex = hex($hex);
        if (defined $value) {
            $lvalue = $value      & 0xff;
            $hvalue = ($value>>8) & 0xff;
            $value = (($reg<<24) | ($lvalue<<16) | ($reg<<8) | $hvalue | $hex);
            $$result_ref = sprintf("%.2X %.2X %.2X %.2X", ((($value>>24) & 0xff),
                                                           (($value>>16) & 0xff),
                                                           (($value>>8)  & 0xff),
                                                            ($value      & 0xff)));
            return 1;
        } else {
            $$result_ref = sprintf("%.1X? ?? %.1X? ??", ((($hex>>28) & 0xf),
                                                         (($hex>>12) & 0x0f)));
            return 1;
        }
    }
    return 0;
}

###################
# check_xgate_mon #
###################
sub check_xgate_mon {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;
    my $value;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
    }
    return 0;
}

#########################
# check_xgate_mon_twice #
#########################
sub check_xgate_mon_twice {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;
    my $value;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X %.2X %.2X", (($value>>8) & 0xff), 
                                                           ($value     & 0xff),
                                                          (($value>>8) & 0xff), 
                                                           ($value     & 0xff));
            return 1;
    }
    return 0;
}

###################
# check_xgate_dya #
###################
sub check_xgate_dya {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $hex;
    my $value;

    if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | ($reg2<<5) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        }
    }
    return 0;
}

###################
# check_xgate_tri #
###################
sub check_xgate_tri {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $reg3;
    my $hex;
    my $value;

    if ($self->get_xgate_gpr(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg3)) {
        if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
            if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
                $hex = $$hex_ref;
                $hex =~ s/\s//g;
                $hex = hex($hex);
                $value = (($reg1<<8) | ($reg2<<5) | ($reg3<<2) | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            }
        }
    }
    return 0;
}

####################
# check_xgate_rel9 #
####################
sub check_xgate_rel9 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $hex;

    $self->get_xgate_rel(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    $hex = $$hex_ref;
    $hex =~ s/\s//g;
    $hex = hex($hex);
    if (defined $value) {
        if (($value <= 511) && ($value >= -512)) {
            $value = (($value & 0x1ff) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            #$$error_ref = sprintf("branch address is out of range (%d bytes)", $value);
            $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0xf));
            return 1;
        }
    } else {
        $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0xf));
        return 1;
    }
}

#####################
# check_xgate_rel10 #
#####################
sub check_xgate_rel10 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $hex;

    $self->get_xgate_rel(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    $hex = $$hex_ref;
    $hex =~ s/\s//g;
    $hex = hex($hex);
    if (defined $value) {
        if (($value <= 1023) && ($value >= -1024)) {
            $value = (($value & 0x3ff) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            #$$error_ref = sprintf("branch address is out of range (%d bytes)", $value);
            $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0xf));
            return 1;
        }
    } else {
        $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0xf));
        return 1;
    }
}

####################
# check_xgate_ido5 #
####################
sub check_xgate_ido5 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $reg1;
    my $reg2;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $self->get_xgate_imm(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            #printf STDERR "check_xgate_ido5: \"%s\" -> %X\n", $arg_ref->[2], $value;

            if (defined $value) {
                $value = $value & 0x1f;
                $value = (($reg1<<8) | ($reg2<<5) | $value | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            } else {
                $value = (($reg1<<8) | $hex);
                $$result_ref = sprintf("%.2X ??", (($value>>8) & 0xff));
                return 1;
            }
        }
    }
    return 0;
}

###################
# check_xgate_idr #
###################
sub check_xgate_idr {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $reg3;
    my $hex;
    my $value;

    if ($self->get_xgate_gpr(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg3)) {
        if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
            if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
                $hex = $$hex_ref;
                $hex =~ s/\s//g;
                $hex = hex($hex);
                $value = (($reg1<<8) | ($reg2<<5) | ($reg3<<2) | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            }
        }
    }
    return 0;
}

####################
# check_xgate_idri #
####################
sub check_xgate_idri {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $reg3;
    my $hex;
    my $value;

    if ($self->get_xgate_gpr(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg3)) {
        if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
            if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
                $hex = $$hex_ref;
                $hex =~ s/\s//g;
                $hex = hex($hex);
                $value = (($reg1<<8) | ($reg2<<5) | ($reg3<<2) | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            }
        }
    }
    return 0;
}
####################
# check_xgate_idrd #
####################
sub check_xgate_idrd {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $reg3;
    my $hex;
    my $value;

    if ($self->get_xgate_gpr(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg3)) {
        if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
            if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
                $hex = $$hex_ref;
                $hex =~ s/\s//g;
                $hex = hex($hex);
                $value = (($reg1<<8) | ($reg2<<5) | ($reg3<<2) | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            }
        }
    }
    return 0;
}

##########################
# check_xgate_tfr_rd_ccr #
##########################
sub check_xgate_tfr_rd_ccr {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;
    my $value;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
    }
    return 0;
}

##########################
# check_xgate_tfr_ccr_rs #
##########################
sub check_xgate_tfr_ccr_rs {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;
    my $value;

         if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
             $hex = $$hex_ref;
             $hex =~ s/\s//g;
             $hex = hex($hex);
             $value = (($reg1<<8) | $hex);
             $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
             return 1;
    }
    return 0;
}

#########################
# check_xgate_tfr_rd_pc #
#########################
sub check_xgate_tfr_rd_pc {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;
    my $value;

         if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
             $hex = $$hex_ref;
             $hex =~ s/\s//g;
             $hex = hex($hex);
             $value = (($reg1<<8) | $hex);
             $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
             return 1;
    }
    #printf STDERR "check_xgate_tfr_rd_pc failed!\n";
    return 0;
}

#######################
# check_xgate_com_mon #
#######################
sub check_xgate_com_mon {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;
    my $value;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | ($reg1<<2) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
    }
    return 0;
}

#######################
# check_xgate_tst_mon #
#######################
sub check_xgate_tst_mon {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;
    my $value;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<5) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
    }
    return 0;
}

#######################
# check_xgate_com_dya #
#######################
sub check_xgate_com_dya {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $hex;
    my $value;

    if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | ($reg2<<2) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        }
    }
    return 0;
}

#######################
# check_xgate_cmp_dya #
#######################
sub check_xgate_cmp_dya {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $hex;
    my $value;

    if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<5) | ($reg2<<2) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        }
    }
    return 0;
}

############
# get_byte #
############
sub get_byte {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;
    my $eval;

    #printf STDERR "get_byte: \"%s\"\n", $$string_ref;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $$result_ref = sprintf("%.2X", ($value & 0xff));
    } else {
        $$result_ref = "??";
    }
}

############
# get_word #
############
sub get_word {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
    } else {
        $$result_ref = "?? ??";
    }
}

###########
# get_dir #
###########
sub get_dir {
    my $self       = shift @_;
    my $dir_page   = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    #printf STDERR "DIR: %X %X\n", (($value>>8) & 0xff), ($dir_page & 0xff);
    if (defined $value) {
        if ((($value>>8) & 0xff) == ($dir_page & 0xff)) {
            $$result_ref = sprintf("%.2X", ($value & 0xff));
            return 1;
        } else {
            return 0;
        }
    }
    #$$result_ref = "??";
    #return 1;
    return 0;
}

############
# get_rel8 #
############
sub get_rel8 {
    my $self       = shift @_;
    my $offset     = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $reladdr;
    my $value;

    #printf STDERR "get_rel8: %s\n", $$string_ref;
    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
         if (defined $pc_pag) {
             $reladdr = ((int($value & 0xffff) - int($pc_pag & 0xffff)) - $offset);
             if (($reladdr >= -128) && ($reladdr <= 127)) {
                 $$result_ref = sprintf("%.2X", ($reladdr & 0xff));
                 return 1;
             } else {
                 $$result_ref = "??";
                 #return 1;
                 return 0;
             }
         }
     }
    $$result_ref = "??";
    #return 0;
    return 1;
}

###################
# get_rel8_forced #
###################
sub get_rel8_forced {
    my $self       = shift @_;
    my $offset     = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $reladdr;
    my $value;

    #printf STDERR "get_rel8: %s\n", $$string_ref;
    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
         if (defined $pc_pag) {
             $reladdr = ((int($value & 0xffff) - int($pc_pag & 0xffff)) - $offset);
             if (($reladdr >= -128) && ($reladdr <= 127)) {
                 $$result_ref = sprintf("%.2X", ($reladdr & 0xff));
                 return 1;
             } else {
                 $$result_ref = "??";
                 return 1;
                 #return 0;
             }
         }
     }
    $$result_ref = "??";
    #return 0;
    return 1;
}

################
# get_rel8_job #
################
#sub get_rel8_job {
#    my $self       = shift @_;
#    my $offset     = shift @_;
#    my $string_ref = shift @_;
#    my $pc_lin     = shift @_;
#    my $pc_pag     = shift @_;
#    my $loc_cnt    = shift @_;
#    my $sym_tabs   = shift @_;
#    my $error_ref  = shift @_;
#    my $result_ref = shift @_;
#    #temporary
#    my $error;
#    my $reladdr;
#    my $value;
#
#    #printf STDERR "get_rel8_job: %s\n", $$string_ref;
#    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
#    if ($error) {$$error_ref = $error;}
#    if (defined $value) {
#         if (defined $pc_pag) {
#             $reladdr = ((int($value & 0xffff) - int($pc_pag & 0xffff)) - $offset);
#             if (($reladdr >= -128) && ($reladdr <= 127)) {
#                 $$result_ref = sprintf("%.2X", ($reladdr & 0xff));
#                 return 1;
#             } else {
#                 $$result_ref = "??";
#                 #return 1;
#                 return 0;
#             }
#         }
#     }
#    $$result_ref = "??";
#    #return 0;
#    return 1;
#}

#############
# get_rel16 #
#############
sub get_rel16 {
    my $self       = shift @_;
    my $offset     = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $reladdr;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
     if (defined $value) {
        if (defined $pc_pag) {
            $reladdr = ((int($value & 0xffff) - int($pc_pag & 0xffff)) - $offset);
            $$result_ref = sprintf("%.2X %.2X", ((($reladdr >> 8) & 0xff),
                                                 ($reladdr        & 0xff)));
            return 1;
        }
    }
    $$result_ref = "?? ??";
    return 1;
}

###########
# get_idx #
###########
sub get_idx {
    my $self         = shift @_;
    my $offset_ref   = shift @_;
    my $preinc_ref   = shift @_;
    my $reg_ref      = shift @_;
    my $postinc_ref  = shift @_;
    my $pc_lin       = shift @_;
    my $pc_pag       = shift @_;
    my $loc_cnt      = shift @_;
    my $sym_tabs     = shift @_;
    my $error_ref    = shift @_;
    my $result_ref   = shift @_;
    my $indexreg_code = 0x00;
    my $post_byte     = 0x00;
    #temporary
    my $error;
    my $value;

    #printf STDERR "get_idx: \"%s\"\n", join("\", \"",
    #                                          $$offset_ref,
    #                                          $$preinc_ref,
    #                                          $$reg_ref,
    #                                          $$postinc_ref);

    ############################
    # determine index register #
    ############################
    for ($$reg_ref) {
        ###########
        # INDEX X #
        ###########
        /^\s*X\s*$/i && do {
            $indexreg_code = 0x00;
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*Y\s*$/i && do {
            $indexreg_code = 0x01;
            last;};
        ######
        # SP #
        ######
        /^\s*SP\s*$/i && do {
            $indexreg_code = 0x02;
            last;};
        ######
        # PC #
        ######
        /^\s*PC\s*$/i && do {
            if (($$preinc_ref  !~ /^\s*$/) ||
                ($$postinc_ref !~ /^\s*$/)) {
                #illegal address mode
                #$$error_ref = "Illegal auto in/decrement of PC";
                return 0;
            }
            $indexreg_code = 0x03;
            last;};
        ############
        # no match #
        ############
        return 0;
    }

    ####################
    # determine offset #
    ####################
    for ($$offset_ref) {
        ##########
        # ACCU A #
        ##########
        /^\s*A\s*$/i && do {
            if (($$preinc_ref  !~ /^\s*$/) ||
                ($$postinc_ref !~ /^\s*$/)) {
                return 0;
            } else {
                $post_byte = 0xe4 | ($indexreg_code << 3);
                $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                return 1;
            }
            last;};
        ##########
        # ACCU B #
        ##########
        /^\s*B\s*$/i && do {
            if (($$preinc_ref  !~ /^\s*$/) ||
                ($$postinc_ref !~ /^\s*$/)) {
                return 0;
            } else {
                $post_byte   = 0xe5 | ($indexreg_code << 3);
                $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                return 1;
            }
            last;};
        ##########
        # ACCU D #
        ##########
        /^\s*D\s*$/i && do {
            if (($$preinc_ref  !~ /^\s*$/) ||
                ($$postinc_ref !~ /^\s*$/)) {
                return 0;
            } else {
                $post_byte   = 0xe6 | ($indexreg_code << 3);
                $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                return 1;
            }
            last;};

        ###################
        # constant offset #
        ###################
        if ($$offset_ref =~ /^\s*$/) {
            $value = 0;
        } else {
            ($error, $value) = @{$self->evaluate_expression($$offset_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
            if ($error) {$$error_ref = $error;}
        }
        if (defined $value) {
            ###############################
            # determine pre/postincrement #
            ###############################
            if (($$preinc_ref  =~ /^\s*$/) &&
                ($$postinc_ref =~ /^\s*$/)) {
                ###########################
                # no pre or postincrement #
                ###########################
                if (($value >= -16) && ($value <= 15)) {
                    $post_byte   = ($indexreg_code << 6) | ($value & 0x1f);
                    $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                    return 1;
                } else {
                    #offset too big
                    return 0;
                }
            } else {
                ########################
                # pre or postincrement #
                ########################
                if ((($value >= -8) && ($value <= -1)) ||
                    (($value >=  1) && ($value <=  8))) {

                    if (($$preinc_ref  =~ /^\s*\+\s*$/) &&
                        ($$postinc_ref =~ /^\s*$/)) {
                        ################
                        # preincrement #
                        ################
                        if ($value > 0) {
                            $post_byte = (0x20 |
                                          ($indexreg_code << 6) |
                                          (($value - 1) & 0x0f));
                        } else {
                            $post_byte = (0x28 |
                                          ($indexreg_code << 6) |
                                          ($value & 0x0f));
                        }
                        $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                        return 1;
                    } elsif (($$preinc_ref  =~ /^\s*\-\s*$/) &&
                             ($$postinc_ref =~ /^\s*$/)) {
                        ################
                        # predecrement #
                        ################
                        if ($value > 0) {
                            $post_byte = (0x28 |
                                          ($indexreg_code << 6) |
                                          ((-1 * $value) & 0x0f));
                        } else {
                            $post_byte = (0x20 |
                                          ($indexreg_code << 6) |
                                          (((-1 * $value) - 1) & 0x0f));
                        }
                        $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                        return 1;
                    } elsif (($$preinc_ref  =~ /^\s*$/) &&
                             ($$postinc_ref =~ /^\s*\+\s*$/)) {
                        #################
                        # postincrement #
                        #################
                        if ($value > 0) {
                            $post_byte = (0x30 |
                                          ($indexreg_code << 6) |
                                          (($value - 1) & 0x0f));
                        } else {
                            $post_byte = (0x38 |
                                          ($indexreg_code << 6) |
                                          ($value & 0x0f));
                        }
                        $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                        return 1;
                    } elsif (($$preinc_ref  =~ /^\s*$/) &&
                             ($$postinc_ref =~ /^\s*\-\s*$/)) {
                        #################
                        # postdecrement #
                        #################
                        if ($value > 0) {
                            $post_byte = (0x38 |
                                          ($indexreg_code << 6) |
                                          ((-1 * $value) & 0x0f));
                        } else {
                            $post_byte = (0x30 |
                                          ($indexreg_code << 6) |
                                          (((-1 * $value) - 1) & 0x0f));
                        }
                        $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                        return 1;
                    } else {
                        #######################
                        # invalid combination #
                        #######################
                        return 0;
                    }
                } else {
                    #offset too big (or zero)
                    return 0;
                }
            }
        } else {
            return [0, "??"];
        }
    }
}

############
# get_idx1 #
############
sub get_idx1 {
    my $self          = shift @_;
    my $offset_ref    = shift @_;
    my $reg_ref       = shift @_;
    my $pc_lin        = shift @_;
    my $pc_pag        = shift @_;
    my $loc_cnt       = shift @_;
    my $sym_tabs      = shift @_;
    my $error_ref     = shift @_;
    my $result_ref    = shift @_;
    my $indexreg_code = 0x00;
    my $post_byte     = 0x00;
    #temporary
    my $error;
    my $value;

    #printf STDERR "get_idx1: \"%s\"\n", join("\", \"",
    #                                         $$offset_ref,
    #                                         $$reg_ref);

    ################
    # check offset #
    ################
    if ($$offset_ref =~ $OP_KEYWORDS) {
        return 0;
    }

    ############################
    # determine index register #
    ############################
    for ($$reg_ref) {
        ###########
        # INDEX X #
        ###########
        /^\s*X\s*$/i && do {
            $indexreg_code = 0x00;
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*Y\s*$/i && do {
            $indexreg_code = 0x01;
            last;};
        ######
        # SP #
        ######
        /^\s*SP\s*$/i && do {
            $indexreg_code = 0x02;
            last;};
        ######
        # PC #
        ######
        /^\s*PC\s*$/i && do {
            $indexreg_code = 0x03;
            last;};
        ############
        # no match #
        ############
        return 0;
    }

    ####################
    # determine offset #
    ####################
    if ($$offset_ref =~ /^\s*$/) {
        $value = 0;
    } else {
        ($error, $value) = @{$self->evaluate_expression($$offset_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
        if ($error) {$$error_ref = $error;}
    }
    if (defined $value) {
        #print STDERR "value: $value\n";
        if (($value >= -256) && ($value <= 255)) {
            ######################
            # determine hex code #
            ######################
            if ($value >= 0) {
                $post_byte = (0xe0 |
                              ($indexreg_code << 3));
            } else {
                $post_byte = (0xe1 |
                              ($indexreg_code << 3));
            }
            $$result_ref = sprintf("%.2X %.2X", (($post_byte & 0xff),
                                                 ($value & 0xff)));
            return 1;
        } else {
            #offset too big
            return 0;
        }
    } else {
        $$result_ref = "?? ??";
        return 1;
    }
}

############
# get_idx2 #
############
sub get_idx2 {
    my $self           = shift @_;
    my $post_byte_base = shift @_; 
    my $offset_ref     = shift @_;
    my $reg_ref        = shift @_;
    my $pc_lin         = shift @_;
    my $pc_pag         = shift @_;
    my $loc_cnt        = shift @_;
    my $sym_tabs       = shift @_;
    my $error_ref      = shift @_;
    my $result_ref     = shift @_;
    my $indexreg_code  = 0x00;
    my $post_byte      = 0x00;
    #temporary
    my $error;
    my $value;

    #printf STDERR "get_idx2: \"%s\"\n", join("\", \"",
    #                                         $$offset_ref,
    #                                         $$reg_ref);

    ################
    # check offset #
    ################
    if ($$offset_ref =~ $OP_KEYWORDS) {
        return 0;
    }

    ############################
    # determine index register #
    ############################
    for ($$reg_ref) {
        ###########
        # INDEX X #
        ###########
        /^\s*X\s*$/i && do {
            $indexreg_code = 0x00;
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*Y\s*$/i && do {
            $indexreg_code = 0x01;
            last;};
        ######
        # SP #
        ######
        /^\s*SP\s*$/i && do {
            $indexreg_code = 0x02;
            last;};
        ######
        # PC #
        ######
        /^\s*PC\s*$/i && do {
            $indexreg_code = 0x03;
            last;};
        ############
        # no match #
        ############
        return 0;
    }

    ####################
    # determine offset #
    ####################
    if ($$offset_ref =~ /^\s*$/) {
        $value = 0;
    } else {
        ($error, $value) = @{$self->evaluate_expression($$offset_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
        if ($error) {$$error_ref = $error;}
    }
    if (defined $value) {
        #print STDERR "value: $value\n";
        ######################
        # determine hex code #
        ######################
        $post_byte = ($post_byte_base |
                      ($indexreg_code << 3));
        $$result_ref = sprintf("%.2X %.2X %.2X", (($post_byte & 0xff),
                                                 (($value >> 8) & 0xff),
                                                 ($value        & 0xff)));
        return 1;
    } else {
        $$result_ref = "?? ?? ??";
        return 1;
    }
}

#############
# get_ididx #
#############
sub get_ididx {
    my $self           = shift @_;
    my $reg_ref        = shift @_;
    my $pc_lin         = shift @_;
    my $pc_pag         = shift @_;
    my $loc_cnt        = shift @_;
    my $sym_tabs       = shift @_;
    my $error_ref      = shift @_;
    my $result_ref     = shift @_;
    my $indexreg_code  = 0x00;
    my $post_byte      = 0x00;
    #temporary
    my $value;

    ############################
    # determine index register #
    ############################
    for ($$reg_ref) {
        ###########
        # INDEX X #
        ###########
        /^\s*X\s*$/i && do {
            $$result_ref = sprintf("%.2X", 0xe7);
            return 1;
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*Y\s*$/i && do {
            $$result_ref = sprintf("%.2X", 0xef);
            return 1;
            last;};
        ######
        # SP #
        ######
        /^\s*SP\s*$/i && do {
            $$result_ref = sprintf("%.2X", 0xf7);
            return 1;
            last;};
        ######
        # PC #
        ######
        /^\s*PC\s*$/i && do {
            $$result_ref = sprintf("%.2X", 0xff);
            return 1;
            last;};
        ############
        # no match #
        ############
        return 0;
    }
}

############
# get_iext #
############
sub get_iext {
    my $self           = shift @_;
    my $offset         = shift @_;
    my $string_ref     = shift @_;
    my $pc_lin         = shift @_;
    my $pc_pag         = shift @_;
    my $loc_cnt        = shift @_;
    my $sym_tabs       = shift @_;
    my $error_ref      = shift @_;
    my $result_ref     = shift @_;
    my $indexreg_code  = 0x00;
    my $post_byte      = 0x00;
    #temporary
    my $error;
    my $value;

    #printf STDERR "get_iext: \"%s\"\n", $$string_ref;
    ##################
    # check argument #
    ##################
    if ($$string_ref =~ $OP_KEYWORDS) {
        return 0;
    }

    #################################
    # determine destination address #
    #################################
    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}

    if (defined $value) {
        #printf STDERR "value:%x \n", $value;
   
        ##########################
        # subtract offset and PC #
        ##########################
	$value -= $offset;
	$value -= $pc_pag;
	
        ######################
        # determine hex code #
        ######################
        $$result_ref = sprintf("FB %.2X %.2X", ((($value >> 8) & 0xff),
                                                 ($value       & 0xff)));
        return 1;
    } else {
        $$result_ref = "FB ?? ??";
        return 1;
    }
}

##################
# get_ext_pgimpl #
##################
sub get_ext_pgimpl {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $$result_ref = sprintf("%.2X %.2X %.2X", ((($value>>8)    & 0xff),
                                                  ($value         & 0xff),
                                                  (($value >> 16) & 0xff)));
    } else {
        $$result_ref = "?? ?? ??";
    }
}

###########
# get_tfr #
###########
sub get_tfr {
    my $self                = shift @_;
    my $cpu                 = shift @_;
    my $tfr_type            = shift @_;
    my $src_reg_ref         = shift @_;
    my $dst_reg_ref         = shift @_;
    my $pc_lin              = shift @_;
    my $pc_pag              = shift @_;
    my $loc_cnt             = shift @_;
    my $sym_tabs            = shift @_;
    my $error_ref           = shift @_;
    my $result_ref          = shift @_;
    my $extension_byte      = 0;
    my $error               = 0;
    #printf STDERR "S12X TFR: \"%s\" \"%s\"\n", $$src_reg_ref, $$dst_reg_ref;

    ##################
    # extension byte #
    ##################
    for ($tfr_type) {
        ($tfr_type == $TFR_TFR) && do {$extension_byte = 0x00;last;};
        ($tfr_type == $TFR_SEX) && do {$extension_byte = 0x00;last;};
        ($tfr_type == $TFR_EXG) && do {$extension_byte = 0x80;last;};
    }

    ###################
    # source register #
    ###################
    for ($$src_reg_ref) {
        ##########
        # ACCU A #
        ##########
        /^\s*(A)\s*$/i && do {
            for ($$dst_reg_ref) {
                ##########
                # A -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x00;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                ##########
                # A -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x01;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                #################
                # A -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x02;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                #############
                # A -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x03;
                    last;};
                ##########
                # A -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x04;
                    last;};
                ##########
                # A -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x05;
                    last;};
                ##########
                # A -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x06;
                    last;};
                ###########
                # A -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x07;
                    last;};
                #############
                # A -> CCRH #
                #############
                /^\s*(CCRH)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0a;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ##############
                # A -> TMP2H #
                ##############
                /^\s*(TMP2H)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0b;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ###########
                # A -> XH #
                ###########
                /^\s*(XH)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0d;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ###########
                # A -> YH #
                ###########
                /^\s*(YH)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0e;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ############
                # A -> SPH #
                ############
                /^\s*(SPH)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0f;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ############
                # no match #
                ############
                $error   = 1;
            }
            last;};
        ##########
        # ACCU B #
        ##########
        /^\s*(B)\s*$/i && do {
            for ($$dst_reg_ref) {
                ##########
                # B -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x10;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                ##########
                # B -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x11;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                #################
                # B -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x12;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                #############
                # B -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x13;
                    last;};
                ##########
                # B -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x14;
                    last;};
                ##########
                # B -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x15;
                    last;};
                ##########
                # B -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x16;
                    last;};
                ###########
                # B -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x17;
                    last;};
                ##############
                # B -> TMP2L #
                ##############
                /^\s*(TMP2L)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x1b;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ###########
                # B -> XL #
                ###########
                /^\s*(XL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x1d;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ###########
                # B -> YL #
                ###########
                /^\s*(YL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x1e;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ############
                # B -> SPL #
                ############
                /^\s*(SPL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x1f;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ############
                # no match #
                ############
                $error = 1;;
            }
            last;};
        ############
        # CCR,CCRL #
        ############
        /^\s*(CCR|CCRL)\s*$/i && do {
            for ($$dst_reg_ref) {
                #################
                # CCR,CCRL -> A #
                #################
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x20;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                #################
                # CCR,CCRL -> B #
                #################
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x21;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                ########################
                # CCR,CCRL -> CCR,CCRL #
                ########################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x22;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                ####################
                # CCR,CCRL -> TMP2 #
                ####################
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x23;
                    last;};
                #################
                # CCR,CCRL -> D #
                #################
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x24;
                    last;};
                #################
                # CCR,CCRL -> X #
                #################
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x25;
                    last;};
                #################
                # CCR,CCRL -> Y #
                #################
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x26;
                    last;};
                ##################
                # CCR,CCRL -> SP #
                ##################
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x27;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ########
        # CCRH #
        ########
        /^\s*(CCRH)\s*$/i && do {
            if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
            for ($$dst_reg_ref) {
                #############
                # CCRH -> A #
                #############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x28;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ########
        # CCRW #
        ########
        /^\s*(CCRW)\s*$/i && do {
            if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
            for ($$dst_reg_ref) {
                ################
                # CCRW -> CCRW #
                ################
                /^\s*(CCRW)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2a;
                    last;};
                ################
                # CCRW -> TMP2 #
                ################
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2b;
                    last;};
                #############
                # CCRW -> D #
                #############
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2c;
                    last;};
                #############
                # CCRW -> X #
                #############
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2d;
                    last;};
                #############
                # CCRW -> Y #
                #############
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2e;
                    last;};
                ##############
                # CCRW -> SP #
                ##############
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2f;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ########
        # TMP3 #
        ########
        /^\s*(TMP3)\s*$/i && do {
            if ($tfr_type == $TFR_SEX) {$error = 1;}
            for ($$dst_reg_ref) {
                #############
                # TMP3 -> A #
                #############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x30;
                    last;};
                #############
                # TMP3 -> B #
                #############
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x31;
                    last;};
                ####################
                # TMP3 -> CCR,CCRL #
                ####################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x32;
                    last;};
                ################
                # TMP3 -> TMP2 #
                ################
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x33;
                    last;};
                #############
                # TMP3 -> D #
                #############
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x34;
                    last;};
                #############
                # TMP3 -> X #
                #############
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x35;
                    last;};
                #############
                # TMP3 -> Y #
                #############
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x36;
                    last;};
                ##############
                # TMP3 -> SP #
                ##############
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x37;
                    last;};
                ################
                # TMP3 -> CCRW #
                ################
                /^\s*(CCRW)\s*$/i && do {
                    if ($cpu == $TFR_S12) {$error = 1;}
                    $extension_byte = $extension_byte | 0x3A;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #########
        # TMP3L #
        #########
        /^\s*(TMP3L)\s*$/i && do {
            if ($tfr_type == $TFR_SEX) {$error = 1;}
            for ($$dst_reg_ref) {
                ##############
                # TMP3L -> A #
                ##############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x30;
                    last;};
                ##############
                # TMP3L -> B #
                ##############
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x31;
                    last;};
                ####################
                # TMP3 -> CCR,CCRL #
                ####################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x32;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #########
        # TMP3H #
        #########
        /^\s*(TMP3H)\s*$/i && do {
            if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
            for ($$dst_reg_ref) {
                #############
                # CCRH -> A #
                #############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x38;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ########
        # TMP1 #
        ########
        /^\s*(TMP1)\s*$/i && do {
            if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
            for ($$dst_reg_ref) {
                #############
                # CCRH -> D #
                #############
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x3C;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ##########
        # ACCU D #
        ##########
        /^\s*(D)\s*$/i && do {
            for ($$dst_reg_ref) {
                ##########
                # D -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x40;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                ##########
                # D -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x41;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                #################
                # D -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x42;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                #############
                # D -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x43;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                ##########
                # D -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x44;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                ##########
                # D -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x45;
                    last;};
                ##########
                # D -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x46;
                    last;};
                ###########
                # D -> SP #
                ###########
                # D -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x47;
                    if ($tfr_type == $TFR_SEX) {$error = 1;}
                    last;};
                #############
                # D -> CCRW #
                #############
                /^\s*(CCRW)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x4a;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                #############
                # D -> TMP1 #
                #############
                /^\s*(TMP1)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x4b;
                    if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
                    last;};
                ############
                # no match #
                ############
                $error   = 1;
            }
            last;};
        ###########
        # INDEX X #
        ###########
        /^\s*(X)\s*$/i && do {
            if ($tfr_type == $TFR_SEX) {$error = 1;}
            for ($$dst_reg_ref) {
                ##########
                # X -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x50;
                    last;};
                ##########
                # X -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x51;
                    last;};
                #################
                # X -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x52;
                    last;};
                #############
                # X -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x53;
                    last;};
                ##########
                # X -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x54;
                    last;};
                ##########
                # X -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x55;
                    last;};
                ##########
                # X -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x56;
                    last;};
                ###########
                # X -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x57;
                    last;};
                #############
                # X -> CCRW #
                #############
                /^\s*(CCRW)\s*$/i && do {
                    if ($cpu == $TFR_S12) {$error = 1;}
                    $extension_byte = $extension_byte | 0x5A;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # INDEX XL #
        ############
        /^\s*(XL)\s*$/i && do {
            if ($tfr_type == $TFR_SEX) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # XL -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x50;
                    last;};
                ###########
                # XL -> B #
                ###########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x51;
                    last;};
                ##################
                # XL -> CCR,CCRL #
                ##################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x52;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # INDEX XH #
        ############
        /^\s*(XH)\s*$/i && do {
            if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # XH -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x58;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*(Y)\s*$/i && do {
            if ($tfr_type == $TFR_SEX) {$error = 1;}
            for ($$dst_reg_ref) {
                ##########
                # Y -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x60;
                    last;};
                ##########
                # Y -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x61;
                    last;};
                #################
                # Y -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x62;
                    last;};
                #############
                # Y -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x63;
                    last;};
                ##########
                # Y -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x64;
                    last;};
                ##########
                # Y -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x65;
                    last;};
                ##########
                # Y -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x66;
                    last;};
                ###########
                # Y -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x67;
                    last;};
                #############
                # Y -> CCRW #
                #############
                /^\s*(CCRW)\s*$/i && do {
                    if ($cpu == $TFR_S12) {$error = 1;}
                    $extension_byte = $extension_byte | 0x6A;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # INDEX YL #
        ############
        /^\s*(YL)\s*$/i && do {
            if ($tfr_type == $TFR_SEX) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # YL -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x60;
                    last;};
                ###########
                # YL -> B #
                ###########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x61;
                    last;};
                ##################
                # YL -> CCR,CCRL #
                ##################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x62;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # INDEX YH #
        ############
        /^\s*(YH)\s*$/i && do {
            if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # YH -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x68;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #################
        # STACK POINTER #
        #################
        /^\s*(SP)\s*$/i && do {
            if ($tfr_type == $TFR_SEX) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # SP -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x70;
                    last;};
                ###########
                # SP -> B #
                ###########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x71;
                    last;};
                ##################
                # SP -> CCR,CCRL #
                ##################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x72;
                    last;};
                ##############
                # SP -> TMP2 #
                ##############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x73;
                    last;};
                ###########
                # SP -> D #
                ###########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x74;
                    last;};
                ###########
                # SP -> X #
                ###########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x75;
                    last;};
                ###########
                # SP -> Y #
                ###########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x76;
                    last;};
                ############
                # SP -> SP #
                ############
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x77;
                    last;};
                ##############
                # SP -> CCRW #
                ##############
                /^\s*(CCRW)\s*$/i && do {
                    if ($cpu == $TFR_S12) {$error = 1;}
                    $extension_byte = $extension_byte | 0x7A;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #######
        # SPL #
        #######
        /^\s*(SPL)\s*$/i && do {
            if ($tfr_type == $TFR_SEX) {$error = 1;}
            for ($$dst_reg_ref) {
                ############
                # SPL -> A #
                ############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x70;
                    last;};
                ############
                # SPL -> B #
                ############
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x71;
                    last;};
                ###################
                # SPL -> CCR,CCRL #
                ###################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x72;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #######
        # SPH #
        #######
        /^\s*(SPH)\s*$/i && do {
            if (($cpu == $TFR_S12) || ($tfr_type == $TFR_SEX)) {$error = 1;}
            for ($$dst_reg_ref) {
                ############
                # SPH -> A #
                ############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x78;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # no match #
        ############
        $error = 1;
    }
    $$result_ref = sprintf("%.2X", $extension_byte);
    if ($error) {
        $$error_ref = sprintf("invalid register transfer \"%s -> %s\"", uc($$src_reg_ref), uc($$dst_reg_ref));
    }
    return 1;
}

############
# get_dbeq #
############
sub get_dbeq {
    my $self           = shift @_;
    my $post_byte_base = shift @_;
    my $reg_ref        = shift @_;
    my $addr_ref       = shift @_;
    my $pc_lin         = shift @_;
    my $pc_pag         = shift @_;
    my $loc_cnt        = shift @_;
    my $sym_tabs       = shift @_;
    my $error_ref      = shift @_;
    my $result_ref     = shift @_;
    my $post_byte = $post_byte_base;
    #temporary
    my $error;
    my $value;
    my $rel_addr;

    ###################
    # resolve address #
    ###################
    ($error, $value) = @{$self->evaluate_expression($$addr_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        if (defined $pc_pag) {
            #printf STDERR "expression:   \"%s\"\n", $$addr_ref;
            #printf STDERR "pc_pag:   \"%X\" \"%s\"\n", $pc_pag, $pc_pag;
            #printf STDERR "value:    \"%X\" \"%s\"\n", $value,  $value;
            $rel_addr = int($value & 0xffff)  - int($pc_pag & 0xffff) - 3;
            #printf STDERR "rel_addr: \"%X\" \"%s\"\n", $rel_addr, $rel_addr;

	    ####################
	    # resolve register #
	    ####################
	    for ($$reg_ref) {
		##########
		# ACCU A #
		##########
		/^\s*A\s*$/i && do {
		    $post_byte = $post_byte | 0x00;
		    last;};
		##########
		# ACCU B #
		##########
		/^\s*B\s*$/i && do {
		    $post_byte = $post_byte | 0x01;
		    last;};
		##########
		# ACCU D #
		##########
		/^\s*D\s*$/i && do {
		    $post_byte = $post_byte | 0x04;
		    last;};
		###########
		# INDEX X #
		###########
		/^\s*X\s*$/i && do {
		    $post_byte = $post_byte | 0x05;
		    last;};
		###########
		# INDEX Y #
		###########
		/^\s*Y\s*$/i && do {
		    $post_byte = $post_byte | 0x06;
		    last;};
		######
		# SP #
		######
		/^\s*SP\s*$/i && do {
		    $post_byte = $post_byte | 0x07;
		    last;};
		############
		# no match #
		############
		return 0;
	    }

	    ###################
	    # return hex code #
	    ###################
            if (($rel_addr >= -256) && ($rel_addr <= 255)) {
                if ($rel_addr < 0) {
                    $post_byte = $post_byte | 0x10;
                }

                $$result_ref = sprintf("%.2X %.2X", (($post_byte & 0xff),
                                                     ($rel_addr & 0xff)));
                return 1;
            } else {
                $$result_ref = sprintf("%.2X ??", ($post_byte & 0xff));
                #return 0;
                return 1;
            }
        } else {
            $$result_ref = "?? ??";
            return 1;
        }
    } else {
        $$result_ref = "?? ??";
        return 1;
    }
}

############
# get_trap #
############
sub get_trap {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $value = $value & 0xff;
        if ((($value >= 0x30) && ($value <= 0x39)) ||
            (($value >= 0x40) && ($value <= 0xff))) {
            $$result_ref = sprintf("%.2X", $value);
            return 1;
        } else {
            $$error_ref = sprintf("illegal trap number \$%.2X", $value);
            $$result_ref = "??";
            return 1;
        }
    } else {
        $$result_ref = "??";
        return 1;
    }
}

#################
# get_s12x_trap #
#################
sub get_s12x_trap {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $value = $value & 0xff;
        if ((($value >= 0x30) && ($value <= 0x34)) ||
            (($value >= 0x49) && ($value <= 0x4f)) ||
             ($value == 0x59)                      ||
             ($value == 0x81)                      ||
             ($value == 0x86)                      ||
             ($value == 0x91)                      ||
             ($value == 0xa1)                      ||
             ($value == 0xa7)                      ||
             ($value == 0xb1)                      ||
             ($value == 0xb7)                      ||
             ($value == 0xc1)                      ||
             ($value == 0xc6)                      ||
            (($value >= 0xcc) && ($value <= 0xcf)) ||
             ($value == 0xd1)                      ||
             ($value == 0xe1)                      ||
             ($value == 0xf1)) {
            $$result_ref = sprintf("%.2X", $value);
            return 1;
        } else {
            $$error_ref = sprintf("illegal trap number \$%.2X", $value);
            $$result_ref = "??";
            return 1;
        }
    } else {
        $$result_ref = "??";
        return 1;
    }
}

#################
# get_xgate_imm #
#################
sub get_xgate_imm {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;

    ($$error_ref, $$result_ref) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    return 1;
}

#################
# get_xgate_gpr #
#################
sub get_xgate_gpr {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;

    ####################
    # resolve register #
    ####################
    if ($$string_ref =~ /\s*R([0-7])\s*$/i) {
        $$result_ref = $1 & 0x07;
        return 1;
    }
    return 0;
}

#################
# get_xgate_rel #
#################
sub get_xgate_rel {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if (defined $pc_pag) {
        ($$error_ref, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
        if (defined $value) {
            $$result_ref = ((int($value & 0xffff) - (int($pc_pag & 0xffff) +2)) /2);
        } else {
            $$result_ref = undef;
        }
    } else {
            $$result_ref = undef;
    }
    return 1;
}
