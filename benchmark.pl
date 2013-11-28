#!/usr/bin/perl
# Script to benchmark a database
# Input:
# -t <database type> MySQL/MariaDB
# -h <host>
# -u <user>
# -p <password>
# -c <count>

# Packages
use strict "vars";
use Getopt::Std;
use DBI;

# Global vars
my $VERBOSE = 0;
my $DEBUG = 0;

# Commandline
my $opt_string = "hvdt:H:u:p:c:";
getopts("$opt_string", \my %opt) or usage() and exit(1);

$VERBOSE = 1 if $opt{v};
$DEBUG =1 if $opt{d};

# Db vars
my $DBHOST = $opt{H};
my $DBUSER = $opt{u};
my $DBPASS = $opt{p};
my $DB = "test";

if ($opt{h}) {
    usage();
    exit(0);
}

debug("Connecting to: ".$DBHOST." using ".$DBUSER." with password ".$DBPASS.".\n");
debug("TYPE: ".$opt{t}."\n");

my $dbh = DBI->connect("DBI:mysql:$DB;host=$DBHOST;port=3306;", $DBUSER, $DBPASS);

if ($dbh) {
    debug("Connected.\n")
}

# Subs
sub usage() {
    print "Usage:\n";
    print "-h for help (this bit)\n";
    print "-t <databse type> Mysql (my) or MariaDB (ma)\n";
    print "-h <host>\n";
    print "-u <user>\n";
    print "-p <password>\n";
    print "-c <count> the number of queries to be run\n";
}

sub verbose {
    print "VERBOSE: " . $_[0] if $VERBOSE;
}

sub debug {
    print "DEBUG: " . $_[0] if $DEBUG;
}
