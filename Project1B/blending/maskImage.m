function mask = maskImage(Img)
%% Enter Your Code Here

h_im = imshow(Img);
e = imfreehand(gca);
mask = createMask(e,h_im);
mask = logical(mask);

end

