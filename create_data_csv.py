#!/usr/bin/env python3

import csv
import json
import numpy
import glob
import sys
import os
import pandas as pd
import numpy as np

with open('config.json') as config_f:
    config = json.load(config_f)
    subjectID = config['_inputs'][0]['meta']['subject']

if not os.path.exists('parc-stats'):
    os.mkdir('parc-stats')

diffusion_measures = [ f.split('.')[1] for f in os.listdir('./tmp/') if f.split('.')[0] == 'subcort_num' if f.split('.')[2] == 'csv' ]

# set up the way i like
# if all(x in diffusion_measures for x in ['ndi','fa']):
#     diffusion_measures = ['ad','fa','md','rd','ndi','isovf','odi']
# elif 'fa' in diffusion_measures:
#     diffusion_measures = ['ad','fa','md','rd']
# else:
#     diffusion_measures = ['ndi','isovf','odi']

diffusion_measures = np.sort(diffusion_measures).tolist()

data_columns = ['parcID','subjectID','structureID','nodeID','number_of_voxels'] + diffusion_measures + ['volume']

aseg_data = pd.DataFrame([],columns=data_columns)

file_data_columns = open('./tmp/subcort_cols.txt').read().split('#')[1].strip().split()[2:]

for dm in range(len(diffusion_measures)):
    measures = pd.read_csv(('./tmp/subcort_num.%s.csv' %diffusion_measures[dm]),header=None,names=file_data_columns)
    if dm == 0:
        aseg_data['structureID'] = measures['StructName']
        aseg_data['subjectID'] = [ subjectID for f in range(len(aseg_data['structureID'])) ]
        aseg_data['nodeID'] = [ 1 for f in range(len(aseg_data['structureID'])) ]
        aseg_data['parcID'] = measures['SegId']
        aseg_data['number_of_voxels'] =  measures['NVoxels']
        aseg_data['volume'] = measures['Volume_mm3']

    aseg_data[diffusion_measures[dm]] = measures['Mean']

aseg_data.to_csv('./parc-stats/aseg_nodes.csv',index=False)


