# dtitk/addons/IntraSubjGrpAlign

# Purpose

This DTI-TK addon helps to align the multiple-timepoint data of a single subject.

# Problem

The common approach to the task above is to use the baseline as the reference and align all the other timepoints to the baseline. However, this approach is problematic because the alignment is biased towards the baseline. The addon implements an unbiased approach by finding a target space that represents the centre of all the timepoints. When there are only two timepoints, the taret space is also known as the half-way space.

# Prerequsites

Matlab

# Download

You can download the script either as a zip archive or as a git clone from https://github.com/garyhuizhang/dtitk.

# Installation

You can either add the directory containing the matlab function to ...

# Usage

## Input

The script takes as input ...

## Output

It outputs ...

## Example commands

Typical usage:

...

