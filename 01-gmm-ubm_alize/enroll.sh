#!/bin/bash

for i in {1..3}; do
	arecord -f S16_LE -D plughw:1 -d 10 -r 16000 data/$1_$i.wav
done

# arecord -f S16_LE -D plughw:1 -d 6 -r 16000 data/Test_4.wav
./train_me.sh $1 
