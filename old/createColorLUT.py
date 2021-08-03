#!/usr/bin/env python3

import json
import pandas as pd
import numpy as np

def createColorLUT(keyfile,outfile):
	
	# load key.txt file from parcellation datatype
	df = pd.read_json(keyfile)

	# extract relevant data
	df = df[['voxel_value','name']]

	# rename the columns to freesurfer format
	df = df.rename(columns={'voxel_value': '#No.','name': 'Label Name:'})

	# generate red, green, blue and alpha values
	df['R'] = [np.random.random_integers(0,255,size=1).tolist()[0] for f in range(len(df['#No.']))]
	df['G'] = [np.random.random_integers(0,255,size=1).tolist()[0] for f in range(len(df['#No.']))]
	df['B'] = [np.random.random_integers(0,255,size=1).tolist()[0] for f in range(len(df['#No.']))]
	df['A'] = [0 for f in range(len(df['#No.']))]

	# write out colorlut file
	df.to_csv(outfile,sep='\t',index=False)

def main():

	# load config
	with open('config.json','r') as config_f:
		config = json.load(config_f)

	# parcellation key file
	labelfile = config['label']

	# outfile for color lut
	outfile = 'lut.txt'

	# create color lut
	createColorLUT(labelfile,outfile)

if __name__ == '__main__':
	main()
