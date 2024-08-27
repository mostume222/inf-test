use strict;
use warnings;
use feature 'say';

## i think this can be done once for all as is not super expsencive proces i belive 

open(my $acce,"<", $ARGV[0]); # list of accessions 
open(my $compressed, "<", $ARGV[1]);
open(my $pangenome, ">", $ARGV[2]);
open(my $variants_fh,"<",$ARGV[4]);
open(my $names_fh,"<",$ARGV[5]);
my $segment = $ARGV[6];
my $spe = $ARGV[3];

## obtain the segment
my @a = split(",", $segment);
#my @b = split("_", $a[0]);
my $segu = $a[0];
print "segment >>>".$segment."\n";

## hash accession numbers
my $counter = 0;
my %acc_hash;
while(<$acce>) {
	chomp($_);
	my @line = split(">", $_);
	my $id = $line[0];
	my $acc = $line[1];
	$acc_hash{$id} = $acc;
	$counter = $counter + 1;
}
## hash names
my %names;
while(<$names_fh>) {
    chomp($_);
    my @line = split('>', $_);
    my $taxid = $line[1];
    $taxid =~ s/ /_/g;
    $names{$line[0]} = $taxid;
}

## hash variats
my %variants;
while(<$variants_fh>){
    chomp($_);
    my @line = split(",", $_);
    $variants{$line[0]} = $line[1];
}

$counter = 0;
my $acc;
my $seq;
while(<$compressed>) {
	chomp($_);

	if ($_ =~ />/) {
		## this is header
		my @line = split(">", $_);
		my $row = $line[1];
		@line = split("_",$row);
		my $acc_id = $line[0];
		my $kmers = $line[1];
		my $dep = "d";
		my $node = $line[6];
		if($line[4]-$line[5] == 0){
			$dep = "u";
		}
		## set up the new dispensable form 
		## might not be compatible with other implementations of this script 
     	if (index($_, "dis") != -1) {
            $dep = "d";
        } else {
            $dep = "u";
        }	
			
		@line = split("-", $kmers);
		my $init = ($line[0]*50)+1;
		my $end = ($line[1]*50) + 200;

		my $kmer_id = $line[1];
		my $kmer_profile = $line[0]."-".$line[1];

		#print($acc."\n");
		my $accode = $acc_hash{$acc_id};
		#print $pangenome $_."\n";
		#print $pangenome ">".$acc_hash{$acc_id}."/".$init."/".$end."/".$node."/".$spe."/".$dep."/".$variants{$accode}."/".$kmer_id."\n";
		
		## removed #node, #spe, because it pritns "db" in the segment compression
		#
		#print $pangenome ">".$acc_hash{$acc_id}."/".$init."/".$end."/".$dep."/".$variants{$accode}."-".$kmer_id."/".
		#									$acc_hash{$acc_id}."-".$kmer_id."\n";
		# this is the new report
		print $pangenome ">".$acc_hash{$acc_id}."/".$init."/".$end."/".$dep."/".$variants{$accode}."/".$kmer_profile."/".$names{$variants{$accode}}."/".$segu."\n";

	} else {
		## this is not header 
		$seq = $_;
		print $pangenome $seq."\n";
	}
	$counter = $counter + 1;
	#if($counter == 49){ last; }
}

