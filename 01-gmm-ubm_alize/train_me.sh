#!/bin/bash
# $1 -> user_name (without space)

cp ./data/$1_* ./wav/.
# ./train.sh ./wav/${1}_1.wav ./wav/${1}_2.wav ./wav/${1}_3.wav $1

./train.sh ${1}_1 ${1}_2 ${1}_3 $1


