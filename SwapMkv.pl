#!/usr/bin/perl
#####
# licence into README

my $mkvfile= $ARGV[0];
my $real=0;


if ( ! -e $mkvfile ) 
	{
	print "error no such file\n";
	exit(2);
	}


open(FILE, "LANG=C mkvinfo '".$mkvfile."' |");

my %tb;
my %dtb;

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
###### ROR on Table ########
foreach $a (@key)
{
$dtb{$a}=$tb{$key[($b+1)%@key]};
$b=$b+1;
}

#### Finalize command 
my $out= "mkvpropedit -v \"".$ARGV[0]."\" ";
foreach $v (sort keys (%dtb))
{
$out.= " --edit track:".$v." --set track-number=".$dtb{$v};
}
##### Exec command ####
print "$out\n";
system "$out";
