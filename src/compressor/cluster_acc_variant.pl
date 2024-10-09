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

my %variants;
while(<$variants_fh>){
    chomp($_);
    my @line = split(",", $_);
    $variants{$line[0]} = $line[1];
}


my $counter = 0;
my $member_taxid;
my $leader_taxid;
my $leader_accession;
my $cluster_status;
my $counter_in = 0;
my $elements = 0;
while(<$coor>){
	chomp($_);
	$_ =~ tr/ //d;
	my @line = split("_", $_);

	## this condition works weird as it 
	## prints the information at the beggining of the next cluster
	## so the last cluster does not print 
	if(index ($_, '*') != -1) {
		## this would work if i put a * in the last round and a condition of EOF
		#print $output "\n";	
		if( $counter_in > 0) {
			print $output $leader_accession." ".$leader_taxid." ".$cluster_status." ".$elements."\n";
			$elements = 0;
		}
	}

	#print $output $accs{$line[0]}."_".$line[1];
	if(index ($_, '*') != -1) {
		# member of the cluster
		$leader_accession =  $accs{$line[0]}."_".$line[1];
		$leader_taxid = $variants{$accs{$line[0]}};
		$cluster_status = 1;
	} else {
		# leader of the cluster
		$member_taxid = $variants{$accs{$line[0]}};
		$elements = $elements + 1;
		
		if( $member_taxid ne $leader_taxid ) {	
			$cluster_status = 0;	
		}
	}
	

	#if(index ($_, '*') != -1) {
	#} else {
	#	print $output " ";
	#}
	$counter_in = $counter_in + 1;
	
}
