#! /bin/bash
# Script to run the benchmark script multiple times, with different inupt

TYPE=$1
OUTPUT=output.txt
SIMULATE=''
ITER='100 500 1000'
COMMAND='./benchmark.pl -u root -p toor'
ITERO='1 2 3 4 5'
# Run the script three times on each level
# Levels: 100, 500, 1000, 5000, 10000
# Important: append, not overwrite

for i in $ITER; do
    for j in $ITERO; do
        $SIMULATE$COMMAND -t $TYPE -c $i -o >> $OUTPUT
        #./benchmark.pl -t $TYPE -u $DBUSER -p $DBPASS -o -c $i >> $OUTPUT
    done
done
