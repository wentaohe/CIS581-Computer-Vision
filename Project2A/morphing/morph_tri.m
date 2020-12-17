function [morphed_im] = morph_tri(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)

frame = length(warp_frac);
morphed_im = cell(frame, 1);

assert(size(im1_pts, 1) == size(im2_pts, 1));
assert(length(warp_frac) == length(dissolve_frac))
avg = 0.5 * im1_pts + 0.5 * im2_pts;
tri = delaunay(avg(:, 1), avg(:, 2));

[row1, col1, ~] = size(im1);
[row2, col2, ~] = size(im2);
row = max(row1, row2);
col = max(col1, col2);
im1 = padarray(im1, [row-row1, col-col1], 'replicate', 'post');
im2 = padarray(im2, [row-row2, col-col2], 'replicate', 'post');

for i=1:length(warp_frac)
    morphed_im{i} = warping(tri, im1, im1_pts, im2, im2_pts, warp_frac(i), dissolve_frac(i));
end

end

