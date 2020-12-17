tic
data = imread('river.jpg');
[Ic, T] = carv(data, 60, 60);
imagesc(Ic);
toc