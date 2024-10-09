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
while(<$coor>){
	chomp($_);
	$_ =~ tr/ //d;
	my @line = split("_", $_);

	if(index ($_, '*') != -1) {
		print $output "\n";	
	}

	print $output $accs{$line[0]}."_".$line[1];
	if(index ($_, '*') != -1) {
		print $output $variants{$accs{$line[0]}}.":";	
	}
	

	if(index ($_, '*') != -1) {
		#print $output "\n";	
	} else {
		print $output " ";
	}
	
}
