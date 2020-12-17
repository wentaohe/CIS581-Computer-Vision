%% Section 1: Load Images
I1 = imread('boat1.jpg');
I2 = imread('boat2.jpg');
I3 = imread('boat3.jpg');
c = cell(1, 2);
c{1, 1} = I1;
c{1, 2} = I2;
c{1, 3} = I3;

%% Section 2: Load Variables

% ALWAYS LEAVE THIS SECTION UNCOMMENTED IF YOU WANT TO SEE THE INTERMEDIATE
% PLOTS

% I1_gray = rgb2gray(I1);
% I2_gray = rgb2gray(I2);
% I3_gray = rgb2gray(I3);
% 
% conerMap1 = corner_detector(I1_gray);
% conerMap2 = corner_detector(I2_gray);
% conerMap3 = corner_detector(I3_gray);
% 
% C1 = double(imregionalmax(conerMap1));
% C2 = double(imregionalmax(conerMap2));
% C3 = double(imregionalmax(conerMap3));
% 
% conerMap1 = C1 .* conerMap1;
% conerMap2 = C2 .* conerMap2;
% conerMap3 = C3 .* conerMap3;
% 
% corners1 = find(conerMap1);
% corners2 = find(conerMap2);
% corners3 = find(conerMap3);
% 
% [x1 y1] = anms(conerMap1, 500);
% [x2 y2] = anms(conerMap2, 500);
% [x3 y3] = anms(conerMap3, 500);

%% Section 3: prior and post-RANSAC matching for Img1 and Img 2
% descs1 = feat_desc(I1_gray, x1, y1);
% descs2 = feat_desc(I2_gray, x2, y2);
% figure;
% axis off
% title('prior-RANSAC matching');
% match = feat_match(descs1, descs2);
% f_idx = match(match ~= -1);
% x1 = x1(match > 0);
% x2 = x2(f_idx);
% y1 = y1(match > 0);
% y2 = y2(f_idx);
% [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, 0.5);
% showMatchedFeatures(I1,I2,[x1,y1],[x2,y2],'montage');
% 
% figure;
% axis off
% title('post-RANSAC matching');
% inl_x1 = x1(inlier_ind);
% inl_y1 = y1(inlier_ind);
% inl_x2 = x2(inlier_ind);
% inl_y2 = y2(inlier_ind);
% 
% showMatchedFeatures(I1,I2,[inl_x1,inl_y1],[inl_x2,inl_y2],'montage');

%% Section 4: prior and post-RANSAC matching for Img2 and Img 3
% descs1 = feat_desc(I2_gray, x2, y2);
% descs2 = feat_desc(I3_gray, x3, y3);
% figure;
% axis off
% title('prior-RANSAC matching');
% match = feat_match(descs1, descs2);
% f_idx = match(match ~= -1);
% x2 = x2(match > 0);
% x3 = x3(f_idx);
% y2 = y2(match > 0);
% y3 = y3(f_idx);
% [H, inlier_ind] = ransac_est_homography(x2, y2, x3, y3, 0.5);
% showMatchedFeatures(I2,I3,[x2,y2],[x3,y3],'montage');
% 
% figure;
% axis off
% title('post-RANSAC matching');
% inl_x2 = x2(inlier_ind);
% inl_y2 = y2(inlier_ind);
% inl_x3 = x3(inlier_ind);
% inl_y3 = y3(inlier_ind);
% 
% showMatchedFeatures(I2,I3,[inl_x2,inl_y2],[inl_x3,inl_y3],'montage');

%% Seciton 5: corner detection & adaptive non-maximal suppression

% [y1 x1] = ind2sub(size(conerMap1),corners1);
% [y2 x2] = ind2sub(size(conerMap2),corners2);
% [y3 x3] = ind2sub(size(conerMap3),corners3);
% 
% figure()
% subplot(1,2,1);
% imshow(I1)
% hold on
% plot(x1,y1,'.','Color',[1,0,0])
% title('corner detection')
% 
% %nms
% [x1 y1] = anms(conerMap1, 500);
% subplot(1,2,2);
% imshow(I1)
% hold on
% plot(x1,y1,'.','Color',[1,0,0]);
% title('adaptive non-maximal suppression')
% 
% figure()
% subplot(1,2,1);
% imshow(I2)
% hold on
% plot(x2,y2,'.','Color',[1,0,0])
% title('corner detection')
% 
% %nms
% [x2 y2] = anms(conerMap1, 500);
% subplot(1,2,2);
% imshow(I2)
% hold on
% plot(x2,y2,'.','Color',[1,0,0]);
% title('adaptive non-maximal suppression')
% 
% figure()
% subplot(1,2,1);
% imshow(I3)
% hold on
% plot(x3,y3,'.','Color',[1,0,0])
% title('corner detection')
% 
% %nms
% [x3 y3] = anms(conerMap1, 500);
% subplot(1,2,2);
% imshow(I3)
% hold on
% plot(x3,y3,'.','Color',[1,0,0]);
% title('adaptive non-maximal suppression')


%% Section 6: Mosaicing
tic
[img_mosaic] = mymosaic(c);
toc

figure;
image(img_mosaic);
title('Final Mosaic');
axis off
