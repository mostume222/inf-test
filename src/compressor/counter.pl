use strict;
use warnings;
use feature 'say';

open(my $file, "<", $ARGV[0]); 
my $line;
my $len = 0;
my $sum = 0;

while (<$file>) {
	$line = $_;	
	chomp($line);
	if ($_ =~ />/) {

	} else {
		$len = length($line);		
		$sum = $sum + $len;
		#say $len;
	}
}

say  $sum;
