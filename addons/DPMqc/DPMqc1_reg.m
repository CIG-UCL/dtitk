function DPMqc1_reg(subj_list, fsl_path)
% 
% DPMqc1_reg(subj_list, fsl_path)
% 
% Performs non-linear registration between each of the diffusion derived
% parameter maps listed in subj_list and the JHU FA map available in FSL.
% 
% Inputs:
% subj_list: list of absolute paths to diffusion-derived parameter maps (DPM)
% fsl_path: [optional] specify the path to fsl directory
%
% Outputs:
% A list of paths to the deformation field output of the registration
% process named "def_field_list.txt" is saved in the current folder
% 
% Authors:
% Michele Guerreri (michele.guerreri@gmail.com)
% Christopher Parker
% Gary Hui Zhang

%% Set the stage

if nargin < 2
    % Check if the freesurfer directory is set correctly
    fsl_path = getenv('FSLDIR');
    if isempty(fsl_path)
        error('FSL environment variable $FSLDIR not set properly')
    end
end
% define the path to target map, JHU FA map 2mm.
jhu = fullfile(fsl_path, 'data/atlases/JHU/JHU-ICBM-FA-2mm.nii.gz');
% open the input file
fid_in = fopen(subj_list, 'r');
% open the output file 
fid_out = fopen('def_field_list.txt', 'w+');
% Loop over all the lines of the file
while true
    % assigne the content of each line to an input variable
    fnirt_in = fgetl(fid_in);
    if ~ischar(fnirt_in); break; end  %end of file
    % based on the input path define an output path for the deformation field
    [fnirt_in_path, fnirt_in_name] = fileparts(fnirt_in);
    [~, fnirt_in_name] = fileparts(fnirt_in_name); % twice to make sure .nii.gz are gone
    % Define the outputs
    flirt_out = fullfile(fnirt_in_path, sprintf('%s_to_JHU_aff.mat', fnirt_in_name)); %lin reg ouput
    fnirt_out = fullfile(fnirt_in_path, sprintf('%s_to_JHU_warp.nii.gz', fnirt_in_name)); %non-lin reg ouput
    invwarp_out = fullfile(fnirt_in_path, sprintf('JHU_to_%s_warp.nii.gz', fnirt_in_name)); %non-lin reg ouput
    % First run a linear registration
    flirt_cmd = sprintf('flirt -ref %s -in %s -omat %s -v', ...
        jhu, fnirt_in, flirt_out);
    fprintf('%s\n',flirt_cmd);
    %system(['bash --login -c ''' flirt_cmd ''''],'-echo');
    %system(['/usr/local/fsl/bin/' flirt_cmd ],'-echo');
    system(flirt_cmd, '-echo');
    % Run the non-linear registration
    fnirt_cmd = sprintf('fnirt --ref=%s --in=%s --aff=%s --cout=%s -v', ...
        jhu, fnirt_in, flirt_out, fnirt_out);
    fprintf('%s\n',fnirt_cmd);
    %system(['bash --login -c ''' fnirt_cmd ''''],'-echo');
    %system(['/usr/local/fsl/bin/' fnirt_cmd ],'-echo');
    system(fnirt_cmd, '-echo');
    % invert the deformation field
    invwarp_cmd = sprintf('invwarp --ref=%s --warp=%s --out=%s -v', ...
        fnirt_in, fnirt_out, invwarp_out);
    fprintf('%s\n',invwarp_cmd);
    %system(['bash --login -c ''' invwarp_cmd ''''],'-echo');
    %system(['/usr/local/fsl/bin/' invwarp_cmd ],'-echo');
    system(invwarp_cmd, '-echo');
    % write the path of the deformation field into the output text file
    fprintf(fid_out, '%s\n', invwarp_out);
end
% close files
fclose(fid_in);
fclose(fid_out);

% options for seeing FSLDIR and flirt/fnirt/invwarp:
% 
% 1. source the users bash login scripts for each call to flirt etc e.g.  system(['bash --login -c ''' flirt_cmd ''''],'-echo');
% (implemented)
% (https://stackoverflow.com/questions/3322374/using-bash-shell-inside-matlab/3322489)
% 2. assume and specify a full path to each command e.g.
% /usr/local/fsl/bin/flirt etc.
% 3. have a setup .m file which sets the FSLDIR etc. for this matlab sesssion
% (https://uk.mathworks.com/matlabcentral/answers/850-matlab-environment-variables)

