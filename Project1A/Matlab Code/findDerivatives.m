function [Mag, Magx, Magy, Ori] = findDerivatives(I_gray)
%%  Description
%       compute gradient from grayscale image 
%%  Input: 
%         I_gray = (H, W), double matrix, grayscale image matrix 
%
%%  Output:
%         Mag  = (H, W), double matrix, the magnitued of derivative%  
%         Magx = (H, W), double matrix, the magnitude of derivative in x-axis
%         Magx = (H, W), double matrix, the magnitude of derivative in y-axis
% 				Ori = (H, W), double matrix, the orientation of the derivative
%
%% ****YOU CODE STARTS HERE**** 

%% Gaussian
G = [2, 4, 5, 4, 2; 
    4, 9, 12, 9, 4; 
    5, 12, 15, 12, 5; 
    4, 9, 12, 9, 4; 
    2, 4, 5, 4, 2];
G = 1/159.* G;

%% Derivatives
dx = [1, 0, -1];
dy = [1;
    0;
    -1];

Gx = conv2(G, dx, 'same');
Gy = conv2(G, dy, 'same');

%% Gradient of x and y axis
Magx = conv2(I_gray, Gx, 'same');
Magy = conv2(I_gray, Gy, 'same');

%% Magnitude of the gradient
Mag = sqrt(Magx.^2 + Magy.^2);

%% Orientation of the gradient
Ori = atan2(Magy, Magx) + pi;
end