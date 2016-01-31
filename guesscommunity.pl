#!/usr/bin/perl -CSDA
#
# guesscommunity.pl
# Copyright 2014 Raphael Susewind <mail@raphael-susewind.de>
# http://www.raphael-susewind.de
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#

# 
# Preparatory stuff
#

use utf8;
use WWW::Mechanize;
use DBI qw(:utils);

$dbh = DBI->connect("DBI:SQLite:dbname=names.sqlite", "","", {sqlite_unicode=>1});

my $fullname=$ARGV[0];
my $gender=$ARGV[1];

#
# Identify language
#

my $origlang = '';
if ($fullname =~ /\p{Bengali}/) {$origlang = '_bn'; print "Language detected as Bengali\n";}
elsif ($fullname =~ /\p{Gujarati}/) {$origlang = '_gu'; print "Language detected as Gujarati\n";}
elsif ($fullname =~ /\p{Devanagari}/) {$origlang = '_hi'; print "Language detected as Hindi / Devanagari\n";}
elsif ($fullname =~ /\p{Kannada}/) {$origlang = '_kn'; print "Language detected as Kannada\n";}
elsif ($fullname =~ /\p{Malayalam}/) {$origlang = '_ml'; print "Language detected as Malayalam\n";}
elsif ($fullname =~ /\p{Oriya}/) {$origlang = '_or'; print "Language detected as Oriya\n";}
elsif ($fullname =~ /\p{Gurmukhi}/) {$origlang = '_pa'; print "Language detected as Punjabi\n";}
elsif ($fullname =~ /\p{Sinhala}/) {$origlang = '_si'; print "Language detected as Sinhalese\n";}
elsif ($fullname =~ /\p{Tamil}/) {$origlang = '_ta'; print "Language detected as Tamil\n";}
elsif ($fullname =~ /\p{Telugu}/) {$origlang = '_te'; print "Language detected as Telugu\n";}
elsif ($fullname =~ /\p{Arabic}/) {$origlang = '_ur'; print "Language detected as Urdu\n";}

#
# Calculate quality factors
#

my %quality;

my $sth = $dbh->prepare("SELECT name$origlang FROM names WHERE namepart = 'l' GROUP by name$origlang");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @full =  @{$ref};
$sth->finish ();
my $sth = $dbh->prepare("SELECT name$origlang FROM names WHERE namepart = 'l' AND community != '' GROUP BY name$origlang HAVING count(DISTINCT community)=1");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @part = @{$ref};
$sth->finish ();
my $ratio=int(scalar(@part)/scalar(@full)*100)/100;
$quality{'origlast'}=$ratio;

my $sth = $dbh->prepare("SELECT name$origlang FROM names WHERE namepart = 'f' AND gender = 'm' GROUP by name$origlang");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @full =  @{$ref};
$sth->finish ();
my $sth = $dbh->prepare("SELECT name$origlang FROM names WHERE namepart = 'f' AND gender = 'm' GROUP BY name$origlang HAVING count(DISTINCT community)=1");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @part = @{$ref};
$sth->finish ();
my $ratio=int(scalar(@part)/scalar(@full)*100)/100;
$quality{'origfirstm'}=$ratio;

my $sth = $dbh->prepare("SELECT name$origlang FROM names WHERE namepart = 'f' AND gender = 'f' GROUP by name$origlang");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @full =  @{$ref};
$sth->finish ();
my $sth = $dbh->prepare("SELECT name$origlang FROM names WHERE namepart = 'f' AND gender = 'f' GROUP BY name$origlang HAVING count(DISTINCT community)=1");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @part = @{$ref};
$sth->finish ();
my $ratio=int(scalar(@part)/scalar(@full)*100)/100;
$quality{'origfirstf'}=$ratio;

my $sth = $dbh->prepare("SELECT name$origlang FROM names WHERE namepart = 'f' GROUP by name$origlang");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @full =  @{$ref};
$sth->finish ();
my $sth = $dbh->prepare("SELECT name$origlang FROM names WHERE namepart = 'f' GROUP BY name$origlang HAVING count(DISTINCT community)=1");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @part = @{$ref};
$sth->finish ();
my $ratio=int(scalar(@part)/scalar(@full)*100)/100;
$quality{'origfirst'}=$ratio;

my $sth = $dbh->prepare("SELECT soundex$origlang FROM names WHERE namepart = 'l' GROUP by soundex$origlang");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @full =  @{$ref};
$sth->finish ();
my $sth = $dbh->prepare("SELECT soundex$origlang FROM names WHERE namepart = 'l' GROUP BY soundex$origlang HAVING count(DISTINCT community)=1");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @part = @{$ref};
$sth->finish ();
my $ratio=int(scalar(@part)/scalar(@full)*100)/100;
$quality{'soundexlast'}=$ratio;

