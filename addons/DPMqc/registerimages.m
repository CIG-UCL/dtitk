function [] = registerimages(regpair,i)

% function [] = registerimages(regpair,i)
% 
% Register image regpair{2} to regpair{1} and save transformations
% Uses rigid, affine and non-linear registration

% input images
float=regpair{1};
ref=regpair{2};

% file parts
%[float_dir,nii_name,c]=fileparts(float);
%[~,float_name,~]=fileparts(nii_name);

% transformations output
t_affine=['DPMqc/' i '_tmat']; %[ float_dir '/' float_name '_tmat' ];
t_diffeo=['DPMqc/' i '_tmat']; %[ float_dir '/' float_name '_warpcoeff' ];

% register
system(['flirt -in ' float ' -ref ' ref ' -omat ' t_affine ' -cost normmi -interp trilinear']);
system(['fnirt --in=' float ' --ref= ' ref ' --aff=' t_affine ' --fout=' t_diffeo]);

% masks? output location? dtitk/niftyreg?