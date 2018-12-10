#!/bin/bash

echo "Cleaning all generated erlang files..."
for file in $(ls *.erl) $(ls *.MD)
do
	echo "removing $file"
	rm $file
done
echo "Now is clean"
exit 0

