function IntraSubjGrpAlign(path_to_wrkfold, dt_tp_list)
% 
% function IntraSubjGrpAlign(path_to_wrkfold, dt_tp_list)
% 
% This function implements an unbiased approach to align the 
% multiple-timepoint data of a single subject by finding a target space
% that represents the centre of all the timepoints.
% 
% To run this function you should have DTI-TK downloaded
% (https://www.nitrc.org/frs/?group_id=207) and correctly installed
% (http://dti-tk.sourceforge.net/pmwiki/pmwiki.php?n=Documentation.Install)
% 
% INPUTS:
% path_to_wrkfold: absolute path to the folder of the subject you wish to
%                  analyse. This folder is referred to as “working folder”.
%                  Each time point is assumed to be organized in a separate
%                  sub folder.
% 
% dt_tp_list: name of the text file in which each line specifies the
%             relative path from the working folder to each diffusion
%             tensor timepoint (which must be in DTI-TK format).
%             The number of lines in the text file should match the number
%             of time points for that specific subject.
%             The text file should be saved in the folder speficied by
%             "path_to_wrkfold".
%
% OUTPUTS:
% 1. The set of transformations bringing each time point to the target
%    space. The transformations are saved as text files in DTI-TK affine
%    matrix format. The transformations are saved in each time point sub 
%    folder and, by default, the name is set equal to the input diffusion
%    tensor, but with ".aff" extension.
% 
% 2. Each diffusion tensor time point brought into the target space. These
%    files are saved in the same folders as the transformation matrices,
%    with the suffix "_aff.nii.gz".
% 
% 3. Mean of all time point into the target space as well as the main
%    diffusion tensor scalar metrics in that space. These files are saved
%    in an additional subfolder of the working directory named
%    "IntraSubjGrpTemplate".
%
% Authors: Michele Guerreri (m.guerreri@ucl.ac.uk)
%          Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%

%% Define options, inputs and outputs
%% OPTIONS
% These can be modified to match user needs
SM_dt = 'EDS'; % similarity metric for dt registrations
SM_scalar = 'SSD'; % similarity metric for scalar registrations
sep = 4; % separaiton for rgistration (same for x y z)
ftol = 0.001; % tolerance past which the registration stop
n_iter = 5; % number of iterations for template hw template creation


%% Go to working directory
% Store the initial position
starting_folder = pwd;
% Change directory to working directory
cd(path_to_wrkfold)
% add the path to tp list
dt_tp_list = fullfile(path_to_wrkfold, dt_tp_list);


%% INPUTS
% Check the number of time points
% Open tp file
fid = fopen(dt_tp_list,'r');

% Loop over each line of the file
n_tps = 0;
while true
    % Read line by line
    thisline = fgetl(fid);
    if ~ischar(thisline)
        break
    else
        % store number of lines (should match the number of time points)
        n_tps = n_tps + 1;
    end  
end
fclose(fid);

% Varible to store the paths to the time points
path2tps = cell(n_tps,1);




%% OUTPUTS
% Define the output folders:
% folder to store the mean of the registered tp in the target space (central template)
template_folder = 'IntraSubjGrpTemplate';
% If the output folder does not exist create it
if ~exist(template_folder, 'dir')
    mkdir(template_folder)
end

% target space initialization folder
targSpace_init = fullfile(template_folder, 'targSpace_init');
if  ~exist(targSpace_init, 'dir')
    mkdir(targSpace_init)
end
% Folder in which the central template is created
create_template = fullfile(template_folder, 'create_template');
if ~exist(create_template, 'dir')
    mkdir(create_template)
end

% Define a log file
logf = fullfile(path_to_wrkfold, template_folder, 'log.txt');
% Create the log file
logfid = fopen(logf, 'w+');

% Rigid trasformations from each Diff Tensor Time Point (dttp) to the first (step 1)
rigid_dttp_to_tp1 = cell(n_tps-1,1);

% Output from averaging the transformations (step 2)
avrg_transf = fullfile(path_to_wrkfold, targSpace_init, 'avrg_transf');
avrg_rigid_inv = sprintf('%s_inv.aff',avrg_transf); 

% Output from finding the initial transformations to target space (step 3)
rigid_dttp_to_targ_init = cell(n_tps, 1); % rigid transformation form each time point to the initial target space
dttp_to_targ_init = cell(n_tps, 1); % the diffusion tensors after being brought into the target space
dtps_to_targ_list_init = fullfile(path_to_wrkfold, targSpace_init, 'dttps_to_targ_list.txt'); % list of registered volume names to create initial guess of the template
orig_abs_path_list = fullfile(path_to_wrkfold, create_template, 'orig_abs_path_list.txt'); % list of original dt timepoints but with absolute path (for scalar population)

% The initial guess of the central template (Step 4)
initial_template = fullfile(path_to_wrkfold, targSpace_init, 'initial.nii.gz');

% Output from finding the DT central template (step 6)
rigid_dttp_to_targ = cell(n_tps, 1); % rigid transformation form each time point to the target space
dttp_to_targ = cell(n_tps, 1); % the diffusion tensors after being brought into the target space
%dtps_to_targ_list = fullfile(path_to_wrkfold,affine, 'dttps_to_targ_list.txt'); % list of registered volume names to create initial guess of the template

% Final output: mean dt, fa map and md map into the target "central" space (step 7)
targ_dt_template = fullfile(path_to_wrkfold, template_folder, 'dt_template.nii.gz');
targ_fa_template = fullfile(path_to_wrkfold, template_folder, 'dt_fa_template.nii.gz');
targ_md_template = fullfile(path_to_wrkfold, template_folder, 'dt_md_template.nii.gz');

%% Step 1: Register all time points to time point 1

% Loop again over the file lines to save the paths
% Register all time points to tp1
fid = fopen(dt_tp_list,'r');
for tp = 1:n_tps
    path2tps{tp} = fullfile(path_to_wrkfold, fgetl(fid));
    if tp ~= 1
        % Define the name of the output registration
        rigid_dttp_to_tp1{tp-1} = fullfile(targSpace_init, sprintf('rigid_dt_tp%d_to_tp1.aff', tp));
        % Define the registration command and run it
        rigid_dt_cmd1 = sprintf('rtvCGM -SMOption %s -template %s -subject %s -sep %d %d %d -ftol %f -outTrans %s', ...
            SM_dt, path2tps{1}, path2tps{tp}, sep, sep, sep, ftol, rigid_dttp_to_tp1{tp-1});
        run_cmd(rigid_dt_cmd1, logfid);
    end
end
fclose(fid);

%% Step 2: Compute the average transformation from the above ones

compute_avrg_transf(rigid_dttp_to_tp1, avrg_transf)
% Write this command into the logfile
fprintf(logfid,'compute_avrg_transf(rigid_dttp_to_tp1, avrg_transf)');

%% Step 3: Compute the initial transformations to the halfway space for each time point and apply them.


% Loop over all volumes
for tp = 1:n_tps
    % Define the output names
    rigid_dttp_to_targ_init{tp} = fullfile(path_to_wrkfold, targSpace_init, sprintf('rigid_tp%d_to_targ.aff', tp));
    dttp_to_targ_init{tp} = fullfile(path_to_wrkfold, targSpace_init, sprintf('dttp%d_to_targ.nii.gz', tp));
    if tp == 1 % if tp 1, then the transformation matrix to hw space is the inverse of the average
        cp_inv_cmd = sprintf('cp %s %s',avrg_rigid_inv, rigid_dttp_to_targ_init{tp});
        run_cmd(cp_inv_cmd, logfid);
        hw_init_target = path2tps{1}; % define the initial target for hw space registration as tp1 itself
    else
        % else compose the forward reg to tp1 with the inverse
        compose_xfms_cmd = sprintf('affine3Dtool -in %s -compose %s -out %s', ...
            rigid_dttp_to_tp1{tp-1}, avrg_rigid_inv, rigid_dttp_to_targ_init{tp});
        run_cmd(compose_xfms_cmd, logfid);
        hw_init_target = dttp_to_targ_init{1}; % define the initial target for hw space registration as tp1_to_hw
    end
    % Apply the transformation to each diff tensor time point
    apply_xfms_cmd1 = sprintf('affineSymTensor3DVolume -in %s -target %s -out %s -trans %s -interp LEI', ...
        path2tps{tp}, hw_init_target, dttp_to_targ_init{tp}, rigid_dttp_to_targ_init{tp});
    run_cmd(apply_xfms_cmd1, logfid);
    % write the registerd DTs file names into a text file
    fid = fopen(dtps_to_targ_list_init, 'a');
    fprintf(fid, '%s\n', dttp_to_targ_init{tp});
    fclose(fid);
     % also write the file names of the original DTs (in dtitk file format) into a file
     fid = fopen(orig_abs_path_list, 'a');
     fprintf(fid, '%s\n', path2tps{tp});
     fclose(fid);
end


%% Step 4: Compute the initial guess of the target space

% Compute the mean of all the time points in the halfway space
tvmean_cmd1 = sprintf('TVMean -in  %s -out %s', dtps_to_targ_list_init, initial_template);
run_cmd(tvmean_cmd1, logfid);

%% Step 5: Compute the transformations to the target space
% this step uses the first element of each tp tensor only.
% This should make the process faster and more robust.

% change location from working directory to create_template directory
cd(create_template);
% Run command to create the scalar template
mk_template_cmd = sprintf('scalar_rigid_population %s %s %s %d', ...
    initial_template, orig_abs_path_list, SM_scalar, n_iter);
run_cmd(mk_template_cmd, logfid);
% Go back to previous location
cd(path_to_wrkfold);

%% Step 6: Bring DTs in the template space
% There are already registered volumes output from step 5. However
% these have only the xx component of the tensor.
% Their names are automatically stored into a text file named as the
% input of step 5 but with the suffix "_aff"
% We overwrite the DT onto these files

% Construct the file name
[dt_abs_tp_list_path, dt_abs_tp_list_name, dt__abs_tp_list_ext] = fileparts(orig_abs_path_list);
dtps_to_targ_list = fullfile(dt_abs_tp_list_path, sprintf('%s_aff%s', dt_abs_tp_list_name, dt__abs_tp_list_ext));
% and open it
fid_aff = fopen(dtps_to_targ_list,'rt');

for tp = 1:n_tps
    % The output of step 5 is saved by default as the input names, but
    % using the .aff extension
    [input_file_path,input_file_basename] = fileparts(path2tps{tp});
    if contains(input_file_basename, '.nii')
        [~,input_file_basename] = fileparts(input_file_basename);
    end
    % Sotre the registration file paths and names
    rigid_dttp_to_targ{tp} = fullfile(input_file_path, sprintf('%s.aff', input_file_basename));
    % Read the step 5 output name from file
    dttp_to_targ{tp} = fgetl(fid_aff);
    % Now apply the transformations to the DTs
    apply_xfms_cmd2 = sprintf('affineSymTensor3DVolume -in %s -target %s -out %s -trans %s -interp LEI', ...
        path2tps{tp}, initial_template, dttp_to_targ{tp}, rigid_dttp_to_targ{tp});
    run_cmd(apply_xfms_cmd2, logfid);
end

%% Step 7: Compute the final version of the DT halfway space template. Compute also the MD and FA form it

% Compute the mean DT in the halfwayspace
tvmean_cmd2 = sprintf('TVMean -in  %s -out %s ', dtps_to_targ_list, targ_dt_template);
run_cmd(tvmean_cmd2, logfid);

% Compute the mean FA map from the hw_dt_template
tvtool_fa_cmd = sprintf('TVtool -in %s -fa -out %s', targ_dt_template, targ_fa_template);
run_cmd(tvtool_fa_cmd, logfid);

% Compute the mean MD map from the hw_dt_template
tvtool_fa_cmd = sprintf('TVtool -in %s -tr -out %s', targ_dt_template, targ_md_template);
run_cmd(tvtool_fa_cmd, logfid);


% Close log file
fclose(logfid);

%% Go back to initial folder
cd(starting_folder)



