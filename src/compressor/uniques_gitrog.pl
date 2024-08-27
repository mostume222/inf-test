use strict;
use warnings;
use feature 'say';

my $folder = $ARGV[0];
my $kmer_l = $ARGV[1];
my $jump = $ARGV[2];
open(my $unique, "<", $folder."unique.list"); #was unique.list now is resul
open(my $end_point, ">", $folder."unique.positions");
open(my $cluster_size, "<", $folder."cluster_size");
open(my $taxid_num, "<", $folder."taxids_hash.dmp");
### it will be neded to add a file with the information 
### of the taxid, to give them each one a header of their terminal nodes 
### it its unique, then give them the terminal node they belong to 
#	#if the cluster has more than 1 sequence, have the taxid of the group
#	#if the cluster has jsut 1 sequnce, have the terminal node of the terminal node
my $genome;
my $kmer;
my @unit;

## this is the gitrog function
### open the coors file 
open(my $coorsfh, "<", $folder."hash.coors");
my %coors;
while(<$coorsfh>) {
	chomp($_);	
	my @line = split(":", $_);	
	$coors{$line[0]} = $line[1];	
}
print("finish hashing the coors file");


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


$counter = 0;
my %hash_taxid;
while(my $ring = <$taxid_num>) {
	chomp($ring);
	@line = split(">", $ring);
	my $num = $line[0];	
	my $tax = $line[1];
	$hash_taxid{$num} = $tax;
	$counter ++;	
}
print("finished hashing the taxids of each genome".$counter."\n");

### get the taxid of the gruoup
my $taxid_group = $folder;
$taxid_group =~ s/\..*//s; #remove .metalf
$taxid_group =~ s/.*\///; #stay jsut with the taxid
$taxid_group = "dis";
####

my $it = 0;
my $current_genome;
my $current_kmer;
my $current_kmer_depth;
my $kmer_depth; #this is next kmer
my $initial_kmer;
my $add_register = 0;

my $consec_enter = 0; #out of consecutiveness
my $elements_in_concatenation = 0; #this counts the representatives
my $elements_in_cluster = 0; #this counts the total count of elements in each cluster concated

#flag to know the lasts gnome kmer condition
#	if it is part of new
#	if it is part of the same as the last one
my $last_stringed = 0;
my $taxid;

