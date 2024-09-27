function [] = parcRoiStats()

if ~isdeployed
    disp('loading path')

    %for IU HPC
    addpath(genpath('/N/u/brlife/git/vistasoft'))
    addpath(genpath('/N/u/brlife/git/jsonlab'))
    addpath(genpath('/N/u/brlife/git/wma_tools'))

    %for old VM
    addpath(genpath('/usr/local/vistasoft'))
    addpath(genpath('/usr/local/jsonlab'))
    addpath(genpath('/usr/local/wma_tools'))
end

% Set top directory
topdir = pwd;

% Load configuration file
config = loadjson('config.json');

% set path for parcellation
parcellation = fullfile(topdir,sprintf('%s+aseg.nii.gz',config.parcellation));

% run stats code
[parcStats] = bsc_computeAtlasStats_v2(parcellation);

% save stats file
writetable(parcStats,'rois.csv');

exit
end
