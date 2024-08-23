use strict;
use warnings;

#this script is to enumerate but also put
#the acession number to each kmer 

open(my $fasta, "<", $ARGV[0]); #fasta file to numerate
open(my $output, ">", $ARGV[1]); #nuemrated fasta file to write

my $counter = 0;
my @line;
while(my $sev = <$fasta>) {
	#get the header
	chomp($sev);
	my $header = $sev;

	#get the sequence 
	$sev = <$fasta>;
	chomp($sev);
	my $seq = $sev;

	#print in the new file
	print $output ">".$counter.$header."\n".$seq."\n";

	$counter = $counter + 1;

}

