% File name: corner_detector.m
% Author: Wentao He
% Date created: Nov. 1st, 2018

function [cimg] = corner_detector(img)
% Input:
% img is an image

% Output:
% cimg is a corner matrix

% Write Your Code Here
cimg = cornermetric(img, 'HARRIS');
end