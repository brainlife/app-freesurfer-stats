#!/bin/bash
module load matlab/2019a

mkdir compiled

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/vistasoft'))
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/brlife/git/wma_tools'))
mcc -m -R -nodisplay -d compiled parcRoiStats
exit
END
matlab -nodisplay -nosplash -r build
