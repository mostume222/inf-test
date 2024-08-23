use strict;
use warnings;
use feature 'say';

my $folder = $ARGV[0];
my $kmer_l = $ARGV[1];
my $jump = $ARGV[2];
open(my $unique, "<", $folder."unique.list"); #was unique.list now is resul
open(my $end_point, ">", $folder."unique.positions");
open(my $cluster_size, "<", $folder."cluster_size");
### it will be neded to add a file with the information 
### of the taxid, to give them each one a header of their terminal nodes 
### it its unique, then give them the terminal node they belong to 
#	#if the cluster has more than 1 sequence, have the taxid of the group
#	#if the cluster has jsut 1 sequnce, have the terminal node of the terminal node
my $genome;
my $kmer;
my @unit;

#my @onehits = <$unique>;
#my $onehits = scalar @onehits;
my $counter = 0;
my @line;
my %hash_cluster_size;
while(my $sev = <$cluster_size>) {
	chomp($sev);	
	@line = split(" ",$sev);	
	my $kamer = $line[0];
	my $cout = $line[1];
	$hash_cluster_size{$kamer} = $cout;
	$counter ++;
}
print("finish hashing the cluste sizes".$counter."\n");


my $it = 0;
my $current_genome;
my $current_kmer;
my $initial_kmer;
my $add_register = 0;

my $consec_enter = 0; #out of consecutiveness
my $elements_in_concatenation = 0; #this counts the representatives
my $elements_in_cluster = 0; #this counts the total count of elements in each cluster concated

while (<$unique>) {
#	say "enter the cicle:";
	chomp $_;
	#say $_;
	@unit = split("_",$_);
	$genome = $unit[0]; #genome is actually the next genome
	## in the last one the genome will met with genome
	$kmer = $unit[1];
#	say $it;
#	say $genome." ".$kmer;

	if ($it == 0) {
		$current_genome = $genome;	
		$current_kmer = $kmer;
		$initial_kmer = $kmer;
	
		##add the initial counting 
		$elements_in_concatenation = 1; 
		$elements_in_cluster = $hash_cluster_size{$current_genome."_".$current_kmer}; 



	} else { # for the rest of the lines

		
		#las siguientes son las condiciones de no consecutividad
		#o de cambio de genoma
		#que terminan en insertar un registro 
		if ($current_genome != $genome or 
			abs($kmer - $current_kmer) > 1) {
			#this means go out consecutiveness
			#as this conditions are for out of consecutiveness

			#print this line in and enfline, to actually extract the sequences
			#also, we need to remove this unique clusters from the clusters list 
			say "bive: ".$current_genome."_".$initial_kmer." ".$current_kmer;;	
			
			
			## determine the positions infile
			my $init_pos = $initial_kmer*$jump;
			my $end_pos = (($current_kmer-$initial_kmer)*$jump) + $kmer_l;
			say "to  : ".$current_genome." ".$init_pos." ".$end_pos;

			## print in the report of the last kmer and genome 
			print $end_point $current_genome.",".$init_pos.",".$end_pos.",".
					$elements_in_concatenation.",".$elements_in_cluster."\n";

			#set up for new register use the kmer line
			#now this kmer becomes the current kmer 
			$current_genome = $genome;		
			$current_kmer = $kmer;
			$initial_kmer = $kmer;
			$elements_in_concatenation = 1; 
			$elements_in_cluster = $hash_cluster_size{$current_genome."_".$current_kmer}; 



		} else {
			#this means enter consecutiveness
			#and also mean continuing of consectuviness
			$current_kmer = $kmer; #lets go to the next kmer
			$elements_in_concatenation ++; ## ad 1 more to the counter
			$elements_in_cluster += $hash_cluster_size{$current_genome."_".$current_kmer};
		}
	}	
	
	
	$it = $it + 1;	
}

###processs the last line 

say "bive: ".$current_genome." ".$initial_kmer." ".$current_kmer;

if ($current_genome != $genome or abs($kmer - $current_kmer) > 1) {
##if ($current_genome != $genome) {
	## this means another region
	my $init_pos = $initial_kmer*$jump;
	my $end_pos = (($initial_kmer)*$jump) + $kmer_l; # its an alone fragment
	say "to : ".$current_genome." ".$init_pos." ".$end_pos."\n";

	$elements_in_concatenation = 1; 
	$elements_in_cluster = $hash_cluster_size{$current_genome."_".$current_kmer}; 

	print $end_point $current_genome.",".$init_pos.",".$end_pos.",".
				$elements_in_concatenation.",".$elements_in_cluster."\n";

} else {
#	#### here we sill need the condition of consecutiveness
	my $init_pos = $initial_kmer*$jump;
	my $end_pos = (($current_kmer-$initial_kmer)*$jump) + $kmer_l;
	say "to  : ".$current_genome." ".$init_pos." ".$end_pos."\n";
#
	$elements_in_concatenation ++; ## ad 1 more to the counter
	$elements_in_cluster += $hash_cluster_size{$current_genome."_".$current_kmer};

	print $end_point $current_genome.",".$init_pos.",".$end_pos.",".
			$elements_in_concatenation.",".$elements_in_cluster."\n";
}
