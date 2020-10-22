function DPMqc3_meanParams(param_list, wrpd_labls_list, labels)
% 
% DPMqc3_meanParams(param_list, wrpd_labls_list, labels)
% 
% Calculates the mean diffusion map parameter value for each label and each
% subject.
% 
% Inputs:
% param_list: A list of paths to diffusion-derived parameter maps in which
% to analyse mean values for each label
% wrpd_labls_list: list of paths to warp field of the transformation from JHU to target space
% labels: [optional] list of ROI labels in which to analyse mean values
%
% Outputs:
% A text file containing an array of the mean parameters for each label and
% each subject. Rows are subjects and columns are labels.
% 
% Auhtors:
% Michele Guerreri (michele.guerreri@gmail.com)
% Chris Parker
% Gary Hui Zhang

%% Set the stage

% check if labels supplied
if ~exist('labels','var')
    labels=[3 4 5 17 18 19 20 33 34 25 26];
end
% 3 GCC Genu-of-corpus-callosum
% 4 BCC Body-of-corpus-callosum
% 5 SCC Splenium-of-corpus-callosum
% 17 ALIC-R Anterior-limb-of-internal-capsule-right
% 18 ALIC-L Anterior-limb-of-internal-capsule-left
% 19 PLIC-R Posterior-limb-of internal capsule-right
% 20 PLIC-L Posterior-limb-of-internal-capsule-left
% 33 EC-R External-capsule-right
% 34 EC-L External-capsule-left

% open the input file
fid_params = fopen(param_list, 'r');
fid_wrpd_labls = fopen(wrpd_labls_list, 'r');
% open the output file 
fid_out = fopen('mean_params.txt', 'w+');
linespec = append(strjoin([repmat("%f",length(labels),1)]),"\n");

% Loop over all the lines of the file
while true
    % assigne the content of each line to an input variable
    param_in = fgetl(fid_params);
    wrpd_labls_in = fgetl(fid_wrpd_labls);
    if ~ischar(param_in); break; end  %end of file
    param_img = load_untouch_nii(param_in);   
    wrpd_labls_img = load_untouch_nii(wrpd_labls_in);
    % calculte mean for each label
    mean_params_subject = NaN(1,numel(labels));
    for i = 1:numel(labels)
        labl = labels(i);
        mean_params_subject(i) = mean(param_img.img(wrpd_labls_img.img == labl));
    end
    % write the means to the output text file
    fprintf(fid_out, linespec, mean_params_subject);
end
% close files
fclose(fid_params);
fclose(fid_wrpd_labls);
fclose(fid_out);




