% File name: feat_desc.m
% Author: Wentao He
% Date created: Nov. 1st, 2018

function [descs] = feat_desc(img, x, y)
% Input:
%    img = double (height)x(width) array (grayscale image) with values in the
%    range 0-255
%    x = nx1 vector representing the column coordinates of corners
%    y = nx1 vector representing the row coordinates of corners

% Output:
%   descs = 64xn matrix of double values with column i being the 64 dimensional
%   descriptor computed at location (xi, yi) in im

% Write Your Code Here

img = padarray(img,[20,20]);
N = size(x,1);
kernel = fspecial('gaussian');
descs = zeros(64,N);

for i = 1:N
    patch = img(round(y(i)):round(y(i)+39),round(x(i)):round(x(i)+39));
    blurred = imfilter(patch,kernel,'same');
    % sample every s = 5
    down_sampled = downsample(blurred,5);
    down_sampled = downsample(down_sampled',5)';
    descs(:,i) = reshape(down_sampled,[64 1]);
    descs(:,i) = descs(:,i) - mean(descs(:,i));
    descs(:,i) = descs(:,i)./std(descs(:,i),1);
end

end