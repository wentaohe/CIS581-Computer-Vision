im1 = imread('im1.png');
im2 = imread('im2.png');
[im1_pts, im2_pts] = click_correspondences(im1, im2); 
warp_frac = 0:0.0167:1;
dissolve_frac = 0:0.0167:1;
morphed_img = morph_tri(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
video = VideoWriter('Morphed.avi');
for i=1:size(morphed_img)
    open(video);
    frame=morphed_img{i};
    writeVideo(video,frame);
end
close(video);
implay ('Morphed.avi');