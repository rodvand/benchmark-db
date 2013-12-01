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
use Time::HiRes;

# Global vars
my $VERBOSE = 0;
my $DEBUG = 0;

# Commandline
my $opt_string = "hvdt:H:u:p:c:o";
getopts("$opt_string", \my %opt) or usage() and exit(1);

$VERBOSE = 1 if $opt{v};
$DEBUG =1 if $opt{d};

# Db vars
my $DBHOST = $opt{H};
my $DBUSER = $opt{u};
my $DBPASS = $opt{p};
my $DB = "benchmark";

if ($opt{h}) {
    usage();
    exit(0);
}

# For cleaner output
my @output;
push(@output, $opt{t});
push(@output, $opt{c});

debug("Connecting to: ".$DBHOST." using ".$DBUSER." with password ".$DBPASS.".\n");
debug("TYPE: ".$opt{t}."\n");

my $dbh = DBI->connect("DBI:mysql:$DB;host=$DBHOST;port=3306;", $DBUSER, $DBPASS);

if ($dbh) {
    debug("Connected.\n");
    my $query;
    
    # Start on scratch - drop benchmark table if it already exists
    $query = $dbh->prepare("DROP TABLE IF EXISTS benchmark");
    $query->execute() || die "Something went wrong: $DBI::errstr\n";
    debug("Dropped table benchmark if it already existed.\n"); 

    # Create our benchmark table
    $query = $dbh->prepare("CREATE TABLE benchmark (
                                id INT NOT NULL AUTO_INCREMENT,
                                message varchar(40) NOT NULL,
                                PRIMARY KEY (id)
                                )");
    $query->execute() || die "Something went wrong: $DBI::errstr\n";
    debug("Created benchmark table.\n");
    verbose("Test table created.\n");

    # Ok, our tables are created now let's start the testing
    # Test-data: /usr/share/dict/words > words.txt
    # Number of words: 235886
    # Tests will be in this order: INSERT, SELECT, UPDATE, DELETE
    # Each test segment will run <c> times
    my $COUNT = $opt{c};
    debug("COUNT is: $COUNT\n");
    verbose("Running $COUNT tests of each function.\n");
    
    open FILE, '<', 'words.txt';
    my @words;
    my $j = 0;
    while(my $line = <FILE>) {
        push(@words, $line); 
        last if $j == $COUNT;
    }

    # INSERT
    my $i = 0;
    my $start_time = [Time::HiRes::gettimeofday()];
    foreach my $line (@words) {
        $query = $dbh->prepare('INSERT INTO benchmark (message)
                                VALUES(?)');
        $query->execute($line);
        $i++;
        last if $i == $COUNT;
    }
    my $diff = Time::HiRes::tv_interval($start_time);
    push(@output, $diff);
    debug("Time for $COUNT INSERT: $diff\n");
    
    # SELECT
    my $i = 0;
    $start_time = [Time::HiRes::gettimeofday()];
    foreach my $line (@words) {
        $query = $dbh->prepare('SELECT * FROM benchmark 
                                WHERE message = ?');
        $query->execute($line);
        $i++;
        last if $i == $COUNT;
    }
    $diff = Time::HiRes::tv_interval($start_time);
    push(@output, $diff);
    debug("Time for $COUNT SELECT: $diff\n");

    # UPDATE
    my $i = 0;
    $start_time = [Time::HiRes::gettimeofday()];
    my @revers = reverse(@words);
    foreach my $line (@words) {
        $query = $dbh->prepare('UPDATE benchmark SET message = ? 
                                WHERE message = ?');
        $query->execute($revers[$i], $line);
        $i++;
        last if $i == $COUNT;
    }
    $diff = Time::HiRes::tv_interval($start_time);
    push(@output, $diff);
    debug("Time for $COUNT UPDATE: $diff\n");

    # DELETE
    my $i = 0;
    $start_time = [Time::HiRes::gettimeofday()];
    foreach my $line (@words) {
        $query = $dbh->prepare('DELETE FROM benchmark WHERE message = ?');
        $query->execute($line);
        $i++;
        last if $i == $COUNT;
    }
    $diff = Time::HiRes::tv_interval($start_time);
    push(@output, $diff);
    debug("Time for $COUNT DELETE: $diff\n");
}

if ($opt{o}) {
    my $out = join(',', @output);
    print $out."\n";
}

# Subs
sub usage() {
    print "Usage:\n";
    print "\t-h for help (this bit)\n";
    print "\t-t <databse type> Mysql (my) or MariaDB (ma)\n";
    print "\t-H <host>\n";
    print "\t-u <user>\n";
    print "\t-p <password>\n";
    print "\t-c <count> the number of queries to be run\n";
    print "\t-o print the output in a comma-separated list \
        \t(type,count,insert,select,update,delete)\n"
}

sub verbose {
    print "VERBOSE: " . $_[0] if $VERBOSE;
}

sub debug {
    print "DEBUG: " . $_[0] if $DEBUG;
}
