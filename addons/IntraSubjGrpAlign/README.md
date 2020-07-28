# dtitk/addons/IntraSubjGrpAlign

# Purpose

This DTI-TK addon helps to align the multiple-timepoint data of a single subject.

# Problem

The common approach to the task above is to use the baseline as the reference and align all the other timepoints to the baseline. However, this approach is problematic because the alignment is biased towards the baseline. The addon implements an unbiased approach by finding a target space that represents the centre of all the timepoints. When there are only two timepoints, the target space is also known as the half-way space.

# Prerequsites

Matlab and DTI-TK.

# Download

You can download the matlab function either as a zip archive or as a git clone from https://github.com/garyhuizhang/dtitk.

# Installation

You can either add the directory containing the matlab function to ...

# Usage

## Input

The matlab function has two inputs: first, you should specify the absolute path to the folder of the subject you wish to analyse. We refer to this folder as “working folder”. Here, we assume each time point is organized in a separate subfolder. The second input specifies the name of a text file which has been previously created. The text file should contain a number of lines equal to the number of time points for that specific subject. Each line should specify the relative path from the working folder to each diffusion tensor timepoint (which must be in DTI-TK format). The text file should be saved in the working directory.

## Output

The function finds a target space representing the centre of all time points. The outputs are the set of transformations bringing each time point to the target space. The transformations are saved as text files in DTI-TK affine matrix format. The transformations are saved in each time point sub folder and, by default, the name is equal to the input diffusion tensor, but with “.aff” extension. In addition, the function outputs each diffusion tensor time point brought into the target space. These files are saved in the same folders as the transformation matrices, with the suffix “_aff.nii.gz”. Lastly, the function outputs the mean of all time point into the target space and computes the main diffusion tensor scalar metrics. These files are saved in an additional subfolder of the working directory named “IntraSubjGrpTemplate”.

## Example commands

Typical usage:

IntraSubjGrpAlign(path/to/subj_dir, tp_list_file_name)

Example:

IntraSubjGrpAlign('/home/myStudy/subj001','dt_tp_list.txt')

where dt_tp_list.txt is something like:

tp1/dtitk/tensor.nii.gz
tp2/dtitk/tensor.nii.gz
...
tpN/dtitk/tensor.nii.gz

