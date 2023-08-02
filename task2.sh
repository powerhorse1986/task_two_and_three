#! /bin/bash

# take the input file from command line
INPUT=$1

# count the number of sequences in the file
SEQ=$(zcat $INPUT | grep -c '>')

# count the total number of amino acids
AMINO=$(zcat $INPUT | grep -v '^>' | wc -c)

echo "There are $SEQ sequences"
echo "$AMINO amino acids"
echo "The average length is $(($AMINO/$SEQ))"
