function A = mergeAffine(lin,transl)
%
% A = mergeAffine(lin,transls)
% 
% Takes in input 3x3 linear teansf matrix and 3x1 translation vector
% and outputs a 4x4 affine matrix
% 
% lin: 3x3 matrix
% transl: 3x1 translation vector
% 
% if lin and transl are 3x3xN and 3xN arrays it outputs 4x4xN merged
% matrices

% Check dimensionality of lin and transl
extrad = size(lin,3);
if size(size(lin),2) == 3
    multi = 1;
    if size(transl,2) ~= extrad
        error('The extra dimension of the linear matrix and the traslation vector should be the same')
    end
else
    multi = 0;
end

if ~multi
    A = [cat(1,lin, [0 0 0]) cat(1,transl, 1)];
else
    A = zeros(4,4,extrad);
    for i=1:extrad
        A(:,:,i) = [cat(1,lin(:,:,i), [0 0 0]) cat(1,transl(:,i), 1)];
    end
end