while (<$unique>) {
#	say "enter the cicle:";
	chomp $_;
	#say $_;
	@unit = split("_",$_);
	$genome = $unit[0]; #genome is actually the next genome
	$taxid = $hash_taxid{$genome};
	## in the last one the genome will met with genome
	$kmer = $unit[1];
	
	#set up the current depth
	
###### uncomment this modification
	#if($hash_cluster_size{$genome."_".$kmer} > 1) {
	#	$kmer_depth = 2; #this means type 2, which stands for more than 1
	#} else {
	#	$kmer_depth = 1; #this means that this kmer is unique, so should only be concatenated with unique stuff
	#}
###### uncomment this modification
	$kmer_depth = $coors{$genome."_".$kmer};
###### comment the modficiation avobe


	#	print("current genome kmer ".$genome." ".$kmer."\n");

	if ($it == 0) {
		$current_genome = $genome;	
		$current_kmer = $kmer;
		$initial_kmer = $kmer;
	
		##add the initial counting 
		$elements_in_concatenation = 1; 
		$elements_in_cluster = $hash_cluster_size{$current_genome."_".$current_kmer}; 
	
		##set up the number of elements in the first kmer
		$current_kmer_depth = $kmer_depth;
		#we are only going to merge if the next kmer has the same type of deph
		# 1 or > 1, this will let us dont concatenate segmentes that are really unique
		# into clusters of consecutive representatives 


	} else { # for the rest of the lines

		
		#las siguientes son las condiciones de no consecutividad
		#o de cambio de genoma
		#que terminan en insertar un registro 
		if ($current_genome != $genome or 
			abs($kmer - $current_kmer) > 1 or 
			$kmer_depth ne $current_kmer_depth ) {
			#this means go out consecutiveness
			#as this conditions are for out of consecutiveness

			#print this line in and enfline, to actually extract the sequences
			#also, we need to remove this unique clusters from the clusters list 
			#say "bive: ".$current_genome."_".$initial_kmer." ".$current_kmer;;	
			
			
			## determine the positions infile
			my $init_pos = $initial_kmer*$jump;
			## this is actually the lenght of the region
			## somehow called end_pos
			my $end_pos = (($current_kmer-$initial_kmer)*$jump) + $kmer_l;
			#		say "to  : ".$current_genome." ".$init_pos." ".$end_pos;

			#define the correct taxid depending on the number of elements in the cluster 
######### uncomment thi modification
			#if ($current_kmer_depth > 1) { $taxid = $taxid_group; }
######### comment this modification
			if ($current_kmer_depth eq "dispensable") { $taxid = $taxid_group; }


			## print in the report of the last kmer and genome 
			print $end_point $current_genome.",".$initial_kmer."-".$current_kmer.",".$init_pos.",".$end_pos.",".
					$elements_in_concatenation.",".$elements_in_cluster.",".$taxid."\n";

			#set up for new register use the kmer line
			#now this kmer becomes the current kmer 
			$current_genome = $genome;		
			$current_kmer = $kmer;
			$initial_kmer = $kmer;
			$elements_in_concatenation = 1; 
			$elements_in_cluster = $hash_cluster_size{$current_genome."_".$current_kmer}; 
	
			#set up kmer depth for the new_current kmer
############ unomment this modification
			#if($hash_cluster_size{$current_genome."_".$current_kmer} > 1) {
			#	$current_kmer_depth = 2; #this means type 2, which stands for more than 1
			#} else {
			#	$current_kmer_depth = 1; #this means that this kmer is unique, so should only be concatenated with unique stuff
			#}
########### uncomment this modification
			## comment this modification
			$current_kmer_depth = $coors{$current_genome."_".$current_kmer};



		} else {
			#this means enter consecutiveness
			#and also mean continuing of consectuviness
			$current_kmer = $kmer; #lets go to the next kmer
			#set up the kmer depth of the current one
			$elements_in_concatenation ++; ## ad 1 more to the counter
			$elements_in_cluster += $hash_cluster_size{$current_genome."_".$current_kmer};
			
			#set up the cntinuing kmer depth
######## uncomment this modification
		#	if($hash_cluster_size{$current_genome."_".$current_kmer} > 1) {
		#		$current_kmer_depth = 2; #this means type 2, which stands for more than 1
		#	} else {
		#		$current_kmer_depth = 1; #this means that this kmer is unique, so should only be concatenated with unique stuff
		#	}

			$current_kmer_depth = $coors{$current_genome."_".$current_kmer};

		}
	}	
	
	
	$it = $it + 1;	
}

### now add the last lline
### this serves for both cases
### when its part of the string, it finished the record and prints it
### when is not part, it print the new record 
$taxid = $hash_taxid{$current_genome};
#define the correct taxid depending on the number of elements in the cluster 
if ($current_kmer_depth eq "dispensable") { $taxid = $taxid_group; }
#say "bive: ".$current_genome."_".$initial_kmer." ".$current_kmer;;
			my $init_pos = $initial_kmer*$jump;
			my $end_pos = (($current_kmer-$initial_kmer)*$jump) + $kmer_l;
			#			say "to  : ".$current_genome." ".$init_pos." ".$end_pos;
			print $end_point $current_genome.",".$initial_kmer."-".$current_kmer.",".$init_pos.",".$end_pos.",".
					$elements_in_concatenation.",".$elements_in_cluster.",".$taxid."\n";
print($taxid_group."\n");
### the last kmer in the unique.list file 
print("gitrog fed\n");
