#!/usr/bin/perl

use DBI;
use JSON;
use Data::Dumper;

open(VENUE, "< Venue.json")
    or die "Couldn't open file: $!\n";

$line = <VENUE>;
$json = decode_json($line);
close(VENUE);

my $dbh = DBI->connect("DBI:mysql:database=mag-new-160205;host=localhost", "username", "password")
    or die "Couldn't connect to mysql database $database: $!\n";
my $sth = $dbh->prepare("SELECT * FROM ConferenceSeries WHERE ConferenceSeriesID = ?") or die $dbh->errstr;

open(CONFERENCE, "> ConferenceSeries.txt");
print CONFERENCE "ConferenceSeriesID\tShortName\tFullName\tUnderCS\n";

foreach $id (@{$json->{'Conference'}}) {
    $sth->execute($id) or die $sth->errstr;
    while (@data = $sth->fetchrow_array()) {
        $str = join("\t", @data);
        print CONFERENCE "$str\n";
    }
}

close(CONFERENCE);
$sth->finish();

my $sth = $dbh->prepare("SELECT * FROM Journals WHERE JournalID = ?") or die $dbh->errstr;

open(JOURNAL, "> Journals.txt");
print JOURNAL "JournalID\tJournalName\tUnderCS\tJournalName\n";

foreach $id (@{$json->{'Journal'}}) {
    $sth->execute($id) or die $sth->errstr;
    while (@data = $sth->fetchrow_array()) {
        $str = join("\t", @data);
        print JOURNAL "$str\n";
    }
}

close(JOURNAL);
$sth->finish();
$dbh->disconnect();