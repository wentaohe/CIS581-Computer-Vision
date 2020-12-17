function[warped] = warping(tri, im1, img1_pts, im2, img2_pts, warp_frac, dissolve_frac)

warped = (1 - dissolve_frac) .* im1 + (dissolve_frac) .* im2;
[row, col, ~] = size(im1);
intermediate = (1 - warp_frac) .* img1_pts + warp_frac .* img2_pts;
num_triangle = size(tri, 1);

matrix = ones(col, row); 
[X, Y] = find(matrix == 1);
T = tsearchn(intermediate, tri, [Y,X]);

current = zeros(3, 3, num_triangle);
source = zeros(3, 3, num_triangle);
target = zeros(3, 3, num_triangle);

for i = 1:num_triangle
    vertices = tri(i, :);
    col1 = [intermediate(vertices(1), :) 1]'; 
    col2 = [intermediate(vertices(2), :) 1]';
    col3 = [intermediate(vertices(3), :) 1]';
    current(:, :, i) = [round(col1) round(col2) round(col3)];
    
    col1 = [img1_pts(vertices(1),:) 1]'; 
    col2 = [img1_pts(vertices(2),:) 1]';
    col3 = [img1_pts(vertices(3),:) 1]';
    source(:, :, i) = [round(col1) round(col2) round(col3)];
    
    col1 = [img2_pts(vertices(1),:) 1]';
    col2 = [img2_pts(vertices(2),:) 1]';
    col3 = [img2_pts(vertices(3),:) 1]';
    target(:, :, i) = [round(col1) round(col2) round(col3)];
end

triangle_index = find(T > 0);

current_p = zeros(3, length(triangle_index)); 
current_bary = zeros(3, length(triangle_index));
source_xy = zeros(3, length(triangle_index));
target_xy = zeros(3, length(triangle_index));

for i = 1:length(triangle_index)
    current_p(:, i) = [Y(triangle_index(i)); X(triangle_index(i)); 1]; 
    current_bary(:, i) = current(:, :, T(triangle_index(i))) \ current_p(:,i);
    source_xy(:, i) = round(source(:, :, T(triangle_index(i))) * current_bary(:,i));
    target_xy(:, i) = round(target(:, :, T(triangle_index(i))) * current_bary(:,i));
end

source_x = source_xy(1,:)./source_xy(3,:);
source_y = source_xy(2,:)./source_xy(3,:);
source_x(source_x < 1) = 1;
source_y(source_y < 1) = 1;
source_x(source_x > col)=col;
source_y(source_y > row)=row;


target_x = target_xy(1,:)./target_xy(3,:);
target_y = target_xy(2,:)./target_xy(3,:);
target_x(target_x < 1) = 1;
target_y(target_y < 1) = 1;
target_x(target_x >col)=col;
target_y(target_y >row)=row;

for i = 1:size(current_p, 2)
    warped(current_p(2, i), current_p(1, i),:) = (1 - dissolve_frac) ...
        .* im1(source_y(i), source_x(i),:) + (dissolve_frac) .* im2(target_y(i), target_x(i), :);
end

warped = warped(1:row,1:col,:);
    
end