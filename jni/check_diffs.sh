#!/bin/bash

D1=ffmpeg-0.10.2/;
D2=~/dev/android/_backup_16MAY2012_ffmpeg-0.10.2/;

cd $D1;
FILES=`find .`;
cd -;

for f in $FILES;
do 
    F1=$D1/$f; 
    F2=$D2/$f;

    if [ -d $F1 ];
    then
        continue;
    fi;
    
    if [ -f $F1 ] && [ -f $F2 ]; 
    then 
        if [ "X`diff $F1 $F2`" != "X" ];
        then
            echo "difference: $F1 --- $F2";
        fi;
    else
        echo "MISSING \"$F1\" or \"$F2\"";
    fi;
done;
