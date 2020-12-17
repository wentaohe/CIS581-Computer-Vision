% File Name: carv.m
% Author: Wentao He
% Date: Oct. 23rd, 2018

function [Ic, T] = carv(I, nr, nc)
% Input:
%   I is the image being resized
%   [nr, nc] is the numbers of rows and columns to remove.
% 
% Output: 
% Ic is the resized image
% T is the transport map

% Write Your Code Here
row = size(I, 1);
col = size(I, 2);
dimensions = size(I, 3);
Ic = zeros(row - nr, col - nc, dimensions);
T = zeros(nr + 1, nc + 1); 
TI = T;

images = cell(nr + 1, nc + 1);
images{1, 1} =  I;
current_img = I;

for index = 2 : nr + 1 %deleting horizontal seams
    e = genEngMap(current_img);
    [My, Tby] = cumMinEngHor(e);
    [Iy, E] = rmHorSeam(current_img, My, Tby);
    current_img = Iy;
    T(index, 1) = T(index - 1, 1) + E;
    TI(index, 1) = 0;
    images{index, 1} = Iy;
end

current_img = I; %deleteing vertical seams

for index = 2 : nc + 1
    e = genEngMap(current_img);
    [Mx, Tbx] = cumMinEngVer(e);
    [Ix, E] = rmVerSeam(current_img, Mx, Tbx);
    current_img = Ix;
    T(1, index) = T(1, index - 1) + E;
    TI(1, index) = 1;
    images{1, index} = Ix;
end

Img = I;
e = genEngMap(Img);
[My, Tby] = cumMinEngHor(e);
[Img, ~] = rmHorSeam(Img, My, Tby);
e = genEngMap(Img);
[Mx, Tbx] = cumMinEngVer(e);
[Img, ~] = rmVerSeam(Img, Mx, Tbx);

for index = 2 : nr + 1
    state = Img;
    for j = 2 : nc + 1
        e = genEngMap(state);
        [My, Tby] = cumMinEngHor(e);
        [rowdel, erow] = rmHorSeam(state, My, Tby);
        [Mx, Tbx] = cumMinEngVer(e);
        [coldel, ecol] = rmVerSeam(state, Mx, Tbx);
        [cost, ind] = min([T(index - 1, j) + erow,T(index, j - 1) + ecol]);
        T(index, j) = cost;
        TI(index, j) = ind - 1;
        if ind - 1 == 1
            images{index,j}=coldel; %vertical seam removal
        else
            images{index,j}=rowdel; %horizontal seam removal
        end
        state = coldel;
    end
    
    e = genEngMap(Img);
    [My, Tby] = cumMinEngHor(e);
    [Img, ~] = rmHorSeam(Img, My, Tby);
    
end

k = nr+nc; 
currentx = nc + 1;
currenty = nr + 1;
resized = cell(k, 1);

for m = k : -1 : 1
    operation = TI(currenty, currentx);
    padded_img = [];
    if operation == 1
        currentx = currentx-1;
        currentImg = images{currenty,currentx};
        rowc = size(currentImg, 1);
        colc = size(currentImg, 2);
        padded_img(:, :, 1) = padarray(currentImg(:, :, 1),[row - rowc, col - colc], 0, 'post');
        padded_img(:, :, 2) = padarray(currentImg(:, :, 2),[row - rowc, col - colc], 0, 'post');
        padded_img(:, :, 3) = padarray(currentImg(:, :, 3),[row - rowc, col - colc], 0, 'post');
        resized{m, 1} = padded_img;
    else 
        currenty = currenty - 1;
        currentImg = images{currenty, currentx};
        rowc = size(currentImg, 1);
        colc = size(currentImg, 2);
        padded_img(:, :, 1) = padarray(currentImg(:, :, 1), [row - rowc, col - colc], 0, 'post');
        padded_img(:, :, 2) = padarray(currentImg(:, :, 2), [row - rowc, col - colc], 0, 'post');
        padded_img(:, :, 3) = padarray(currentImg(:, :, 3), [row - rowc, col - colc], 0, 'post');
        resized{m, 1} = padded_img;
    end
end
Ic = uint8(images{nr + 1, nc + 1});
videoCreation(resized);
end 
