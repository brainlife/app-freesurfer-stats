#!/bin/bash

freesurfer=`jq -r '.freesurfer' config.json`
parc=`jq -r '.parcellation' config.json`
# ad=`jq -r '.ad' config.json`
# fa=`jq -r '.fa' config.json`
# md=`jq -r '.md' config.json`
# rd=`jq -r '.rd' config.json`
# ga=`jq -r '.ga' config.json`
# ak=`jq -r '.ak' config.json`
# mk=`jq -r '.mk' config.json`
# rk=`jq -r '.rk' config.json`
# ndi=`jq -r '.ndi' config.json`
# isovf=`jq -r '.isovf' config.json`
# odi=`jq -r '.odi' config.json`
# myelin=`jq -r '.myelin' config.json`

# mkdir -p tmp

# # set metrics for every situation
# echo "parsing input diffusion metrics"
# if [[ $fa == "null" ]];
# then
# 	METRIC="ndi isovf odi"
# elif [[ $ndi == "null" ]] && [ ! -f $ga ]; then
# 	METRIC="ad fa md rd"
# elif [[ $ndi == "null" ]] && [ -f $ga ]; then
# 	METRIC="ad fa md rd ga ak mk rk"
# elif [ -f $fa ] && [ -f $ndi ] && [ ! -f $ga ]; then
# 	METRIC="ad fa md rd ndi isovf odi"
# else
# 	METRIC="ad fa md rd ga ak mk rk ndi isovf odi"
# fi
# echo "input diffusion metrics set"

# if [[ ! $myelin == "null" ]]; then
# 	METRIC=$METRIC+" myelin"
# fi

METRIC=(`ls *.nii.gz`)

# copy freesurfer directory
[ ! -d ./output/ ] && mkdir output && cp -R ${freesurfer}/* ./output/ && chmod -R +rw ./output

# copy parcellation
[ ! -d ./parc.nii.gz ] && cp ${parc} ./output/mri/parc.nii.gz && chmod +rw ./output/mri/parc.nii.gz

export SUBJECTS_DIR=./

# move parc into ribbon space
[ ! -f ./parc.nii.gz ] && mri_vol2vol --mov ./output/mri/parc.nii.gz --targ ./output/mri/ribbon.mgz --regheader --interp nearest --o ./output/mri/parc.nii.gz

# convert thickness to volume
[ ! -f ./thickness.nii.gz ] && mri_surf2vol --o ./thickness.nii.gz --subject output --so ./output/surf/lh.white ./output/surf/lh.thickness --so ./output/surf/rh.white ./output/surf/rh.thickness --ribbon ./output/mri/ribbon.mgz

# compute stats within parcellation
[ ! -f ./thickness.sum ] && mri_segstats --seg ./output/mri/parc.nii.gz --ctab ./lut.txt --i ./thickness.nii.gz --sum ./thickness.sum

# make stats file cleaner
[ ! -f ./thickness.txt ] && tail ./thickness.sum -n +54 > ./thickness.txt
[ ! -f ./thickness.csv ] && awk '{print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' ./thickness.txt > ./thickness_num.txt && sed 's/ *$//' ./thickness_num.txt > ./thickness_num_nospace.txt && sed 's/ \+/,/g' ./thickness_num_nospace.txt > ./thickness.csv

# error check
if [ ! -f ./thickness.csv ]; then
	echo "stats computation failed. check derivatives and error log"
	exit 1
fi

[ ! -f ./thickness_cols.txt ] && tail ./thickness.sum -n +53 > ./tmpdata.txt && head -n 1 ./tmpdata.txt > ./thickness_cols_spaces.txt && sed 's/ *$//' ./thickness_cols_spaces.txt > ./thickness_cols.txt

## compute stats in diffusion metrics
for i in ${METRIC[*]}
do
	if [[ ! "${i}" == *"parc"* ]]; then
		echo ${i}
		met_name=`echo ${i//.nii.gz/}`
		[ ! -f ${met_name}_parc.nii.gz ] && mri_vol2vol --mov ${i} --targ ./output/mri/parc.nii.gz --regheader --interp nearest --o ./${met_name}_parc.nii.gz
		[ ! -f ./${met_name}.sum ] && mri_segstats --seg ./output/mri/parc.nii.gz --ctab ./lut.txt --i ./${met_name}_parc.nii.gz --sum ./${met_name}.sum
		
		# make stats file cleaner
		[ ! -f ./${met_name}.txt ] && tail ./${met_name}.sum -n +54 > ./${met_name}.txt
		[ ! -f ./${met_name}.csv ] && awk '{print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' ./${met_name}.txt > ./${met_name}_num.txt && sed 's/ *$//' ./${met_name}_num.txt > ./${met_name}_num_nospace.txt && sed 's/ \+/,/g' ./${met_name}_num_nospace.txt > ./${met_name}.csv

		# error check
		if [ ! -f ./${met_name}.csv ]; then
			echo "stats computation failed. check derivatives and error log"
			exit 1
		fi

		[ ! -f ./${met_name}_cols.txt ] && tail ./${met_name}.sum -n +53 > ./${met_name}tmpdata.txt && head -n 1 ./${met_name}tmpdata.txt > ./${met_name}_cols_spaces.txt && sed 's/ *$//' ./${met_name}_cols_spaces.txt > ./${met_name}_cols.txt
	fi
done