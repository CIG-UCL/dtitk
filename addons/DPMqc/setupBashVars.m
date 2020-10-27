function setupBashVars(fsl_path, im_path)
% setup bash variables to see: 
% - the atlas (FSL)
% - run registration (FSL)
% - check registration alignment (Image Magick)
% FSL_PATH: path to FSL /bin folder. /usr/local/fsl by default
% IM_PATH: path to Image Magick /bin folder . /usr/local by default

% FSL variables
if ~exist('fsl_path','var')
    fsl_path='/usr/local/fsl';
end
setenv('FSLDIR',fsl_path);
setenv('PATH',[ getenv('FSLDIR') '/bin:' getenv('PATH') ]);
setenv('FSLOUTPUTTYPE','NIFTI_GZ');

% Image Magick variables
if ~exist('im_path','var')
    im_path='/usr/local';
end
setenv('PATH',[ im_path '/bin:' getenv('PATH') ]);

