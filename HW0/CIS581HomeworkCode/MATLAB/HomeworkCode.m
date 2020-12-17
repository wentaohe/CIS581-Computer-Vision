%% Clear the environment
clc
clear

%% Read an image
% Attribution - Bikesgray.jpg By Davidwkennedy (http://en.wikipedia.org/wiki/File:Bikesgray.jpg) [CC BY-SA 3.0 (http://creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons
img1 = ; %Write code here to read in the image named 'Bikesgray.jpg' into the variable img1

%% Display original image
figure; imagesc(img1); axis image; colormap(gray);

%% X gradient - Sobel Operator
f1 = [1 0 -1; 2 0 -2; 1 0 -1];

%% Convolve image with kernel f1 -> This highlights the vertical edges in the image
vertical_sobel = ; %Write code here to convolve img1 with f1

%% Display the image
% Write code here to display the image 'vertical_sobel'

%% Y gradient - Sobel Operator
f2 = ; % Now if you want to highlight horizontal edges in the image, think about what the kernel should be. Store this kernel in the variable f2.

%% Convolve image with kernel f2 -> This should highlight the horizontal edges in the image
horz_sobel = ; %Write code here to convolve img1 with f2

%% Display the image
% Write code here to display the image 'horz_sobel'