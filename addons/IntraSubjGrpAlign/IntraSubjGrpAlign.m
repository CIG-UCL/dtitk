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




