#!/bin/bash
find $1 -type f -name "*.tar" >tmpfile
while read file; do
    echo $file
if [ -n "$file" ]; then
perl rePackPinnBkp.pl $file /tmp $2
fi
done <tmpfile
rm -f tmpfile
rm -rf Institution*
# if [ $# -ne 2 ]
#   then
#     echo "No input arguments exist"
#     exit 1
# else
#     echo "The number of input arguments passed:"
#     echo $#
# fi