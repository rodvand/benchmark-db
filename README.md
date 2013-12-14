## Benchmark database
Perl script to benchmark a MySQL or MariaDB database.

## Requisites
Database named "benchmark" (will not be created). Provided user must have access to SELECT, UPDATE, DELETE on the test database.

Tested with: MySQL, MariaDB 5.5, MariaDB 10

## How to run
`./benchmark.pl -H <host> -u <user> -p <password> -c <count> [-vdh]`

`Options:
    -h for help
    -t <type> for your output
    -H <host> for the host where the database is located
    -u <user> for the database user
    -p <password> the password for the database user
    -c <count> how many tests should be run in each section
    -v for verbose
    -d for debug
    -o for output.`

Output is in this form: type,count,insert,select,update,delete

## TODO
* Create a more detailed performance monitor - for each insert statement etc to see when the performance hits a wall
