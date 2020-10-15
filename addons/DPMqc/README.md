# Purpose

This tool supports quality assessment of diffusion-derived parameter maps.

# Problem

Image acquisition and processing artefacts can introduce bias to fitted diffusion parameters that are difficult to detect by conventional analysis of the model fit residuals. This tool produces summary measures of parameters in white matter ROIs, where the parameter has an expected value that is homogenous across subjects. Artefacts are often subject dependent and can therefore be identified by examining the outliers for each ROI. The parameter affected and direction of the outlier gives insight into the expected cause of the fitting problem, which is also incorporated into the report.

# Prerequsites

## Software

MATLAB (https://uk.mathworks.com/downloads/)
NIfTI toolbox (https://uk.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image)
FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)

# Download

Download the toolbox as .zip or git clone using
'''bash
git clone https://github.com/garyhuizhang/dtitk
'''

# Installation

Add the tool directory to your MATLAB path.

# Usage

## Input

REG_FILES - Path to .txt file listing target images for atlas registration. If parameter maps are in a template space the text file contains the filename of the template target image. If the parameter maps are in native space the text file contains a list target images for each dataset. 
PARAM_PATHS - Path to .txt file listing folders containing diffusion parameter maps. 

## Output

PDF report on the quality of parameter maps and outliers

## Example commands

Typical usage:

```matlab
DPMqc(reg_files, param_paths)
```

Example:

```matlab
DPMqc('~/regpaths.txt', '~/noddipaths.txt')
```
where ~/regpaths.txt might look like this:
```bash
~/mystudy/subj1/DTI/dti_FA.nii.gz
~/mystudy/subj2/DTI/dti_FA.nii.gz
...
~/mystudy/subjN/DTI/dti_FA.nii.gz
```

And ~/noddipaths.txt might look like this:
```bash
~/mystudy/subj1/NODDI
~/mystudy/subj2/NODDI
...
~/mystudy/subjN/NODDI
```

# Test Dataset

A test dataset is freely available here https://www.nitrc.org/frs/download.php/11758/NODDI_example_dataset.zip