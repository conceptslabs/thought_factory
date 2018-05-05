#!/bin/bash

echo "Please keep talking..."
arecord -f S16_LE -D plughw:1 -d 6 -r 16000 data/Test_4.wav

cp data/Test_4.wav wav/.
./test11.sh Test_4

echo "\n\nComparison scores for reference..."
cat res/target-seg_gmm.res_Test_4.res
