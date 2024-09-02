use strict;
use warnings;

open(my $fasta, "<", $ARGV[0]);
open(my $classes, "<", $ARGV[1]);
open(my $names, "<", $ARGV[2]);
open(my $output_fasta, ">", $ARGV[3]);
open(my $output_names, ">", $ARGV[4]);
open(my $output_classes, ">", $ARGV[5]);

## run this script by 
## perl merge.pl sequences.fasta classes.dmp names.dmp output.fasta acc_variants.list sci_names.dmp


## make the hash and also print
## the correct output for the classes file
my %hash_classes;
while(<$classes>) {
	chomp($_);
	my @line = split("\t", $_);
	#	print $line[0]." ".$line[1]."\n";
	$hash_classes{$line[0]} = $line[1];
	print $output_classes $line[0].",".$line[1]."\n";
}

## make the correct output for sci names file 
while(<$names>) {
	chomp($_);
	my @line = split("\t",$_);
	print $output_names $line[0].">".$line[1]."\n";
}


#while(<$fasta>) {
while(0) { 
	chomp($_);
	if ($_ =~ />/) {
		my @line = split(">", $_);
		print $output_fasta ">".$line[1].">".$hash_classes{$line[1]}.">"."100"."\n";
	} else {
		#print("sequence"."\n");
		print $output_fasta $_."\n";
	}
}
