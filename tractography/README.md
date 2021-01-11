# dtitk/tractography

# Purpose

Tractography may be generated from diffusion tensor images and viewed using the two dtitk tools shown in this example.

# Prerequsites

dtitk

# Download

You can download the toolkit as a zip archive from http://dti-tk.sourceforge.net/

# Installation

Installation instructions can be found here http://dti-tk.sourceforge.net/pmwiki/pmwiki.php?n=Documentation.Install

# Usage

The two functions required are SingleTensorFT and TractTool.  
SingleTensorFT  -   generates a tractography from a dtitk formatted tensor vector volume.  
TractTool       -   visualises and filters dtitk formatted tractographies.

## SingleTensorFT


### Input

The required inputs to the function are:  
    -in        Tensor vector volume in dtitk format (NOT FSL FORMAT) as input  
    -seed      A mask volume of locations where the tracts may be  
    -out       The name of the file to output to e.g. ("tractography.vtk")  

## Output

It outputs the tractography file in dtitk formatting.

## TractTool

### Input

The required inputs to the function are:   
    -in        Tractography volume in dtitk format as input  
  
Notable additional variables are:  
    -view      (Flag) Visualises the tractographies   
    -useTube   Used with view to visualise the tracts as tubes  
    -filter    Filters the tracts to be only those passing though the roi  
    -roi       A mask volume  

### Output

Either a visualisation or filtered tractography.

## Example commands

Typical usage:
```bash
SingleTensorFT -in diffusionTensorVolume.nii.gz -seed WhiteMatterMask.nii.gz -out tractography.vtk
```
For visualisation:
```bash
TractTool -in Tractography.vtk -view
```
For visualisation with tubes:
```bash
TractTool -in Tractography.vtk -view -useTube 1
```
For filtering tracts:
```bash
TractTool -in Tractography.vtk -roi MidSagittalCorpusCallosumMask.nii.gz -filter TractsThroughCorpusCallosum.vtk
```
View filtered tracts:
```bash
TractTool -in TractsThroughCorpusCallosum.vtk -view
```

# Test dataset

A test dataset is freely available here https://www.nitrc.org/frs/download.php/11758/NODDI_example_dataset.zip
