#!/bin/bash -e
function usage {
    echo "USAGE: $0 <output-dir> <role-file-name> <role_host_name>"
    echo "  example: $0 ./role_list/ network  node123.test.com "
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    usage
    exit 1
fi

OUTDIR="$1"
ROLE_FILE="$2"
ROLE_HOST="$3"

if [ ! -d $OUTDIR ]; then
    echo "ERROR: output directory does not exist:  $OUTDIR"
    exit 1
fi

if [  -f $OUTDIR/$ROLE_FILE ]; then
    rm -rf $OUTDIR/$ROLE_FILE
    touch $OUTDIR/$ROLE_FILE

    echo $ROLE_HOST |awk -F "," '{for(i=0;++i<=NF;)a[i]=a[i]?a[i] FS $i:$i}END{for(i=0;i++<NF;)print a[i]}' >>$OUTDIR/$ROLE_FILE
else
    touch $OUTDIR/$ROLE_FILE
    echo $ROLE_HOST |awk -F "," '{for(i=0;++i<=NF;)a[i]=a[i]?a[i] FS $i:$i}END{for(i=0;i++<NF;)print a[i]}' >>$OUTDIR/$ROLE_FILE
fi
