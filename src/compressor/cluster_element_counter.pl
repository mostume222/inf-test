use strict;
use warnings;
use feature 'say';

open(my $cdhit, "<", $ARGV[0]);
open(my $output, ">", $ARGV[1]);

my $counter = 0;
my @line;
my %hash_kmers_line;
my @kmers_order;
while(my $sev = <$cdhit>) {
	chomp($sev);
	@line = split("\\:", $sev);	
	my $count = $line[0];
	@line = split(">", $sev);
	my $kmer = $line[1];
	$kmer =~ s/\..*//s; #remove everything after the point 
	#print($kmer." ".$count."\n"); #print one line with the result 
	$hash_kmers_line{$kmer} = $count;
	push @kmers_order, $kmer; 
		
	$counter ++;
}
print("finish hashing the cdhit output".$counter."\n");
print(" lenght of the order array ".scalar(@kmers_order)."\n");


## walking the list of kmers_order
my $in=0;
for my $var (@kmers_order) {
	my $current_kmer = $kmers_order[$in];
	my $next_kmer = $kmers_order[$in+1];
	$next_kmer //= 0; #if the next_kmer is 0, then is the last kmer of the cdhit report 

	## obtain the number of lines;
	my $current_line = $hash_kmers_line{$current_kmer};

	my $next_line = $current_line+2; #default value is itself	
	if(exists $hash_kmers_line{$next_kmer}) {
		$next_line = $hash_kmers_line{$next_kmer};
	}

	my $num_elements = $next_line - ($current_line+1);

	#print($current_kmer." ".$next_kmer."\n");
	#print("\t".$current_line." ".$next_line."\n");
	#print("\t".$num_elements."\n");
	print $output $current_kmer." ".$num_elements."\n";
	$in ++;	
}
print("finished walking the kmers_order ".$in."\n");



