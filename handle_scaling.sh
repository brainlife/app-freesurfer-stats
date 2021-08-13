#!/bin/bash

set -x
set -e

ad=`jq -r '.ad' config.json`
fa=`jq -r '.fa' config.json`
md=`jq -r '.md' config.json`
rd=`jq -r '.rd' config.json`
ga=`jq -r '.ga' config.json`
ak=`jq -r '.ak' config.json`
mk=`jq -r '.mk' config.json`
rk=`jq -r '.rk' config.json`
ndi=`jq -r '.ndi' config.json`
isovf=`jq -r '.isovf' config.json`
odi=`jq -r '.odi' config.json`
myelin=`jq -r '.myelin' config.json`
T1=`jq -r '.T1' config.json`
R1=`jq -r '.R1' config.json`
M0=`jq -r '.M0' config.json`
PD=`jq -r '.PD' config.json`
MTV=`jq -r '.MTV' config.json`
VIP=`jq -r '.VIP' config.json`
SIR=`jq -r '.SIR' config.json`
WF=`jq -r '.WF' config.json`

mkdir -p tmp

qmri="T1 R1 M0 PD MTV VIP SIR WF"

# set metrics for every situation
echo "parsing input diffusion metrics"
if [[ $fa == "null" ]];
then
	METRIC="ndi isovf odi"
elif [[ $ndi == "null" ]] && [ ! -f $ga ]; then
	METRIC="ad fa md rd"
elif [[ $ndi == "null" ]] && [ -f $ga ]; then
	METRIC="ad fa md rd ga ak mk rk"
elif [ -f $fa ] && [ -f $ndi ] && [ ! -f $ga ]; then
	METRIC="ad fa md rd ndi isovf odi"
else
	METRIC="ad fa md rd ga ak mk rk ndi isovf odi"
fi
echo "input diffusion metrics set"

if [[ ! $myelin == "null" ]]; then
	METRIC=$METRIC" myelin"
fi

if [[ ! $T1 == "null" ]]; then
for i in ${qmri}
	do
		met_tmp=$(eval "echo \$${i}")
		if [ -f ${met_tmp} ]; then
			METRIC=$METRIC" ${i}"
		fi
	done
fi

test_mets="ad md rd"
#### loop through metrics and generate stats text files ####
for MET in ${METRIC}
do
	metric=$(eval "echo \$${MET}")
	if [[ ${test_mets[*]} =~ "${MET}" ]]; then 
		if [ ! -f ${MET}.nii.gz ]; then
			# handle scaling issues
			median_val=$(eval "fslstats ${metric} -P 50")
			if [[ $median_val < 0.01 ]]; then 
				fslmaths ${metric} -mul 1000 ./${MET}.nii.gz
				metric="./${MET}.nii.gz"
			else
				cp ${metric} ./
			fi
		fi
	else
		cp ${metric} ./
	fi
done
