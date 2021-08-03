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
subjectID = config.x0x5F_inputs{1}.meta.subject

% set path for parcellation
parcellation = fullfile(config.parcellation);

% run stats code
[parcStats] = bsc_computeAtlasStats_v2(parcellation);

% append subjectID
for ii = 1:length(parcStats.actual_vol)
    parcStats.subjectID(ii) = string(subjectID);
end

% save stats file
writetable(parcStats,'rois.csv');

exit
end
