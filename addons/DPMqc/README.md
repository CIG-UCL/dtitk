# Purpose

This tool supports quality assessment of diffusion-derived parameter maps.

# Description

Diffusion-derived parameter maps may be biased by image acquisition and processing artefacts. This tool produces summaries of parameter values in white matter ROIs, where their value is expected to be stable across subjects. Biases are often subject dependent and can therefore be identified by examining the outlying subjects for each ROI. 

# Prerequsites

## Software

MATLAB (https://uk.mathworks.com/downloads/)

NIfTI toolbox (https://uk.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image)

FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)

ImageMagick (https://imagemagick.org/script/download.php)

# Download

Download the toolbox as .zip or git clone using
```bash
git clone https://github.com/garyhuizhang/dtitk
```

# Installation

Add the tool directory to your MATLAB path.

# Usage

## Input

subj_list - Path to .txt file listing target images for atlas registration.  
param_list - Path to .txt file listing parameter maps to assess for outliers. Images should correspond to subj_list.  

## Output

DPMqc folder containing:  
<parameter_name>_mean_params.txt - mean parameter value in ROI for each subject (row) and each ROI (column)     

## Example commands

Typical usage:

```matlab
DPMqc(subj_list, param_list)
```

Example:

```matlab
DPMqc('~/subjs_target_paths.txt', '~/parameter_paths.txt')
```
where ~/subjs_target_paths.txt might look like this:
```bash
~/mystudy/subj1/DiffParams/dti_FA.nii.gz
~/mystudy/subj2/DiffParams/dti_FA.nii.gz
...
~/mystudy/subjN/DiffParams/dti_FA.nii.gz
```

And ~/parameter_paths.txt might look like this:
```bash
~/mystudy/subj1/NODDIParams/FIT_ICVF.nii.gz
~/mystudy/subj2/NODDIParams/FIT_ICVF.nii.gz
...
~/mystudy/subjN/NODDIParams/FIT_ICVF.nii.gz
```

