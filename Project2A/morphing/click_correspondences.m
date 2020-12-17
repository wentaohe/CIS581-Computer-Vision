function [im1_pts, im2_pts] = click_correspondences(im1, im2)
%CLICK_CORRESPONDENCES Find and return point correspondences between images
%   Input im1: source image
%	Input im2: target image
%	Output im1_pts: correspondence-coordinates in the source image
%	Output im2_pts: correspondence-coordinates in the target image

%% Your code goes here
% You can use built-in functions such as cpselect to manually select the
% correspondences
[row1, col1, ~] = size(im1);
[row2, col2, ~] = size(im2);

row = max(row1, row2);
col = max(col1, col2);

padded_im1 = padarray(im1, [row-row1, col-col1], 'replicate', 'post');
padded_im2 = padarray(im2, [row-row2, col-col2], 'replicate', 'post');

[im1_pts, im2_pts] = cpselect(padded_im1, padded_im2, 'Wait', true); %define correspondence points

%add corner points 
im1_pts = [im1_pts; 0, 0; 0,col; row,col; row, 0;];
im2_pts = [im2_pts; 0, 0; 0,col; row,col; row, 0;];

end
