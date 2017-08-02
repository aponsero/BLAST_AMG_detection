#
# This script is intended to select potential AMGs (cds with a bacterial hit on a contig containing a viral matching cds). This script uses a figFam annotation log allowing to translate the FIGFAM annotation and a Taxonomic log allowing to identify the potential bacterial host. Those logs are generated with the database.
#

use 5.010;
use strict;
use warnings;

my $B_hits = $ARGV[0];
my $V_hits= $ARGV[1];
my $out_file= $ARGV[2];
my $figFam= $ARGV[3];
my $taxo= $ARGV[4];
print "$B_hits\n $V_hits\n $out_file\n $figFam\n $taxo\n";

my %contig_vir_hits;
my %cds_vir_hits;
my %cds_bact_hits;
my $prev_cds="init";

if(open(my $fh_B, '<', $B_hits)){
if(open(my $fh_V, '<', $V_hits)){
if(open(my $fhout, '>', $out_file)){
if(open(my $fig, '<', $figFam)){
if(open(my $tax, '<', $taxo)){

#load taxo and FigFam information in hashmaps
my %tax_info;
while(my $taxid=<$tax>){
	chomp $taxid;
	my @split_tax=split(/\t/, $taxid);
	$tax_info{$split_tax[0]}=$taxid	;
}

my %fig_info;
while(my $figid=<$fig>){
	chomp $figid;
	my @split_fig=split(/\t/, $figid);
	$fig_info{$split_fig[0]}=$split_fig[1];
}

while(my $row=<$fh_V>){
	chomp $row;
	my @split=split(/\t/, $row);
	my @contig_split=split(/\|/, $split[0]);
	my $contig=$contig_split[1];
	my $cds=$contig_split[2];

	if(!($prev_cds eq $cds)){
		push (@{$contig_vir_hits{$contig}}, $cds);
		$cds_vir_hits{$cds}=$row;
		$prev_cds=$cds;
	}
}

$prev_cds="reinit";

while(my $rox=<$fh_B>){
	chomp $rox;
	my @split=split(/\t/, $rox);
        my @contig_split=split(/\|/, $split[0]);
        my $contig=$contig_split[1];
        my $cds=$contig_split[2];

	if(!($prev_cds eq $cds)){
		$prev_cds=$cds;

		if((defined $contig_vir_hits{$contig})and(!(exists $cds_vir_hits{$cds}))){
			$cds_bact_hits{$cds}=$rox;
		}
	}

}

#print the bacterial hits
my $cpt = 1;
while ((my $key, my $value)=each(%cds_bact_hits)){
	print $fhout "\n";
	print $fhout "Potential AMG detected :\n";
	$cpt++;

	my @temp_row=split(/\t/, $cds_bact_hits{$key});
	my @contig_temp=split(/\|/, $temp_row[0]);
	my @info=split("_", $temp_row[1]);
	my $Fig_query=$info[1];
	my $contig=$contig_temp[1];
	
	print $fhout "contig = $contig\n";
	print $fhout "$cds_bact_hits{$key}\n";
	
	if(defined $fig_info{$Fig_query}){
		print $fhout "fig = $Fig_query -->  $fig_info{$Fig_query}\n";
	}else{
		print $fhout "fig = $Fig_query -->  unknown\n";
	}
	
	my @id=split /[-\.]+/, $info[0];
	my $genome="$id[2].$id[3]";
	
	
	if(defined $tax_info{$genome}){
		print $fhout "taxo = $genome --> $tax_info{$genome}\n";
	}else{
		print $fhout "taxo = $genome --> unknown\n";
	}
	
	
	print $fhout "viral confirmation :\n";
	for my $mycds (@{$contig_vir_hits{$contig}}){
		print $fhout "vir cds : $mycds\n";
	}
#	
#it is possible to print the viral hits using the $cds_vir_hits{$cds} map 
#	
}

}else{die "could not open $taxo";}
}else{die "could not open $figFam";}
}else{die "could not open $out_file";}
}else{die "could not open $V_hits";}
}else{die "could not open $B_hits";}


#end of job  
