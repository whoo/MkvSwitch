#!/usr/bin/perl 
#####
# licence into README 

use strict;

my $mkvfile= $ARGV[0];
my %tb;
my %dtb;

### Test file
if ( ! -e $mkvfile ) 
{ print " \033[91m>> No such file\033[0m\n"; exit(2); }

# open Forcage pour avoir la LANG par defaut
open(FILE, "LANG=C mkvinfo '".$mkvfile."' |");

# Recuperation des informations Track audio avec le compteur de track reelle
my $real;
my $idx;
while (<FILE>)
{
	$a=$_;
	chomp($a);
	$idx= $b if ($b)=($a=~/Track number: ([0-9])/); 
	if ($a=~/Track type: /) { $real++; }
	if (($b)=($a=~/Track type: (audio)/)) { $tb{$real}=$idx; }
}

#### Check track ###
my @key = sort keys(%tb);
if (@key < 2) 
{
print "  \033[94mlol, WTF ".@key." Track \033[00m \n";
exit (3);
}

###### ROR on Table ######## Ugly :)
# %tb = { 2=>"2", 3=>"3", 4 =>"4"}
# @key =  2 3 4
# $dtb{ 2 } = $tb{ $key[1] } // $tb{3} = 3 
# $dtb{ 3 } = $tb{ $key[2] } // $tb{4} = 4
# $dtb{ 4 } = $tb{ $key[0] } // $tb{2} = 2
# %tb = { 2=>"3", 3=>"4", 4 =>"2"}
my $b=0;
foreach $a (@key)
{
$b=($b+1)%@key;
$dtb{$a}=$tb{$key[$b]};
}


#### Finalize command 
my $out= "mkvpropedit  \"".$mkvfile."\" ";
foreach  my $v (sort keys (%dtb))
{ $out.= " --edit track:".$v." --set track-number=".$dtb{$v}; }

##### Print / Exec command ####
print "Cmd: \033[92m$out\033[0m\n";

if ( -w $mkvfile)
{ system "$out"; }
else { print " \033[91m>> Not writeable\033[0m\n"; }


