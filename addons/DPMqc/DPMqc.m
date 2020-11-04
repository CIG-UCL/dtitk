function DPMqc(reg_subj_list, DPM_lists, labels_list, fsl_path, do_sumStatPlot)
% 
% DPMqc(reg_subj_list, DPM_lists, labels_list, fsl_path, do_sumStatPlot)
% 
% Reports mean diffusion parameters in JHU white matter atlas ROIs for each
% subject.
% 
% Inputs:
%
% reg_subj_list: list of absolute paths to diffusion-derived parameter maps
% (DPM) to be used as registration targets for the JHU image
%
% DPM_lists: 1xn cells. In each cell the name of a file for each DPM which
% needs to be analysed. Each of this files should be constructed as 
% reg_subj_list]
%
% labels_list: [optional] textfile in which are listed the ROI labels in which
% to analyse mean values. The ROI labels are natural numbers from 1
% to 48. See "$FSLDIR/data/atlases/JHU-labels.xml". If empty, default ROIs
% are used.
%
% fsl_path: [optional] specify the path to fsl directory
%
% do_sumStatPlot: 0 if you don't want summary statistic plots.
%
% Outputs:
%
% One text file for each DPM list, containing an array of the mean 
% parameters for each label and each subject. Rows are subjects and columns
% are labels.
% 
% Authors:
% Michele Guerreri (michele.guerreri@gmail.com)
% Christopher Parker
% Gary Hui Zhang

nDPM = length(DPM_lists);
img_format = '-png'; % change this if needed

% Setup
setupBashVars(fsl_path,[]);
% Run the registration
DPMqc1_registration(reg_subj_list, fsl_path);
% Apply warping
DPMqc2_applyWarp('def_field_list.txt', reg_subj_list, fsl_path);
% Get results
for dpm = 1:nDPM
    DPMqc3_computeMeans(DPM_lists{dpm} , 'wrpd_labl_list.txt', labels_list);
    if ~exist('do_sumStatPlot', 'var') || do_sumStatPlot
        [~, mean_param_tmp_name] = fileparts(DPM_lists{dpm}); 
        DPMqc4_plotSumStats(sprintf('%s_mean_par.txt', mean_param_tmp_name), [], labels_list, [], img_format);
    end
end
