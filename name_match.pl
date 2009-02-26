#!/usr/bin/perl
require 'common.pl';

#use Text::JaroWinkler qw( strcmp95 );
use Data::Dumper;
select(STDOUT); $| = 1; #unbuffer STDOUT
$match_table = '_company_matches';
$match_keep_level = 10;  # only put matches in db if bigger than this
print "saving results with score above ".$match_keep_level." into table ".$match_table."\n";

#$namequeries[2] = "select ucase(name), id from fortune1000 where name like '%ford%' order by name limit 10";

#get the sets of names we are gonna be comparing
$namequeries[1] = "select ucase(name),id as cw_id from fortune1000";
#$namequeries[2] = "select name,cw_id from company_names where source = 'filer_match_name' or source = 'relationships_clean_company' ";

our $db;

$db->do("DROP TABLE IF EXISTS `$match_table`");
$db->do("CREATE TABLE `$match_table` ( `id` int(11) NOT NULL auto_increment, `name1` varchar(255) default NULL, `name2` varchar(255) default NULL, `score` decimal(5,2) default NULL, id_a varchar(25), id_b varchar(25),`match_type` varchar(10), `match` int(1) default 0, PRIMARY KEY  (`id`), KEY `id1` (`name1`), KEY `id2` (`name2`), KEY `score` (`score`))"); 

#load in the single word frequency rates
my $weights = $db->selectall_hashref("select word, weight from word_freq", 'word');

#load in the bigram frequency rates
my $bi_weights = $db->selectall_hashref("select bigram, weight from bigram_freq", 'bigram');

my $matches;
my $clean;
foreach ('1', '2') {
	my $set = $_;
	print "Fetching names $set...\n";
	#$query = "select ucase(name) from person_names where (sourcetable= 'facultylist' or sourcetable='courtesyapps') group by ucase(name) order by name"; 
	#$query = "select ucase(name) from person_names group by ucase(name) order by name"; 
	my $sth = $db->prepare($namequeries[$set]) || print "$DBI->errstr\n";
	$sth->execute() || print "$DBI->errstr\n";
	print $db->errstr;

	while (my $row = $sth->fetchrow_arrayref) { 
	  #thse regexs clean out puncuation for matching
		#$row->[0] =~ s/-/ /;
		#$row->[0] =~ /^([^,]+), ([^"]+)/;
		#my $first = $2;
		#my $last = $1;
		#unless ($first && $last) { print "wtf! $row->[0] - $row->[1]\n"; exit;}
	   #but instead we use the common cleaning fuction
	    $row->[0] = &clean_for_match($row->[0]);
		$names = {name=>$row->[0], cw_id=>$row->[1]};
		push(@{$clean->[$set]}, $names);
	}
}
#print Data::Dumper::Dumper($clean);
print "Finding matches...\n";
#prepare a statment for inserting matches into db.
my $sth2 = $db->prepare("insert into $match_table (name1, name2, score, id_a, id_b,match_type) values (?,?,?,?,?,?)");

