% File Name: rmHorSeam.m
% Author: Wentao He
% Date: Oct. 23rd, 2018

function [Iy, E] = rmHorSeam(I, My, Tby)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Output:
%   Iy is the image removed one row.
%   E is the cost of seam removal

% Write Your Code Here
row = size(I, 1);
col = size(I, 2);
dimensions = size(I, 3);
Iy = zeros(row - 1, col, dimensions);
[minVal, minInd] = min(My(:, col));
E = minVal;
for i = 1 : dimensions
    for j = col : -1 : 1
        col_val = I(:,j , i);
        Iy(:, j ,i) = [col_val(1 : minInd - 1); col_val(minInd + 1 : end)];
        minInd = minInd+ Tby(minInd, j);
    end  
end

Iy = uint8(Iy);

end