use strict;
use warnings;
use feature "say";

#### recuerda de poner en dos decimales
### los resultados de porcentajes en el cigar

my $filename = $ARGV[2];
my $output_fasta = $ARGV[3].".fasta";
my $output_fastq = $ARGV[3].".fastq";

open(my $fh, "<", $filename );
open(my $fasta, ">", $output_fasta);
#open(my $fastq, ">", $output_fastq);

# this function just results a pattern
sub kmerize {
	my $inf =  $_[0];
	my $sup =  $_[1];
	my $kmer = substr $_[2], $inf, $sup;	
	return $kmer;
}

my $k = $ARGV[0];
my $s = $ARGV[1];
my $current_genome = 0;
my $next_genome = 0;

my $quality = "I";

### while loop to make the quality string 
my $ut = 2;

#dumb making of the quality string i just dont know how to do it xd 
while() {
	#say "quality cicle", $ut;
	$quality = $quality."I";	
	if ($ut == $k ) { last; } 
	$ut = $ut + 1;
}

#dumb making of the quality string i just dont know how to do it xd 

#while loop of the file 
#this cicle will end when it encounters the last
#line of the file
while (<$fh>) {
	if ($_ =~ /^>/) {
		$current_genome = $next_genome;
		$next_genome = $current_genome + 1;	
	} else {
		chomp($_);
		my $seq_len = length $_;
		my $max_kmer = int((($seq_len - $k) / $s)+1);

		#this is the cicle to making the kmers
		for (my $it = 0; $it < $max_kmer; $it = $it + 1) {
			my $start = $it * $s;
			my $kmer = kmerize( $start, $k, $_); 
			chomp $kmer;
			print $fasta (">".$current_genome."_".$it."\n",
					$kmer."\n");
#			print $fastq ("@".$current_genome."_".$it."\n".
#					$kmer."\n".
#					$quality."\n"."+\n");

		}
	}
}

#### make the command to delete the Ns using cut adapt 
#### dont forget to check the iformation in todo 88




#			print $wr ("@".$current_genome."_".$it."\n".
#					$kmer."\n".
#					$quality."\n".
#					"+\n"); 
