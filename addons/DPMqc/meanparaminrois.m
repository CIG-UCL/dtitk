function [means] = meanparaminrois(dataroipair,p,rois)

% function [] = meanparaminrois(param_image,roilabels)
% 
% Return list of the mean diffusion parameter withiin each of the ROIS 
% in the PARAM_IMAGE

param_image_file=[dataroipair{1} '/' p '.nii.gz'];
rois_image_file=dataroipair{2};
param_image=load_untouch_nii(param_image_file);
rois_image=load_untouch_nii(rois_image_file);

for i=1:numel(rois)
    roi_inds=find(rois_image==rois(i));
    means{i}=mean(param_image(roi_inds));
end
