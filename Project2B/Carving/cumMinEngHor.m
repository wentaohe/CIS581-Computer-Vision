% File Name: cumMinEngHor.m
% Author: Wentao He
% Date: Oct. 23rd, 2018

function [My, Tby] = cumMinEngHor(e)
% Input:
%   e is the energy map.

% Output:
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Write Your Code Here
[row, col] = size(e);
My = zeros(row + 2, col);
My(1, :) = Inf;
My(row + 2, :) = Inf;
My(2 : row + 1, :) = e;
Tby = zeros(row,col);
for j = 2:col
    t_n = My(1 : row, j - 1); %top neighbors
    c_n = My(2 : row + 1, j - 1); %center neighbors
    l_n = My(3 : row + 2, j - 1); %lower neighbors
    [minVal, index] = min([t_n'; c_n'; l_n']);
    My(2 : row + 1, j) = My(2 : row + 1, j) + minVal';
    Tby(:, j) = index' - 2;
end

My = My(2 : row + 1, :);

end