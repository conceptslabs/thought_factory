#!/bin/bash

#sox wav/$1 -r 16000 -c 1 $1
ffmpeg -loglevel panic -i wav/$1 -ar 16000 -b 16k -ac 1 $1

python ../vad/py-webrtcvad-master/example.py 3 $1 >> log/tmp.log

bin/HCopy -C cfg/hcopy_sph_75.cfg $1_nosil.wav $1.mfc


#sox wav/$2 -r 16000 -c 1 $2
ffmpeg -loglevel panic -i wav/$2 -ar 16000 -b 16k -ac 1 $2

python ../vad/py-webrtcvad-master/example.py 3 $2 >> log/tmp.log

bin/HCopy -C cfg/hcopy_sph_75.cfg $2_nosil.wav $2.mfc


#sox wav/$3 -r 16000 -c 1 $3
ffmpeg -loglevel panic -i wav/$3 -ar 16000 -b 16k -ac 1 $3

python ../vad/py-webrtcvad-master/example.py 3 $3 >> log/tmp.log

bin/HCopy -T 1 -C cfg/hcopy_sph_75.cfg $3_nosil.wav $3.mfc >log/mfcc.log

mv $1.mfc $2.mfc $3.mfc data/prm/

# ls data/prm/$1.mfc

echo $1 > data/train.lst

echo $2 >> data/train.lst

echo $3 >> data/train.lst

bin/NormFeat --config cfg/NormFeat_energy_HTK.cfg --inputFeatureFilename data/train.lst --featureFilesPath data/prm/ >> log/norm1.log

bin/EnergyDetector  --config cfg/EnergyDetector_HTK.cfg --inputFeatureFilename data/train.lst --featureFilesPath data/prm/  --labelFilesPath  data/lbl/ >> log/energy_det.log

bin/NormFeat --config cfg/NormFeat_HTK.cfg --inputFeatureFilename data/train.lst --featureFilesPath  data/prm/   --labelFilesPath  data/lbl/ >> log/norm2.log

echo $4 $1 $2 $3 > ndx/trainModel_$4.ndx 

# cat ndx/trainModel_$4.ndx

sed -e "s/train.ndx/trainModel_${4}.ndx/g" cfg/TrainTarget.cfg  > cfg/train_$4.cfg


bin/TrainTarget --config cfg/train_$4.cfg &> log/TrainTarget.cfg

rm data/prm/$4_* data/lbl/$4_* ndx/trainModel_$4.ndx cfg/train_$4.cfg

# rm $1_nosil.wav $2_nosil.wav $3_nosil.wav

mv $4*.wav speech/

# rm $1_nosil.wav $2_nosil.wav $3_nosil.wav

rm wav/$4_*

if [ -e gmm/$4 ]
then
    echo 1
else
    echo 0
fi

