use strict;
use warnings;
open(my $acc, "<", $ARGV[0]);
open(my $coor, "<", $ARGV[1]);
open(my $output, ">", $ARGV[1]."s");
open(my $variants_fh, "<", $ARGV[2]);

my %accs;
while(<$acc>){
	chomp($_);
	my @line = split(">", $_);	
	$accs{$line[0]} = $line[1];
}
print("finished accessions and number\n");

my %variants;
my %segments;
while(<$variants_fh>){
    chomp($_);
    my @line = split(",", $_);
    $variants{$line[0]} = $line[1]; ## this is two in the experiment that has segments
	#$segments{$line[0]} = $line[1];  ## this is one in the all experiment because the file is diferent
}

print("finished accessions and variants\n");

print($variants{"MG779875"}."\n");


my $counter = 0;
#while(0){
my $lotus = "";
my $inf_a = 0;
my $inf_b = 0;
my $elements = 0;
my $uniq = 1;
my $leader_taxid;
my $count_same = 0;
my $count_diff = 0;
my $count_count=0;
while(<$coor>){
	chomp($_);
	$_ =~ tr/ //d;
	my @line = split("_", $_);


	## elements != 0 will jump the first blank line 
	#if(index ($_, '*') != -1 and $elements != 0) {
	if(index ($_, '*') != -1 and $count_count !=0) {


		## modify the unqiue variable by the percent of same sequences 
		if($elements != 0){ 
			my $percent_unique = $count_same/$elements;
			if ($percent_unique < 0.95) { $uniq = 0; }
			else { $uniq = 1; }

			if ($uniq == 0) {
				print $output "dispensable:".$elements;
			}
			if ($uniq == 1) {
				print $output $leader_taxid.":".$elements;
			}
		
			print $output ":".$count_same/$elements;

			# start new row
			# this just prints new line 
			print $output "\n";	
		} else { #this is if elements == 0, which means that the cluster is only the representative
				## we have to manually print the percent 0
			print $output $leader_taxid.":".$elements.":0"."\n";
		}
	}

	#print $output $accs{$line[0]}."_".$line[1];
	
	# to print accession numbers
	if(index ($_, '*') != -1) {
		my @kmer = split(/\*/, $line[1]);
		my $kmer = $kmer[0];
		print $output $accs{$line[0]}."_".$kmer.":".$line[0]."_".$kmer.":";	
		$leader_taxid = $variants{$accs{$line[0]}};

		#$elements = $elements + 1;
	} else {
		#print $output $accs{$line[0]}." ".$variants{$accs{$line[0]}}." "; #print accessions in this format
		### annotate the taxid that appear in the list
		$elements = $elements + 1;
		$lotus = $variants{$accs{$line[0]}}; 
		### evaluate the leader 
		if($lotus ne $leader_taxid) { $uniq = 0; }
		if($lotus ne $leader_taxid) { $count_diff = $count_diff + 1; }
		if($lotus eq $leader_taxid) { $count_same = $count_same + 1; }


	
	}
	# to print accession numbers

	if(index ($_, '*') != -1) {
		## this code should be up i think 
		## because is the same condition
		## reset the labels
		$inf_b = 0;
		$inf_a = 0;
		$uniq = 1;
		$elements = 0;
		$count_diff = 0;
		$count_same = 0;
		$leader_taxid = $variants{$accs{$line[0]}};
		print $output $leader_taxid.":";	
	}
	
	
	$count_count = 1;
}
#### print the last line 
		## evaluate the uniq 
if ($uniq == 0) {
		print $output "dispensable:".$elements;
}
if ($uniq == 1) {
	print $output $leader_taxid.":".$elements.":0";
}


print("finished making coors file\n");
