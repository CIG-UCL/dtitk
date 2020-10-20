function [] = DPMqc(reg_files, param_paths)
%
% function [] = DPMqc(reg_paths_txt_file, diffparams_paths_txt_file, template_option)
% 
% Create a report of the quality of diffusion MRI parameter maps, using white 
% matter ROIs to aid identification of outliers.
%
% Inputs:
% REG_FILES - Path to .txt file listing target images for 
% atlas registration.
% If parameter maps are in a template space the text file contains the 
% filename of the template target image. 
% If the parameter maps are in native space the text file contains a list 
% target images for each dataset. 
% PARAM_PATHS - Path to .txt file listing folders containing 
% diffusion parameter maps.

%
% Outputs:
% - list of subjects mean parameter values for each ROI
% - violin plot of distribution of mean parameter values for each ROI
% across subjects
% - report on the parameter map quality
% 
% Example usage:
% DPMqc('~/mytargetfiles.txt', '~/myparampaths.txt, false)
% where ~/myparampaths.txt might look like this:
% ~/mystudy/subj1/DiffusionMaps
% ~/mystudy/subj2/DiffusionMaps
% ...
% ~/mystudy/subjN/DiffusionMaps
%
% and ~/mytargetfiles.txt might look like this:
% ~/mystudy/subj1/DiffusionMaps/dti_FA.nii.gz
% ~/mystudy/subj2/DiffusionMaps/dti_FA.nii.gz
% ...
% ~/mystudy/subjN/DiffusionMaps/dti_FA.nii.gz

%% Processing folder
mkdir('DPMqc');

%% Options
% is data already registered
if numel(reg_files)==1
    template=true;
else
    template=false;
end

% parameter maps
params={'FIT_ICVF','FIT_ISOVF','FIT_OD'};

% Atlas
atlas_image=['/usr/local/fsl/data/atlases/JHU/JHU-ICBM-FA-1mm.nii.gz'];
atlas_labels=['/usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm'];
roilabels=[3 4 5 17 18 19 20 33 34];

%% Targets and maps
reg_files=readtable(reg_files,'ReadVariableNames',false); 
param_paths=readtable(params_paths,'ReadVariableNames',false); 
nreg=numel(reg_files);
ndata=numel(param_paths);

%% List Registration Pairs
for i=1:nreg
    regpairs{i}{1}=reg_files{i};
    regpairs{i}{2}=atlas_image;
end

%% Register
parfor i=1:nreg
    registerimages(regpairs{i},i);
end

%% Propagate Labels
parfor i=1:nreg
    transformlabels(atlas_labels,regpairs{i},i);
end

%% List Data-ROI Pairs
for i=1:ndata
    dataroipairs{i}{1}=param_paths{i};
    if template
        dataroipairs{i}{2}=['DPMqc/1_lab.nii.gz'];
    else
        dataroipairs{i}{2}=['DPMqc/' i '_lab.nii.gz'];
    end
end

%% Mean parameters in ROIs
for p=params
    for i=1:ndata
        means=meanparaminrois(dataroipairs{i},p,roilabels);
        param_means=[param_means;means];
    end
    writematrix(param_means,['DPMqc/' p '.txt']);
end

% cleanup, error checking, i-indexing, defaults/options file, file
% locations for different parameters

%% Plot

%% Report
