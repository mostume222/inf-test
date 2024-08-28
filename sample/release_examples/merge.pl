use strict;
use warnings;

open(my $fasta, "<", $ARGV[0]);
open(my $classes, "<", $ARGV[1]);

my %hash_classes;
while(<$classes>) {
	chomp($_);
	my @line = split("\t", $_);
	#	print $line[0]." ".$line[1]."\n";
	$hash_classes{$line[0]} = $line[1];
}

while(<$fasta>) {
	chomp($_);
	if ($_ =~ />/) {
		my @line = split(">", $_);
		print($line[1]." ".$hash_classes{$line[1]."\n");
	} else {
		#print("sequence"."\n");
	}
}
