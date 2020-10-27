function DPMqc(subj_list, param_list)
% 
% DPMqc(subj_list, param_list)
% 
% Reports mean diffusion parameters in JHU white matter atlas ROIs for each
% subject.
% 
% Inputs:
% subj_list: list of absolute paths to diffusion-derived parameter maps
% (DPM) to be used as registration targets for the JHU image
% param_list: list of absolute paths to parameter maps in which to
% calculate the mean values
%
% Outputs:
% A text file containing an array of the mean parameters for each label and
% each subject. Rows are subjects and columns are labels.
% 
% Authors:
% Michele Guerreri (michele.guerreri@gmail.com)
% Christopher Parker
% Gary Hui Zhang

if nargin < 2
    error('Requires two input text files specifying the subject targets and parameter maps')
elseif length(subj_list) ~= length(param_list)
    error('Inputs do not contain the same number of images')
end

processing_dir = 'DPMqc';
mkdir(processing_dir);
cd(processing_dir)
setupBashVars('/usr/local/fsl','/usr/local');

DPMqc1_reg(subj_list);
DPMqc2_applyWarp('def_field_list.txt', subj_list);
DPMqc3_meanParams(param_list,'wrpd_labl_list.txt');


%- To Do?
% function renaming?
% error/file checking e.g. warp field text file always produced, regardless of reg. errors
% decide FSL variable method
% test on another computer
% readme
% code descriptions - check
% remove notes
% update dependencies to include ImageMagick