my $sth = $dbh->prepare("SELECT soundex$origlang FROM names WHERE namepart = 'f' AND gender = 'm' GROUP by soundex$origlang");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @full =  @{$ref};
$sth->finish ();
my $sth = $dbh->prepare("SELECT soundex$origlang FROM names WHERE namepart = 'f' AND gender = 'm' GROUP BY soundex$origlang HAVING count(DISTINCT community)=1");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @part = @{$ref};
$sth->finish ();
my $ratio=int(scalar(@part)/scalar(@full)*100)/100;
$quality{'soundexfirstm'}=$ratio;

my $sth = $dbh->prepare("SELECT soundex$origlang FROM names WHERE namepart = 'f' AND gender = 'f' GROUP by soundex$origlang");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @full =  @{$ref};
$sth->finish ();
my $sth = $dbh->prepare("SELECT soundex$origlang FROM names WHERE namepart = 'f' AND gender = 'f' GROUP BY soundex$origlang HAVING count(DISTINCT community)=1");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @part = @{$ref};
$sth->finish ();
my $ratio=int(scalar(@part)/scalar(@full)*100)/100;
$quality{'soundexfirstf'}=$ratio;

my $sth = $dbh->prepare("SELECT soundex$origlang FROM names WHERE namepart = 'f' GROUP by soundex$origlang");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @full =  @{$ref};
$sth->finish ();
my $sth = $dbh->prepare("SELECT soundex$origlang FROM names WHERE namepart = 'f' GROUP BY soundex$origlang HAVING count(DISTINCT community)=1");
$sth->execute();
my $ref = $sth->fetchall_arrayref;
my @part = @{$ref};
$sth->finish ();
my $ratio=int(scalar(@part)/scalar(@full)*100)/100;
$quality{'soundexfirst'}=$ratio;

#
# Algorithm functions
#

