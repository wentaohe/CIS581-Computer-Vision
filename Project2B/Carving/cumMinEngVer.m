% File Name: cumMinEngVer.m
% Author: Wentao He
% Date: Oct. 23rd, 2018

function [Mx, Tbx] = cumMinEngVer(e)
% Input:
%   e is the energy map

% Output:
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Write Your Code Here
[row, col] = size(e);
Mx = zeros(row, col + 2);
Tbx = zeros(row, col);
Mx(:, 2 : col + 1) = e;
Mx(:, 1) = Inf;
Mx(:, col + 2)= Inf;
for i = 2:row
    l_n = Mx(i - 1, 1 : col); %left neighbors
    c_n = Mx(i - 1, 2 : col + 1); %center neighbors 
    r_n = Mx(i - 1, 3 : col + 2); %right neighbors
    [minVal, index] = min([l_n;c_n;r_n]);
    Mx(i, 2 : col + 1) = Mx(i, 2 : col + 1) + minVal;
    Tbx(i, :) = index-2;
end

Mx = Mx(:, 2 : col + 1);
end