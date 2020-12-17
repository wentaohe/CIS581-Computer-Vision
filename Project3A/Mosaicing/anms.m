% File name: anms.m
% Author: Wentao He
% Date created: Nov. 1st, 2018

function [x, y, rmax] = anms(cimg, max_pts)
% Input:
% cimg = corner strength map
% max_pts = number of corners desired

% Output:
% [x, y] = coordinates of corners
% rmax = suppression radius used to get max_pts corners

% Write Your Own Code Here
    % corner metric matrix
    [X, Y] = meshgrid(1:size(cimg, 2), 1:size(cimg, 1));
    c_matrix = cat(3, cimg, X, Y);
    corner_v = reshape(c_matrix, size(cimg, 1) * size(cimg, 2), 3);
    
    % sort corner vector
    corner_v = sortrows(corner_v, 1);
    corner_v = flipud(corner_v);
    corner_v = horzcat(corner_v, -1 * ones(size(corner_v, 1), 1));
    
    % corner threshold
    corner_v = corner_v(1:round(.005 * size(corner_v, 1)), :);
    numPoints = size(corner_v, 1);
    
    corner_v(1, 4) = numPoints * numPoints + 1;
    
    for i = 2 : numPoints   
        x_matrix = corner_v(1:(i - 1), 2);
        x_matrix = x_matrix - corner_v(i, 2) * ones(1, size(x_matrix, 2));
        
        y_matrix = corner_v(1:(i - 1), 3);
        y_matrix = y_matrix - corner_v(i, 3) * ones(1, size(y_matrix, 2));
        
        r_matrix = (x_matrix.^2 + y_matrix.^2).^(0.5);
        
        minElement = min(r_matrix);
        
        corner_v(i, 4) = minElement;
    end

    corner_v = sortrows(corner_v, 4);
    corner_v = flipud(corner_v);
    
    x = corner_v(1:max_pts, 2);
    y = corner_v(1:max_pts, 3);
    rmax = corner_v(max_pts, 4);
end