# create hindi from english routine
sub hindi  {
    my $ua = WWW::Mechanize->new(agent=>'Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.0.16)',cookie_jar=>{});                                                                                
    hindi: my $result = $ua->get('http://www.google.com/transliterate/indic?tlqt=1&langpair=en|hi&text='.$_[0].'&&tl_app=1'); 
    if ($result->is_error && $result->error_code != 404) {sleep 5; goto hindi}
    my $json=$ua->content;
    $json=~/\:\s+\[\s+\"(.*?)\"/gs;
    return $1;
}

# create indicsoundex from hindi routine
sub soundex {
    my $orig=$_[0];
    open (FILE,">soundextmp");
    print FILE $orig;
    close (FILE);
    system("python soundex.py");
    open (FILE,"soundextmp");
    $soundex=<FILE>;
    close (FILE);
    chomp($soundex); 
    system("rm -f soundextmp");
    return $soundex;
}

# match against orig last name
sub origlast {
    my %result;
    my $sth = $dbh->prepare("SELECT * FROM names WHERE name$origlang = ? AND namepart = 'l'");
    $sth->execute($_[0]);
    while (my $row=$sth->fetchrow_hashref) {$result{$row->{community}}=$result{$row->{community}}+1;}
    $sth->finish ();
    return %result;
}

# match against orig first name_hi gendered male
sub origfirstm {
    my %result;
    my $sth = $dbh->prepare("SELECT * FROM names WHERE name$origlang = ? AND namepart = 'f' AND gender = 'm'");
    $sth->execute($_[0]);
    while (my $row=$sth->fetchrow_hashref) {$result{$row->{community}}=$result{$row->{community}}+1;}
    $sth->finish ();
    return %result;
}

# match against orig first name_hi gendered female
sub origfirstf {
    my %result;
    my $sth = $dbh->prepare("SELECT * FROM names WHERE name$origlang = ? AND namepart = 'f' AND gender = 'f'");
    $sth->execute($_[0]);
    while (my $row=$sth->fetchrow_hashref) {$result{$row->{community}}=$result{$row->{community}}+1;}
    $sth->finish ();
    return %result;
}

# match against orig first name
sub origfirst {
    my %result;
    my $sth = $dbh->prepare("SELECT * FROM names WHERE name$origlang = ? AND namepart = 'f'");
    $sth->execute($_[0]);
    while (my $row=$sth->fetchrow_hashref) {$result{$row->{community}}=$result{$row->{community}}+1;}
    $sth->finish ();
    return %result;
}

# match against soundex last name
sub soundexlast {
    my %result;
    my $sth = $dbh->prepare("SELECT * FROM names WHERE soundex$origlang = ? AND namepart = 'l'");
    $sth->execute($_[0]);
    while (my $row=$sth->fetchrow_hashref) {$result{$row->{community}}=$result{$row->{community}}+1;}
    $sth->finish ();
    return %result;
}

# match against soundex first name gendered male
sub soundexfirstm {
    my %result;
    my $sth = $dbh->prepare("SELECT * FROM names WHERE soundex$origlang = ? AND namepart = 'f' AND gender = 'm'");
    $sth->execute($_[0]);
    while (my $row=$sth->fetchrow_hashref) {$result{$row->{community}}=$result{$row->{community}}+1;}
    $sth->finish ();
    return %result;
}

# match against soundex first name gendered female
sub soundexfirstf {
    my %result;
    my $sth = $dbh->prepare("SELECT * FROM names WHERE soundex$origlang = ? AND namepart = 'f' AND gender = 'f'");
    $sth->execute($_[0]);
    while (my $row=$sth->fetchrow_hashref) {$result{$row->{community}}=$result{$row->{community}}+1;}
    $sth->finish ();
    return %result;
}

# match against soundex first name
sub soundexfirst {
    my %result;
    my $sth = $dbh->prepare("SELECT * FROM names WHERE soundex$origlang = ? AND namepart = 'f'");
    $sth->execute($_[0]);
    while (my $row=$sth->fetchrow_hashref) {$result{$row->{community}}=$result{$row->{community}}+1;}
    $sth->finish ();
    return %result;
}

#
# Run the namechecking per se
#

my @names=split(/ /,$fullname);
my %soundex; my @firstnames; my @lastnames;

my $name=pop(@names); # guess that last or only name is lastname, rest is rather firstname - but check

if ($origlang ne '') { # create soundex
    $soundex{$name}=soundex($name);
    print "Soundex identified as ".soundex($fullname)."\n";
} else {
    $soundex{$name}=soundex(hindi($name));
    print "Soundex identified as ".hindi(soundex($fullname))."\n";
}

my $last = $dbh->selectrow_array("SELECT count(*) FROM names WHERE soundex$origlang = ? AND namepart = 'l'",undef,$soundex{$name});
if ($last<0) {
    my $first = $dbh->selectrow_array("SELECT count(*) FROM names WHERE soundex$origlang = ? AND namepart = 'f'",undef,$soundex{$name});
    if ($first>0) {push(@firstnames,$name)}
} else {push(@lastnames,$name)}

foreach my $name (@names) { # Favour firstname if in doubt for all other names
    if ($origlang ne '') {
	$soundex{$name}=soundex($name)
    } else {
	$soundex{$name}=soundex(hindi($name))
    }
    my $first = $dbh->selectrow_array("SELECT count(*) FROM names WHERE soundex$origlang = ? AND namepart = 'f'",undef,$soundex{$name});
    if ($first<0) {
	my $last = $dbh->selectrow_array("SELECT count(*) FROM names WHERE soundex$origlang = ? AND namepart = 'l'",undef,$soundex{$name});
	if ($last>0) {push(@lastnames,$name)}
    } else {push(@firstnames,$name)}
}

my %community;
my $jaga=0;

# identify all lastnames
foreach my $lastname (@lastnames) {
    my %origlast = origlast($lastname);
    my $origcount=0;
    my %soundexlast;
    if ($origlang ne '') {
	%soundexlast = soundexlast(soundex($lastname));
    } else {
	%soundexlast = soundexlast(soundex(hindi($lastname)));
    }
    my $soundexcount=0;
    foreach my $com (keys(%origlast)) {$origcount=$origcount+$origlast{$com}}
    foreach my $com (keys(%soundexlast)) {$soundexcount=$soundexcount+$soundexlast{$com}}
    if ($origcount>0 and $soundexcount>0) {
	foreach my $com ((keys(%origlast),keys(%soundexlast))) {$community{$lastname}{$com}=1-($origcount-$origlast{$com})/$origcount*($soundexcount-$soundexlast{$com})/$soundexcount;$jaga=1;$match=1}
	foreach my $com (keys(%origlast)) {$community{$lastname}{$com}=$community{$lastname}{$com}*$quality{'origlast'}}
	foreach my $com (keys(%soundexlast)) {$community{$lastname}{$com}=$community{$lastname}{$com}*$quality{'soundexlast'}}
    } elsif ($origcount>0) {
	foreach my $com (keys(%origlast)) {$community{$lastname}{$com}=1-($origcount-$origlast{$com})/$origcount;$jaga=1;$match=1}
	foreach my $com (keys(%origlast)) {$community{$lastname}{$com}=$community{$lastname}{$com}*$quality{'origlast'}}
    } elsif ($soundexcount>0) {
	    foreach my $com (keys(%soundexlast)) {$community{$lastname}{$com}=1-($soundexcount-$soundexlast{$com})/$soundexcount;$jaga=1;$match=1}
	foreach my $com (keys(%soundexlast)) {$community{$lastname}{$com}=$community{$lastname}{$com}*$quality{'soundexlast'}}
    }
    # if no matching lastname found at all, it might be a firstname
    if ($jaga==0) {push(@firstnames,$lastname)}
}
    
# identify all firstnames
foreach my $firstname (@firstnames) {
    if ($gender eq 'm') {
	my %origfirstm = origfirstm($firstname);
	my $origcount=0;
	my %soundexfirstm;
	if ($origlang ne '') {
	    %soundexfirstm = soundexfirstm(soundex($firstname));
	} else {
	    %soundexfirstm = soundexfirstm(soundex(hindi($firstname)));
	}
	my $soundexcount=0;
	foreach my $com (keys(%origfirstm)) {$origcount=$origcount+$origfirstm{$com}}
	foreach my $com (keys(%soundexfirstm)) {$soundexcount=$soundexcount+$soundexfirstm{$com}}
	if ($origcount>0 and $soundexcount>0) {
	    foreach my $com ((keys(%origfirstm),keys(%soundexfirstm))) {$community{$firstname}{$com}=1-($origcount-$origfirstm{$com})/$origcount*($soundexcount-$soundexfirstm{$com})/$soundexcount;$jaga=1;$match=1}
	    foreach my $com (keys(%origfirstm)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirstm'}}
	    foreach my $com (keys(%soundexfirstm)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirstm'}}
	} elsif ($origcount>0) {
	    foreach my $com (keys(%origfirstm)) {$community{$firstname}{$com}=1-($origcount-$origfirstm{$com})/$origcount;$jaga=1;$match=1}
	    foreach my $com (keys(%origfirstm)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirstm'}}
	} elsif ($soundexcount>0) {
	    foreach my $com (keys(%soundexfirstm)) {$community{$firstname}{$com}=1-($soundexcount-$soundexfirstm{$com})/$soundexcount;$jaga=1;$match=1}
	    foreach my $com (keys(%soundexfirstm)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirstm'}}
	} else { # ignore gender if nothing found
	    my %origfirst = origfirst($firstname);
	    my $origcount=0;
	    my %soundexfirst = soundexfirst(soundex(hindi($firstname)));
	    my $soundexcount=0;
	    foreach my $com (keys(%origfirst)) {$origcount=$origcount+$origfirst{$com}}
	    foreach my $com (keys(%soundexfirst)) {$soundexcount=$soundexcount+$soundexfirst{$com}}
	    if ($origcount>0 and $soundexcount>0) {
		foreach my $com ((keys(%origfirst),keys(%soundexfirst))) {$community{$firstname}{$com}=1-($origcount-$origfirst{$com})/$origcount*($soundexcount-$soundexfirst{$com})/$soundexcount;$jaga=1;$match=1}
		foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirst'}}
		foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirst'}}
	    } elsif ($origcount>0) {
		foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=1-($origcount-$origfirst{$com})/$origcount;$jaga=1;$match=1}
		foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirst'}}
	    } elsif ($soundexcount>0) {
		foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=1-($soundexcount-$soundexfirst{$com})/$soundexcount;$jaga=1;$match=1}
		foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirst'}}
	    }
	}
    } elsif ($gender eq 'f') {
	my %origfirstf = origfirstf($firstname);
	my $origcount=0;
	my %soundexfirstf;
	if ($origlang ne '') {
	    %soundexfirstf = soundexfirstm(soundex($firstname));
	} else {
	    %soundexfirstf = soundexfirstm(soundex(hindi($firstname)));
	}
	my $soundexcount=0;
	foreach my $com (keys(%origfirstf)) {$origcount=$origcount+$origfirstf{$com}}
	foreach my $com (keys(%soundexfirstf)) {$soundexcount=$soundexcount+$soundexfirstf{$com}}
	if ($origcount>0 and $soundexcount>0) {
	    foreach my $com ((keys(%origfirstf),keys(%soundexfirstf))) {$community{$firstname}{$com}=1-($origcount-$origfirstf{$com})/$origcount*($soundexcount-$soundexfirstf{$com})/$soundexcount;$jaga=1;$match=1}
	    foreach my $com (keys(%origfirstf)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirstf'}}
	    foreach my $com (keys(%soundexfirstf)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirstf'}}
	} elsif ($origcount>0) {
	    foreach my $com (keys(%origfirstf)) {$community{$firstname}{$com}=1-($origcount-$origfirstf{$com})/$origcount;$jaga=1;$match=1}
	    foreach my $com (keys(%origfirstf)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirstf'}}
	} elsif ($soundexcount>0) {
	    foreach my $com (keys(%soundexfirstf)) {$community{$firstname}{$com}=1-($soundexcount-$soundexfirstf{$com})/$soundexcount;$jaga=1;$match=1}
	    foreach my $com (keys(%soundexfirstf)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirstf'}}
	} else { # ignore gender if nothing found
	    my %origfirst = origfirst($firstname);
	    my $origcount=0;
	    my %soundexfirst = soundexfirst(soundex(hindi($firstname)));
	    my $soundexcount=0;
	    foreach my $com (keys(%origfirst)) {$origcount=$origcount+$origfirst{$com}}
	    foreach my $com (keys(%soundexfirst)) {$soundexcount=$soundexcount+$soundexfirst{$com}}
	    if ($origcount>0 and $soundexcount>0) {
		foreach my $com ((keys(%origfirst),keys(%soundexfirst))) {$community{$firstname}{$com}=1-($origcount-$origfirst{$com})/$origcount*($soundexcount-$soundexfirst{$com})/$soundexcount;$jaga=1;$match=1}
		foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirst'}}
		foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirst'}}
	    } elsif ($origcount>0) {
		foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=1-($origcount-$origfirst{$com})/$origcount;$jaga=1;$match=1}
		foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirst'}}
	    } elsif ($soundexcount>0) {
		foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=1-($soundexcount-$soundexfirst{$com})/$soundexcount;$jaga=1;$match=1}
		foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirst'}}
	    }
	}
    } else {
	my %origfirst = origfirst($firstname);
	my $origcount=0;
	my %soundexfirst;
	if ($origlang ne '') {
	    %soundexfirst = soundexfirstm(soundex($firstname));
	} else {
	    %soundexfirst = soundexfirstm(soundex(hindi($firstname)));
	}
	my $soundexcount=0;
	foreach my $com (keys(%origfirst)) {$origcount=$origcount+$origfirst{$com}}
	foreach my $com (keys(%soundexfirst)) {$soundexcount=$soundexcount+$soundexfirst{$com}}
	if ($origcount>0 and $soundexcount>0) {
	    foreach my $com ((keys(%origfirst),keys(%soundexfirst))) {$community{$firstname}{$com}=1-($origcount-$origfirst{$com})/$origcount*($soundexcount-$soundexfirst{$com})/$soundexcount;$jaga=1;$match=1}
	    foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirst'}}
	    foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirst'}}
	} elsif ($origcount>0) {
	    foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=1-($origcount-$origfirst{$com})/$origcount;$jaga=1;$match=1}
	    foreach my $com (keys(%origfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'origfirst'}}
	} elsif ($soundexcount>0) {
	    foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=1-($soundexcount-$soundexfirst{$com})/$soundexcount;$jaga=1;$match=1}
	    foreach my $com (keys(%soundexfirst)) {$community{$firstname}{$com}=$community{$firstname}{$com}*$quality{'soundexfirst'}}
	}
    }
}


#
# Combine names and print out results
#

if ($jaga>0) {
    my %communitylist;
    my $count;
    foreach my $name ((@firstnames,@lastnames)) {foreach my $community (keys(%{$community{$name}})) {$communitylist{$community}=1;$count=$count+1;}}
    foreach my $community (keys(%communitylist)) {
	foreach my $name (@firstnames) {$communitylist{$community}=$communitylist{$community}*($count-$community{$name}{$community})/$count}
	foreach my $name (@lastnames) {$communitylist{$community}=$communitylist{$community}*($count-$community{$name}{$community})/$count}
	$communitylist{$community}=int((1-$communitylist{$community})*100);
    }
    my @sorted=sort {$communitylist{$b} <=> $communitylist{$a}} (keys(%communitylist));
    my $diff=$communitylist{$sorted[0]}-$communitylist{$sorted[1]};
    if ($diff>0) {print "Best bet: ".$sorted[0]." with certainty index difference to second best bet of ".$diff."\%\n"} else {print "Best bet: Unknown (more than one equally good option)\n"}
    
    foreach my $community (sort {$communitylist{$b} <=> $communitylist{$a}} (keys(%communitylist))) {
	print "$community with certainty index of ".$communitylist{$community}."\%\n";
    }
} else {
    print "Best bet: Unknown\n"
}
