function write_dtitk_transf(rot, transl, output_file)
%
% printf_affine(rot, transl, output_file)
%
% write affine transformation matrix into DTI-TK format
%

fid = fopen(output_file, 'w+');

fprintf(fid, 'MATRIX\n');
fprintf(fid, '\t %f\t %f\t %f\n', rot(1,1:3));
fprintf(fid, '\t %f\t %f\t %f\n', rot(2,1:3));
fprintf(fid, '\t %f\t %f\t %f\n', rot(3,1:3));
fprintf(fid, 'VECTOR\n');
fprintf(fid, '\t %f\t %f\t %f\n', transl(1:3));

fclose(fid);