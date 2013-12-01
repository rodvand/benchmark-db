## Benchmark database
Perl script to benchmark a MySQL or MariaDB database.

## Requisite
Database named "benchmark". Provided user must have access to SELECT, UPDATE, DELETE on the test database.

## How to run
./benchmark.pl -H <host> -u <user> -p <password> -c <count> [-vdh]

Options:
    -h for help
    -H <host> for the host where the database is located
    -u <user> for the dayabase user
    -p <password> the password for the database user
    -c <count> how many tests should be run in each section
    -v for verbose
    -d for debug

