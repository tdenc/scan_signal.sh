#!/bin/bash

# set -x # echo excuted commands

[[ -z $RECPT1 ]] && RECPT1=recpt1
[[ -z $EPGDUMP ]] && EPGDUMP=epgdump

SCAN_CHANNELS="`seq 13 63`"
SCAN_TIME=5
TMP_TS=tmp.ts

scan_all(){
    for ch in $SCAN_CHANNELS
    do
        scan $ch
    done
}

scan(){
    echo === $1 ch ===
    if $RECPT1 --b25 --strip $1 $SCAN_TIME $TMP_TS 2>&1 | grep '^C/N ='
    then
        which $EPGDUMP >/dev/null && \
            ($EPGDUMP $1 $TMP_TS - \
             | sed --quiet 's/.*>\(.\+\)<\/display-name>/\* \1/p')
        rm $TMP_TS
    fi
}

which $EPGDUMP >/dev/null || \
    echo "警告: epgdump($EPGDUMP) が見つかりません。チャンネル名を表示しません。"

if [[ -n $1 ]]
then scan $1
else scan_all
fi
