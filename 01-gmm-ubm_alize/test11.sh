#!/bin/bash

name=$(echo $1|cut -d '.' -f1)

# echo $name

ffmpeg -loglevel panic -i wav/$name.wav -ar 16000 -b 16k -ac 1 $name.wav

python ../vad/py-webrtcvad-master/example_1.py 3 $name.wav >> log/tmp.log

bin/HCopy -C cfg/hcopy_sph_75.cfg ${name}.wav_nosil.wav $name.mfc

mv $name.mfc data/prm/

echo $name >data/test$name.lst

bin/NormFeat --config cfg/NormFeat_energy_HTK.cfg --inputFeatureFilename data/test${name}.lst --featureFilesPath data/prm/ >> log/tmp.log

bin/EnergyDetector  --config cfg/EnergyDetector_HTK.cfg --inputFeatureFilename data/test${name}.lst --featureFilesPath data/prm/  --labelFilesPath  data/lbl/ >> log/tmp.log

bin/NormFeat --config cfg/NormFeat_HTK.cfg --inputFeatureFilename data/test${name}.lst --featureFilesPath  data/prm/   --labelFilesPath  data/lbl/ >> log/tmp.log

sed -e "s/test.ndx/test_${name}.ndx/g" cfg/ComputeTest_GMM.cfg | sed -e "s/target-seg_gmm.res/target-seg_gmm.res_${name}.res/g" > cfg/test_$name.cfg

ls gmm/ | grep -v world|sed "s/^/${name} /" >ndx/test_${name}.ndx

bin/ComputeTest --config cfg/test_$name.cfg >> log/tmp.log

rm data/prm/$name* data/lbl/$name* wav/$name* ndx/test_${name}.ndx cfg/test_$name.cfg ${name}.wav_nosil.wav

mv $name.wav speech/$(date +%F-%H:%M).wav

python compare_voice.py res/target-seg_gmm.res_${name}.res>>AUTHENTICATION_LOG.TXT
python compare_voice1.py res/target-seg_gmm.res_${name}.res
