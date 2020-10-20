#!/bin/bash
#!/bin/bash
#============================================================================
#
#  Program:     This is a plug-in which integrates with both
#               FMRIB Software Library (FSL) and DTI ToolKit (DTI-TK)
#  Module:      $RCSfile: dti_rigid_reg,v $
#  Language:    bash
#  Date:        $Date: 2020/10/07 16:10:40 $
#  Version:     $Revision: 0 $
#
#  Copyright (c)
#  Michele Guerreri (michele.guerreri@gmail.com)
#  Gary Hui Zhang (garyhuizhang@gmail.com).
#  All rights reserverd.
#
#============================================================================

#
# IntraSubjGrpAlign


# source PATH setting from ~.bashrc
# required for qsub to work
if [ -e ~/.bashrc ]
then
        . ~/.bashrc
elif [ -e ~/.bash_profile ]
then
        . ~/.bash_profile
fi

# % INPUTS:
# path_to_wrkfold: absolute path to the folder of the subject you wish to
#                  analyse. This folder is referred to as â€œworking folderâ€�.
#                  Each time point is assumed to be organized in a separate
#                  sub folder.
# 
# dt_tp_list: name of the text file in which each line specifies the
#             relative path from the working folder to each diffusion
#             tensor timepoint (which must be in DTI-TK format).
#             The number of lines in the text file should match the number
#             of time points for that specific subject.
#             The text file should be saved in the folder speficied by
#             "path_to_wrkfold".
#
# OUTPUTS:
# 1. The set of transformations bringing each time point to the target
#    space. The transformations are saved as text files in DTI-TK affine
#    matrix format. The transformations are saved in each time point sub 
#    folder and, by default, the name is set equal to the input diffusion
#    tensor, but with ".aff" extension.
# 
# 2. Each diffusion tensor time point brought into the target space. These
#    files are saved in the same folders as the transformation matrices,
#    with the suffix "_aff.nii.gz".
# 
# 3. Mean of all time point into the target space as well as the main
#    diffusion tensor scalar metrics in that space. These files are saved
#    in an additional subfolder of the working directory named
#    "IntraSubjGrpTemplate".
#

# The script is divided in 7 steps listed below.
#
# NOTE: the paths are all relative to the one specified as input of the script
#
# STEP1:
# Register all the timepoints to the timepoint 1 (the first listed in the file, can be any).
# It uses DTI-TK script "rtvCGM"
# Input: text files with list of paths to DT files (one for each TP)
# Output: Transformation matrices. Stored into IntraSubjGrpTemplate/targSpace_init/
# 
# STEP2:
# Compute the average trasnformation form the transformations at step 1
# It uses a python script
# Input: Transformation matrices (step1). File (?)
# Output: Average tranformaiton and inverse of the average. Stored into IntraSubjGrpTemplate/targSpace_init/
#			avrg_transf.aff
#			avrg_transf_inv.aff
# 
# STEP3:
# Compute and apply the initial transformations to the halfway space for each timepoint.
# Combine the output from step1 and step2
# It uses "affine3Dtool" and "affineSymTensor3DVolume"
# Input: The transformations at the step above
# Output: Concatenated transofrmations and apply to tensors. Both stored in IntraSubjGrpTemplate/targSpace_init/
#		  You also need a list with the .nii.gz files for the next steps (with the full path)
#			rigid_tp[TP#]_to_targ.aff
#			dttp[TP#]_to_targ.nii.gz
#			dttps_to_targ_list.txt
#
# STEP4:
# Compute the initial guess of the target space
# Average the DT output from step3
# It uses "TVMean"
# Input: dttps_to_targ_list.txt
# Output: The initial template, which is stored into IntraSubjGrpTemplate/targSpace_init/
#			initial.nii.gz
#
# STEP5:
# Compute the transformations from each timepoint to the target space
# Uses output of step4 and step3 to initialize an iterative template creation.
# It uses only the firs element of the tensor, i.e. xx, to be faster and more robust.
# Thus it uses the DTI-TK "scalar_rigid_population" script.
# Input: initial.nii.gz, the file list with the original DT tensors needs to be copied into the target directory and renamed "orig_abs_path_list.txt"
# Output: Automatically generates the .aff file in each timepoint folder. The template is generated in the folder IntraSubjGrpTemplate/create_template
#			orig_abs_path_list_aff.txt is created within the same folder.
#
# STEP6:
# Bring DTs in the template space
# Once that the intra-subj-group-template is defined, each timepoint DT needs to be warped there (in the privious step the transformation is applyed only on the first element of the tensor).
# It uses "affineSymTensor3DVolume"
# Input: Uses the .aff files generated in the privious step. Uses the original DT files. Also uses "orig_abs_path_list_aff.txt" text file automatically generated in step 5
# Output: The warped DT volumes are overwritten in each timepoint folder as "orig_name_aff.nii.gz"
#
#
# STEP7:
# Compute the final version of the DT halfway space template. Compute also the MD and FA form it
# It uses "TVMean" and "TVtool"
# Input: "orig_abs_path_list_aff.txt"
# Output: dt_template.nii.gz, dt_fa_template.nii.gz, dt_md_template.nii.gz in IntraSubjGrpTemplate folder.
#
#
#
#
#
#
#
#
#
#
#
#




