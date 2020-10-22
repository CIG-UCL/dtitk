# dtitk/addons/IntraSubjGrpAlign

# Purpose

This DTI-TK addon helps to align the multiple-timepoint data of a single subject.

# Problem

The common approach to the task above is to use the baseline as the reference and align all the other timepoints to the baseline. However, this approach is problematic because the alignment is biased towards the baseline. The addon implements an unbiased approach by finding a target space that represents the centre of all the timepoints. When there are only two timepoints, the target space is also known as the half-way space.
