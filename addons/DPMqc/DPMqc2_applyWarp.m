function DPMqc2_applyWarp(def_field_list, targ_list, fsl_path)
% 
% DPMqc2_applyWarp(def_field_list, targ_list, fsl_path)
% 
% Applies the warping to bring the labels from JHU space into each subject 
% native space.
% 
% Inputs:
% def_field_list: A list of paths to the deformation field output of the 
%                 non-linear registration process in DPMqc1_reg.
% targ_list: list of absolute paths to diffusion-derived parameter maps (DPM)
% fsl_path: [optional] specify the path to fsl directory
%
% Outputs:
% A text file with a list of paths to the warped labels named 
% wrpd_labl_list.txt, it is saved in the current folder.
% 
% Authors:
% Michele Guerreri (michele.guerreri@gmail.com)
% Christopher Parker
% Gary Hui Zhang

%% Set the stage

if nargin < 3 || isempty(fsl_path)
    % Check if the freesurfer directory is set correctly
    fsl_path = getenv('FSLDIR');
    if isempty(fsl_path)
        error('FSL environment variable $FSLDIR not set properly')
    end
end
% define the path to labels in JHU 2mm space.
jhu_labels = fullfile(fsl_path, 'data/atlases/JHU/JHU-ICBM-labels-2mm.nii.gz');
% open the input file
fid_deffild = fopen(def_field_list, 'r');
fid_targ = fopen(targ_list, 'r');
% open the output file 
fid_out = fopen('wrpd_labl_list.txt', 'w+');
% Loop over all the lines of the file
while true
    % assigne the content of each line to an input variable
    appwarp_in = fgetl(fid_deffild); % in warp
    targ_in = fgetl(fid_targ); % in volume
    if ~ischar(appwarp_in); break; end  %end of file
    % based on the input path define an output path for the warped labels
    [targ_in_path, targ_in_name] = fileparts(targ_in);
    [~, targ_in_name] = fileparts(targ_in_name); % twice to make sure .nii.gz are gone
    % define the output
    appwarp_out = fullfile(targ_in_path, sprintf('JHU_labels_to_%s.nii.gz', targ_in_name));
    % apply the warp
    appwarp_cmd = sprintf('applywarp --ref=%s --in=%s --warp=%s --out=%s --interp=nn', ...
        targ_in, jhu_labels, appwarp_in, appwarp_out);
    fprintf('%s\n',appwarp_cmd);
    %system(['bash --login -c ''' appwarp_cmd ''''],'-echo');
    system(appwarp_cmd, '-echo');
    % write the path of the warped labels into the output text file
    fprintf(fid_out, '%s\n', appwarp_out);
    % also produce a png file to check the quality of the registration for
    reg_qc_output = fullfile(targ_in_path, sprintf('JHU_labels_to_%s', targ_in_name));
    reg_qc(targ_in, appwarp_out, reg_qc_output); 
end
% close files
fclose(fid_deffild);
fclose(fid_targ);
fclose(fid_out);

end

function [] = reg_qc(targ_in, appwarp_out, reg_qc_output)
    % Takes in input the target volume of the registration and the
    % registred labels. Outputs a png file to check the quality of the
    % registration
    %
    
    % 1. The labels need to be binarized
    % define the output
    [bin_out_path, ~, ~] = fileparts(appwarp_out);
    bin_out = fullfile(bin_out_path, 'tmp_bin.nii.gz');
    % define and run the command
    bin_cmd = sprintf('fslmaths %s -bin %s', ...
                appwarp_out, bin_out);
    fprintf('%s\n', bin_cmd);
    %system(['bash --login -c ''' bin_cmd ''''],'-echo');
    system(bin_cmd,'-echo');
    % 2 Create the image
    slices_cmd = sprintf('slices %s %s -s 3 -i 0 1 -o %s', ...
        targ_in, bin_out, sprintf('%s.gif', reg_qc_output));
    fprintf('%s\n', slices_cmd);
    %system(['bash --login -c ''' slices_cmd ''''],'-echo');
    system(slices_cmd,'-echo');
    % Convert it from gif into png
    cnvrt_cmd = sprintf('convert %s %s', ...
        sprintf('%s.gif', reg_qc_output), sprintf('%s.png', reg_qc_output));
    fprintf('%s\n', cnvrt_cmd);
    %system(['bash --login -c ''' cnvrt_cmd ''''],'-echo');
    system(cnvrt_cmd,'-echo');
    % Remove extra files
    rm_cmd = sprintf('rm %s %s', ...
        sprintf('%s.gif', reg_qc_output), bin_out);
    fprintf('%s\n', rm_cmd);
    %system(['bash --login -c ''' rm_cmd ''''],'-echo');
    system(rm_cmd,'-echo');
end







