function compute_avrg_transf(list_of_transf, output_name)
%
% compute_avrg_transf(list_of_transf, output_name)
%
% Compute the average transformation and its inverse from a set of rigid
% trnasformations from text file in DTI-TK format
%
%
% list_of_transf: cell of filenames to RIGID transformations
% 
% output_name: base name for the output transformation and its inverse
%
% Exaple file format is:
%
% MATRIX
% 	 0.999674	 0.023130	 -0.010815
% 	 -0.021749	 0.993248	 0.113956
% 	 0.013377	 -0.113683	 0.993427
% VECTOR
% 	 -0.330813	 0.138959	 2.431134
%
% where MATRIX is the rotational part of the transformation and VECTOR is
% the translational part.

if nargin < 2
    output_name = 'avrg_transf';
end

% number of input files
n_transf = length(list_of_transf);

log_transf = zeros(4,4,n_transf);

for i = 1:n_transf
    % read the transformation matrix from DTI-TK format
    [tmp_rot, tmp_transl] = read_dtitk_transf(list_of_transf{i});
    % check that the rotation is a rotation
    if ~isequal(round(tmp_rot*tmp_rot',5), eye(3,3))
        error('This is not a rotation matrix !');
    end
    % compute and store the log rotation
    log_transf(:,:,i) = logm(mergeAffine(tmp_rot, tmp_transl));
end

%%

% evaluate the mean transformation
% here we consider also the transformation from baseline to itself which
% increases the number of transf by one
avrg_transf = expm( sum(log_transf,3)./(n_transf+1) );
% check it is a rotation matrix
if ~isequal(round(avrg_transf(1:3,1:3)*avrg_transf(1:3,1:3)',5), eye(3,3))
        error('This is not a rotation matrix !');
end

%%

% Evaluate the inverse transf average matrix 
inv_avrg_transf = inv(avrg_transf);

%%

% write the matrices to file the mean and inverse transformations
write_dtitk_transf(avrg_transf(1:3,1:3), avrg_transf(1:3,4), sprintf('%s.aff',output_name));
write_dtitk_transf(inv_avrg_transf(1:3,1:3),inv_avrg_transf(1:3,4),sprintf('%s_inv.aff',output_name));







