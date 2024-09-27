#!/usr/bin/env python3

import csv
import json
import numpy
import glob
import sys
import os
import pandas as pd
from freesurfer_stats import CorticalParcellationStats

def extract_wholebrain_stats(input_data_lines,version):
    if version == 'v5':
        tissueName = 'Cortical'
        tissueNameLower = 'cortical'
    else:
        tissueName = 'Cerebral'
        tissueNameLower = 'cerebral'

    lines_var = input_data_lines.readlines()
    dataStructure = {}

    for tissues in ['gm','wm']:
        if tissues == 'gm':
            name = 'CortexVol'
            total_name = 'Total cortical gray matter volume'
        else:
            name = tissueName+'WhiteMatter'
            total_name = 'Total '+tissueNameLower+' white matter volume'

        dataStructure[tissues] = {}
        dataStructure[tissues]['lh_volume'] = float(lines_var[lines_var.index([ f for f in lines_var if 'lh'+name in f ][0])].replace(',','').split()[10])
        dataStructure[tissues]['rh_volume'] = float(lines_var[lines_var.index([ f for f in lines_var if 'rh'+name in f ][0])].replace(',','').split()[10])
        dataStructure[tissues]['total_volume'] = float(lines_var[lines_var.index([ f for f in lines_var if total_name in f ][0])].replace(',','').split()[9])
    
    dataStructure['brain'] = {}
    dataStructure['brain']['total_volume'] = float(lines_var[lines_var.index([ f for f in lines_var if 'BrainSegVol' in f ][0])].replace(',','').split()[7])
    dataStructure['brain']['total_intracranial_volume'] = float(lines_var[lines_var.index([ f for f in lines_var if 'EstimatedTotalIntraCranialVol' in f ][0])].replace(',','').split()[8])

    return dataStructure

def extract_subcortical_stats(input_data_lines,version,subjectID):

    lines_var = input_data_lines.readlines()
    subcort_data = [ f for f in lines_var if '#' not in f ]

    outdata = pd.DataFrame(columns={'segID','subjectID','structureID', 'nodeID', 'number_of_voxels', 'gray_matter_volume_mm^3'})
    outdata['segID'] = [ f.split()[1] for f in subcort_data ]
    outdata['structureID'] = [ f.split()[4] for f in subcort_data ]
    outdata['subjectID'] = [ subjectID for f in range(len(outdata['structureID'])) ]
    outdata['nodeID'] = [ 1 for f in range(len(outdata['structureID'])) ]
    outdata['number_of_voxels'] = [ f.split()[2] for f in subcort_data ]
    outdata['gray_matter_volume_mm^3'] = [ f.split()[3] for f in subcort_data ]

    outdata = outdata.reindex(columns=['segID','subjectID','structureID', 'nodeID', 'number_of_voxels', 'gray_matter_volume_mm^3'])

    return outdata

def create_wholebrain_csv(wb_data,lh_data,rh_data,subjectID):
    whole_brain = pd.DataFrame([],dtype=object)
    whole_brain = whole_brain.append({'subjectID': subjectID},ignore_index=True)
    whole_brain.insert(1,"Total_Brain_volume",wb_data['brain']['total_volume'],True)
    whole_brain.insert(2,"Total_Intracranial_volume",wb_data['brain']['total_intracranial_volume'],True)
    whole_brain.insert(3,"Total_Gray_Matter_volume",wb_data['gm']['total_volume'],True)
    whole_brain.insert(4,"Total_White_Matter_volume",wb_data['wm']['total_volume'],True)
    whole_brain.insert(5,"Left_Hemisphere_Gray_Matter_volume",wb_data['gm']['lh_volume'],True)
    whole_brain.insert(6,"Right_Hemisphere_Gray_Matter_volume",wb_data['gm']['rh_volume'],True)
    whole_brain.insert(7,"Left_Hemisphere_White_Matter_volume",wb_data['wm']['lh_volume'],True)
    whole_brain.insert(8,"Right_Hemisphere_White_Matter_volume",wb_data['wm']['rh_volume'],True)
    whole_brain.insert(9,"Left_Hemisphere_Mean_Gray_Matter_thickness",lh_data.whole_brain_measurements['mean_thickness_mm'],True)
    whole_brain.insert(10,"Right_Hemisphere_Mean_Gray_Matter_thickness",rh_data.whole_brain_measurements['mean_thickness_mm'],True)

    return whole_brain

