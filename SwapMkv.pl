#!/usr/bin/perl
#####
# licence into README

my $mkvfile= $ARGV[0];
my $real=0;
my $cmd="ok";

if ( ! -e $mkvfile ) 
	{
	print " \033[91m>> No such file\033[0m\n";
	exit(2);
	}

# Forcage pour avoir la LANG par defaut
open(FILE, "LANG=C mkvinfo '".$mkvfile."' |");

my %tb;
my %dtb;

# Recuperation des informations Track audio avec le compteur de track reelle
while (<FILE>)
{
	$a=$_;
	chomp($a);
	$idx= $b if ($b)=($a=~/Track number: ([0-9])/); 
	if ($a=~/Track type: /) { $real++; }
	if (($b)=($a=~/Track type: (audio)/)) { $tb{$real}=$idx; }
}



my @key = sort keys(%tb);
my $b=0;
###### ROR on Table ######## Ugly :)
# %tb = { 2=>"2", 3=>"3", 4 =>"4"}
# @key =  2 3 4
# $dtb{ 2 } = $tb{ $key[1] } // $tb{3} = 3 
# $dtb{ 3 } = $tb{ $key[2] } // $tb{4} = 4
# $dtb{ 4 } = $tb{ $key[0] } // $tb{2} = 2
# %tb = { 2=>"3", 3=>"4", 4 =>"2"}
foreach $a (@key)
{
$b=($b+1)%@key;
$dtb{$a}=$tb{$key[$b]};
}



#### Finalize command 
my $out= "mkvpropedit -v \"".$mkvfile."\" ";
foreach $v (sort keys (%dtb))
{
$out.= " --edit track:".$v." --set track-number=".$dtb{$v};
}
##### Exec command ####
print "Cmd: \033[92m$out\033[0m\n";

if (-w $mkfile)
{
system "$out"; 
}
else {
print " \033[91m>> Not writeable\033[0m\n";
}


