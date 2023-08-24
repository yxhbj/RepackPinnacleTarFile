#!/bin/bash
files=`find $1 -type f -name "*.tar"  -print0`
echo ${files}
for name in "$files"
do
if [ -n "$name" ]; then
perl rePackPinnBkp.pl $name /tmp $2
fi
done