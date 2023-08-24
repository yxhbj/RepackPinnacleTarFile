#!/bin/sh
SRCFILE=$1
DSTFOLDER=$2
# initialize dd command
CMD_DD="dd if=$SRCFILE bs=20k count=25"
# read files in from source
OUTPUT=`                  $CMD_DD | gtar -x -f - -C $DSTFOLDER Institution 2>&1`
STATUS=$?
# if read failed
if [ $STATUS -ne 0 -a -n "$OUTPUT" ]; then
    # if file was not in tar format
        `echo \"$OUTPUT\" | grep 'not look like a tar'`
    if [ -n "`echo \"$OUTPUT\" | grep 'not look like a tar'`" ]; then
        STATUS=3
    fi
    if [ -n "`echo \"$OUTPUT\" | grep 'Archive is compressed'`" ]; then

        # try reading with compression
        OUTPUT=`                  $CMD_DD | gtar -z -x -f - -C $DSTFOLDER Institution 2>&1`
        STATUS=1

        # set error status if gzip error (gnutar does not pass status up)
        if [ -n "`echo \"$OUTPUT\" | grep 'not in gzip format'`" ]; then
            STATUS=3
        fi
    fi

    # if read still failed
    if [ $STATUS -ne 0 -o -n "$OUTPUT" ]; then
        if [ -n "`echo $OUTPUT | grep 'ot found'`" ]; then
            STATUS=3
        fi
    fi
fi
echo $STATUS
# read succeeded
return $STATUS
