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

# identify measures
tmp_measures = [ f.split('_')[0] for f in glob.glob("*_cols.txt") ]
diff_measures = np.sort([ f for f in tmp_measures if f != 'thickness' ]).tolist()

# set up variables and parc_data dataframe
data_columns = ['parcID','subjectID','structureID','nodeID','number_of_voxels','volume','thickness','thickness_std']+diff_measures
parc_data = pd.DataFrame([],columns=data_columns)

# extract data column headers
file_data_columns = open('./thickness_cols.txt').read().split('#')[1].strip().split()[2:]

# load thickness csv
measures = pd.read_csv(('./thickness.csv'),header=None,names=file_data_columns)

# clean up to follow bl format
parc_data['structureID'] = measures['StructName']
parc_data['subjectID'] = [ subjectID for f in range(len(parc_data['structureID'])) ]
parc_data['nodeID'] = [ 1 for f in range(len(parc_data['structureID'])) ]
parc_data['parcID'] = measures['SegId']
parc_data['number_of_voxels'] =  measures['NVoxels']
parc_data['volume'] = measures['Volume_mm3']
parc_data['thickness'] = measures['Mean']
parc_data['thickness_std'] = measures['StdDev']

for dms in diff_measures:
    tmp_data_columns = open('./'+dms+'_cols.txt').read().split('#')[1].strip().split()[2:]
    tmpdata = pd.read_csv('./'+dms+'.csv',header=None,names=tmp_data_columns)
    parc_data[dms] = tmpdata['Mean']

# output to csv
parc_data.to_csv('./parc-stats/parc_nodes.csv',index=False)