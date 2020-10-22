function [rot, transl] = read_dtitk_transf(input_path)
%
% [rot, transl] = importAffTransg(input_path)
%
% read affine matrix file format from DTI-TK and output the rotation and
% translation bits
%

rot = zeros(3,3);
transl = zeros(3,1);

fid = fopen(input_path,'r');
% separate the rotation bit form the translation
rot(1,1:3) = fscanf(fid, '%*s \n %f %f %f', 3);
rot(2,1:3) = fscanf(fid, '%f %f %f', 3);
rot(3,1:3) = fscanf(fid, '%f %f %f', 3);
transl(1:3) = fscanf(fid, '%*s \n %f %f %f', 3);
