# dtitk/addons/RemoveFAring
DTI-TK addons: a script to remove high FA ring around the brain

The script takes in input an FA map and outputs the same map but without FA ring.
The FA map is expected to be already masked.
In addition, the script outputs an updated mask which not contains the removed FA ring voxels

The script uses both DTI-TK and FSL utilities, thus you should have both programs installed.
Check http://dti-tk.sourceforge.net/pmwiki/pmwiki.php?n=Documentation.Install and https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation respectively for info.

If you have system administrator privileges, you can copy the downloaded script directly into the DTI-TK script folder, so that you don’t need to specify the absolute/relative path every time.
Type from command line:

sudo cp path/to/downloaded/script ${DTITK_ROOT}/scripts/

In order to run the script, you can type:

faRing_rm path/to/fa_map

You can also run the script specifying the output base name:

faRing_rm path/to/fa_map path/to/output/base_name

