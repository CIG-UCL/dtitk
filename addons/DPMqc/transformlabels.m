function [] = transformlabels(labels,target,i)

% function [] = transformlabels(i)
% Transforms LABELS to the TARGET image

% transformation input
t_diffeo=['DPMqc/' i '_diffeo'];

% transformed labels
labout=['DPMqc/' i '_lab.nii.gz'];

% apply transformation
system(['applywarp --in=' labels ' --ref=' target ' --out=' labout ' --warp=' t_diffeo ' --interp=trilinear']);