with open('config.json') as config_f:
    config = json.load(config_f)
    output_dir = config["freesurfer"]
    parc = config["parcellation"]
    subjectID = config['_inputs'][0]['meta']['subject']
    fsurf_tags = config['_inputs'][0]['tags']

# set flag if freesurfer version is v5
if 'v5' in fsurf_tags:
    fsurf_version = 'v5'
else:
    fsurf_version = 'v6+'

# left hemisphere
lh_stats = CorticalParcellationStats.read(output_dir+'/stats/lh.'+parc+'.stats')
dfl = lh_stats.structural_measurements
dfl.rename(columns={'structure_name': 'structureID'},inplace=True)
dfl['structureID'] = [ 'lh_'+dfl['structureID'][f] for f in range(len(dfl['structureID'])) ]
dfl['subjectID'] = [ subjectID for x in range(len(dfl['structureID'])) ]
dfl['parcID'] = [ f+1 for f in range(len(dfl['structureID']))]
dfl['nodeID'] = [ int(1) for f in range(len(dfl['structureID'])) ]
dfl = dfl.reindex(columns=['parcID','subjectID','structureID','nodeID','number_of_vertices', 'surface_area_mm^2','gray_matter_volume_mm^3', 'average_thickness_mm','thickness_stddev_mm', 'integrated_rectified_mean_curvature_mm^-1','integrated_rectified_gaussian_curvature_mm^-2', 'folding_index','intrinsic_curvature_index'])
dfl.to_csv('lh.cortex.csv',index=False)

# right hemisphere
rh_stats = CorticalParcellationStats.read(output_dir+'/stats/rh.'+parc+'.stats')
dfr = rh_stats.structural_measurements
dfr.rename(columns={'structure_name': 'structureID'},inplace=True)
dfr['structureID'] = [ 'rh_'+dfr['structureID'][f] for f in range(len(dfr['structureID'])) ]
dfr['subjectID'] = [ subjectID for x in range(len(dfr['structureID'])) ]
dfr['parcID'] = [ f+1 for f in range(len(dfr['structureID']))]
dfr['nodeID'] = [ int(1) for f in range(len(dfr['structureID'])) ]
dfr = dfr.reindex(columns=['parcID','subjectID','structureID','nodeID','number_of_vertices', 'surface_area_mm^2','gray_matter_volume_mm^3', 'average_thickness_mm','thickness_stddev_mm', 'integrated_rectified_mean_curvature_mm^-1','integrated_rectified_gaussian_curvature_mm^-2', 'folding_index','intrinsic_curvature_index'])
dfr.to_csv('rh.cortex.csv',index=False)

# concat left and righ hemispheres
dft = pd.concat([dfl,dfr],ignore_index=True)
dft.to_csv('cortex.csv',index=False)

# whole brain
wholebrain = open(output_dir+'/stats/aseg.stats')
wholebrain_data = extract_wholebrain_stats(wholebrain,fsurf_version)
whole_brain = create_wholebrain_csv(wholebrain_data,lh_stats,rh_stats,subjectID)
whole_brain.to_csv('whole_brain.csv',index=False)

# subcortical stats
wholebrain = open(output_dir+'/stats/aseg.stats')
subcortical = extract_subcortical_stats(wholebrain,fsurf_version,subjectID)
subcortical.to_csv('subcortical.csv',index=False)

# append subject ID to data with coordinates from dan's code
rois = pd.read_csv('rois.csv')
rois['subjectID'] = [ subjectID for x in range(len(rois['ROI_name'])) ]
rois = rois[ ['subjectID'] +  [ f for f in rois.columns if f != 'subjectID']] 
rois.to_csv('rois.csv',index=False)
