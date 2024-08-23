use strict;
use warnings;
use feature 'say';
use Data::Dumper;

## this script is to make the fasta file of the unique sequences 
## and put them in uniques.part

my $folder = $ARGV[0];

open(my $ram, "<", $folder."database.fasta");
open(my $un, "<", $folder."unique.positions");
open(my $obj, ">", $folder."database.compressed");

# we could delete the registers from this
my %sequences; 
my $seq;

my $counter = 0;
while(<$ram>) {
	chomp($_);	
	my @line = split(">", $_);	
	$seq = <$ram>;
	chomp($seq);
	$sequences{$line[1]} = $seq;
	$counter ++;
}
print("finishing the hashing of the databases".$counter."\n");


#say Dumper(\%sequences);

while(<$un>) {
#while(0){
	chomp($_);
	my @line = split(",",$_);	
	my $genome = $line[0];
	my $init = $line[2];
	my $end = $line[3];
	$seq = $sequences{$genome};
	chomp($seq);
	#say join(",",@line);
	my $sequence = substr($seq, $init, $end); 
	#say $sequence;	
	print $obj ">".join("_",@line)."\n".$sequence."\n";
}

say "end of the concatenation script";



