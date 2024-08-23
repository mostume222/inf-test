use strict;
use warnings;

open(my $fasta, "<", $ARGV[0]);

while(<$fasta>) {
	chomp($_);
	if ($_ =~ ">") {
		print $_."\t";
	} else {
		print length($_)."\n";
	}
}