my $count = 0;
my $y = 0;
my $listsize = scalar(@{$clean->[1]});
my $time = time();
print "$count/$listsize\n";
my $matches;
my $percent = int($#{$clean->[1]}/100);


#loop over the names, computing match score for each. 
foreach my $names (@{$clean->[1]}) {
    #tracker to print out percent done
	if ($y == $percent) { 
		print "\r".int($count/$listsize*100) ."% (";
		my $ntime = time() - $time;
		print "$ntime)";  
		$y = 0; 
		$time = time();
	}
	$y++;
	
	#get the name off the list
	my $name1 = ${$names}{name};
	#set up a query to get the a corresponding subset of names to match against
	#print "getting matchlist for ".$name1."  (id: ".${$names}{cw_id}.")";
	my @match_subset;
	my $query = &name_subset_query($name1,"cw_companies");
	#print ($query."\n");
    my $sth3 = $db->prepare($query) || print "$DBI->errstr\n";
	$sth3->execute() || print "$DBI->errstr\n";
	print $db->errstr;
	#load the query results into array (assuming they already cleaned) 
	while (my $row = $sth3->fetchrow_arrayref) { 
	  	$record = {name=>$row->[0], cw_id=>$row->[1]};
		push(@match_subset, $record);
	}
	#print " comparing to ".scalar(@match_subset)." names.\n";
	
	#TODO: FIRST CHECK FOR 100% MATCH, THEN POSSIBLE TO IGNORE LOWER MATCHES? 
	
	#TODO: could speed this up a lot by caching the tokens and scores from $name1 so that we don't recalculate for each submatch?. 
	foreach my $names2 (@match_subset) {
		#if (${$names}{primary_id} == ${$names2}{primary_id}) { next; }
		my $name2 = ${$names2}{name};
		#$matches->{$name1}->{$name2}->{'count'}++;
		#print "\t$name1 v $name2: $matches->{$name1}->{$name2}";
		#print "\r\t$name1 v $name2: $matches->{$name1}->{$name2}    ";
		
		
		#----- bigram matching
		#if matching efficiently, only match pair in one direction
		unless ($efficient_matching && ${$names}{cw_id} gt ${$names2}{cw_id}) {
			my $match = 0;
			if ($name1 eq $name2) { 
				$match = 100;  
			} else {
				$match = &get_bigram_score(${$names}{name}, ${$names2}{name});
				$match *=100;
				unless ($match) { $match = 0; }
			}
			#print "\t".$name2." (bigram): ".$match."\n";
			#if the match is above a threshold, insert in db
			if ($match > $match_keep_level) { 
				$sth2->execute($name1, $name2, $match, ${$names}{cw_id}, ${$names2}{cw_id},"bigram"); 
			}
			#print "$match";
		} #else { print "dupe\n"; }
		
		# term frequency matching
		#if matching efficiently, only match pair in one direction
		unless ($efficient_matching && ${$names}{cw_id} gt ${$names2}{cw_id}) {
			my $match = 0;
			if ($name1 eq $name2) { 
				$match = 100;  
			} else {
				$match = &get_term_score(${$names}{name}, ${$names2}{name});
				$match *=100;
				unless ($match) { $match = 0; }
			}
			#print "\t".$name2." (term_freq): ".$match."\n";
			#if the match is above a threshold, insert in db
			if ($match > $match_keep_level) { $sth2->execute($name1, $name2, $match, ${$names}{cw_id}, ${$names2}{cw_id},"term_freq"); }
			#print "$match";
		} #else { print "dupe\n"; }
	}
	$count++;
	#print total_size($clean)."\t".total_size($matches)."\t".total_size($sth)."\n";
}	

#$db->do("insert into $match_table select null, name2, name1, score from $match_table");
exit;

#compute a match score based on the intersecting set of terms, weighted by their observed frequency in our set of names
sub get_term_score() {
	my ($comp1, $comp2) = @_;
	my $score = 0;
	my $no_match_weight = 0.2;

	my @tokens1 = split(/ /,lc($comp1));
	my @tokens2 = split(/ /,lc($comp2));
	
	#//score=     2*(sum score tokens in comp) / (sum score comp1)+(sum score comp2);
	my $sum1 =0;
	my $sum2 =0;
	my $sumBoth = 0;
	foreach my $token (@tokens1){
	   #if it has a weight, it is at least somewhat common
	    if (defined $weights->{$token}){
			$sum1 += $weights->{$token}->{weight};
		} else {
		 #//it didn't show up the the db, so weight it as $no_match_weight 
		 $sum1 += $no_match_weight ;
		}
		#//check if it is in the other company set
		
		if (grep {$_ eq $token } @tokens2){
			if (defined $weights->{$token}){
				$sumBoth += $weights->{$token}->{'weight'} * 2;
			} else {
			    $sumBoth += $no_match_weight*2;
			}
		}
	}
	#// now compute weight for 2nd company
	foreach my $token (@tokens2){
	    if (defined $weights->{$token}){
			$sum2 += $weights->{$token}->{weight};
		} else {
		#since it is not in our list of common tokens, assume it is rare
			$sum2 += $no_match_weight ;
		}

	}
    $score = $sumBoth/($sum1+$sum2);
	return $score;
}

#break a name up into a series of bigrams
sub list_bigrams() {
   my @gram_list;
   my $name = $_[0];
   my @words = split(/[\s\/]+/, $name); 
	my $numtokens = @words;
	foreach my $i(0 .. $numtokens-2) {
	    my $bigram = @words[$i] ." ". @words[$i+1];
	    #need a more standard function for stripping punctuation
		$bigram =~ s/[\.,]//g;  
		push(@gram_list, lc($bigram));
	}
	return @gram_list;
}

#compute a match score based on the frequency of bigram occurances observed in our set of names
sub get_bigram_score() {
	my ($comp1, $comp2) = @_;
	my $score = 0;
	my $no_match_weight = 0.2;
	#how to handle names that have just a single term?

	my @tokens1 = &list_bigrams($comp1);
	my @tokens2 = &list_bigrams($comp2);
	
	#//score=     2*(sum score tokens in comp) / (sum score comp1)+(sum score comp2);
	my $sum1 =0;
	my $sum2 =0;
	my $sumBoth = 0;
	my $score = 0;
	foreach my $token (@tokens1){
	   #if it has a weight, it is at least somewhat common
	    if (defined $bi_weights->{$token}){
			$sum1 += $bi_weights->{$token}->{weight};
		} else {
		 #//it didn't show up the the db, so weight it as $no_match_weight 
		 $sum1 += $no_match_weight ;
		}
		#//check if it is in the other company set
		
		if (grep {$_ eq $token } @tokens2){
			if (defined $bi_weights->{$token}){
				$sumBoth += $bi_weights->{$token}->{'weight'} * 2;
			} else {
			    $sumBoth += $no_match_weight*2;
			}
		}
	}
	#// now compute weight for 2nd company
	foreach my $token (@tokens2){
	    if (defined $bi_weights->{$token}){
			$sum2 += $bi_weights->{$token}->{weight};
		} else {
		#since it is not in our list of common tokens, assume it is rare
			$sum2 += $no_match_weight ;
		}

	}
	
	#deal with case to avoid divide by zero
	if ($sum1+$sum2 > 0){
      $score = $sumBoth/($sum1+$sum2);
    } 
	return $score;
}

#create a query that will return a subset of names that match at least one term each.  This costs some mysql query time, but makes it so we are only matching aginst 100 or a few thousand names instead of tens of thousands. 

sub name_subset_query() {
  my $comp1 = @_[0];  #the company name that will be matched. 
  my $match_set = @_[1];  #this determines what nameset we should match against
  #need to escape quotes in company name for db
  $comp1 = &clean_for_match($comp1);
 # $comp1 =~ s/'/\'/;
 #$comp1 =~ s/"/\"/;
  my @tokens1 = split(/ /,lc($comp1)); #break name into tokens on space
  my $query = "";
    
  #if we are matching against all names 
  if ($match_set eq "cik_and_relations") {
	  $first = pop(@tokens1);
	   $query = "select ucase(clean_company), '?' as cw_id from relationships where clean_company like '%".$first."%' union distinct select ucase(match_name),cik as cw_id from cik_name_lookup where match_name like '%".$first."%'";
	  foreach my $token (@tokens1){
		 $query = $query." union distinct 
		 select ucase(clean_company),'?' as cw_id from relationships where clean_company like '%".$token."%' union distinct select ucase(match_name),cik as cw_id from cik_name_lookup where match_name like '%".$token."%'";
	  }
   }
   #use these quries if we are only matching aginst company_names table	  
   elsif ($match_set eq "cw_companies") {
   		$first = pop(@tokens1);
	   $query = "select ucase(name), cw_id from company_names where (source = 'filer_match_name' or source='relationships_clean_company') and name like '%".$first."%' ";
	  foreach my $token (@tokens1){
		 $query = $query."union distinct select ucase(name), cw_id from company_names where (source = 'filer_match_name' or source='relationships_clean_company') and name like '%".$token."%' ";
      }
    } else {
       #uh oh, what should default be?
    }
  return $query;
}