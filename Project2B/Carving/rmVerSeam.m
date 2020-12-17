% File Name: rmVerSeam.m
% Author: Wentao He
% Date: Oct. 23rd, 2018

function [Ix, E] = rmVerSeam(I, Mx, Tbx)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Output:
%   Ix is the image removed one column.
%   E is the cost of seam removal

% Write Your Code Here
row = size(I,1);
col = size(I,2);
dimensions = size(I,3);
Ix = zeros(row, col - 1, dimensions);
[minVal, minInd] = min(Mx(row, :));
E = minVal;
for i = 1 : dimensions
    for j = row : -1 : 1
        rwo_val = I(j, :, i);
        Ix(j, :, i) = [rwo_val(1 : minInd - 1), rwo_val(minInd + 1 : end)];
        minInd = minInd + Tbx(j, minInd);
    end
end

Ix = uint8(Ix);

end