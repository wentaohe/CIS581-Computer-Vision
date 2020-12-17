% File name: mymosaic.m
% Author: Wentao He
% Date created: Nov. 1st, 2018

function [img_mosaic] = mymosaic(img_input)
% Input:
%   img_input is a cell array of color images (HxWx3 uint8 values in the
%   range [0,255])
%
% Output:
% img_mosaic is the output mosaic
    number = size(img_input, 2);
    midIndex = ceil(number / 2);
    gray_img = cell(1, number);
    
    for i = 1 : number
        tempImage = img_input{1, i};
        gray_img{1, i} = rgb2gray(tempImage);
    end

    %% corner detection
    corners = cell(1, number);
    
    for i = 1 : number
        corners{1, i} = corner_detector(gray_img{1, i});
    end
    
    %% adaptive non-maximal suppression
    x_points = cell(1, number);
    y_points = cell(1, number);
    rmax_points = cell(1, number);
    
    for i = 1 : number
        [xTemp, yTemp, rMaxTemp] = anms(corners{1, i}, 500);
        x_points{1, i} = xTemp;
        y_points{1, i} = yTemp;
        rmax_points{1, i} = rMaxTemp;
    end
    
   %% check border
   for i = 1 : number
        [xTemp, yTemp] = border_detector(gray_img{1, i}, x_points{1, i}, y_points{1, i});
        x_points{1, i} = xTemp;
        y_points{1, i} = yTemp;
   end 
        
    %% feature descriptors
    descs = cell(1, number);
    
    for i = 1 : number
        [descsTemp] = feat_desc(gray_img{1, i}, x_points{1, i}, y_points{1, i});
        descs{1, i} = descsTemp;
    end

    %% feature matches
    matches = cell(1, number - 1);
    
    for i = 1 : (number - 1)
        [matchesTemp] = feat_match(descs{1, i}, descs{1, i + 1});
        matches{1, i} = matchesTemp;
    end
    
    %% Filter correspondences
    corr = cell(1, number - 1, 4);
        
    for i = 1 : (number - 1)
        match = matches{1, i};
       
        x1 = x_points{1, i}(match > 0);
        y1 = y_points{1, i}(match > 0); 
        
        x2 = x_points{1, (i + 1)}(match(match > 0));
        y2 = y_points{1, (i + 1)}(match(match > 0));
        
        corr{1, i, 1} = x1;
        corr{1, i, 2} = y1;
        corr{1, i, 3} = x2;
        corr{1, i, 4} = y2; 
    end
    
    %% estimate homographies
    mid_H = cell(1, 1);
    mid_H{1, 1} = eye(3);

    left_H = cell(1, midIndex - 1);
    
    for i = 1 : (midIndex - 1)
        x_source = corr{1, i, 1};
        y_source = corr{1, i, 2};
        
        x_dest = corr{1, i, 3};
        y_dest = corr{1, i, 4};
        
        [H, ~] = ransac_est_homography(x_source, y_source, x_dest, y_dest, 50);

        left_H{1, i} = H;
    end
    
    right_H = cell(1, number - midIndex);
    
    for i = 1 : (number - midIndex)
        x_source = corr{1, (midIndex + i - 1), 3};
        y_source = corr{1, (midIndex + i - 1), 4};
        
        x_dest = corr{1, (midIndex + i - 1), 1};
        y_dest = corr{1, (midIndex + i - 1), 2};
        
        [H, ~] = ransac_est_homography(x_source, y_source, x_dest, y_dest, 100);

        right_H{1, i} = H;
    end
    
    %% update homographies
    for i = (midIndex - 2) : -1 : 1
        first_H  = left_H{1, i};
        second_H = left_H{1, (i + 1)};
        
        new_H = first_H * second_H;
        left_H{1, i} = new_H;
    end

    for i = 2 : (number - midIndex)
        first_H  = right_H{1, (i - 1)};
        second_H = right_H{1, i};
        
        new_H = first_H * second_H;
        right_H{1, i} = new_H;
    end
    
    %% MOSAIC
    transforms = cell(1, number);
    
    for i = 1 : (midIndex - 1)
        transform_temp = projective2d(transpose(left_H{1, i}));
        transforms{1, i} = transform_temp;
    end
    
    transform_temp = projective2d(transpose(mid_H{1, 1}));
    transforms{1, midIndex} = transform_temp;
    
    for i = 1 : (number - midIndex)
        transform_temp = projective2d(transpose(right_H{1, i}));
        transforms{1, (midIndex + i)} = transform_temp;
    end
     
    %% world limits
    xlim = [];
    ylim = [];
    
    for i = 1 : number
        I = img_input{1, i};
        [xlim(i, :), ylim(i, :)] = outputLimits(transforms{1, i}, [1 size(I, 2)], [1 size(I, 1)]);
    end

    x_min = min(xlim(:));
    x_max = max(xlim(:));

    y_min = min(ylim(:));
    y_max = max(ylim(:));

    %% panorama
    I = img_input{1, i};
    panorama = imref2d(size(I), [x_min x_max], [y_min y_max]);

    output_img = cell(1, number);
    
    for i = 1 : number
        output_img{1, i} = imwarp(img_input{1, i}, transforms{1, i}, 'OutputView', panorama);
    end

    C = output_img{1, 1};
    
    for i = 2 : number
        C = alphaBlend(C, output_img{1, i}); 
    end
   
    img_mosaic = C;
end