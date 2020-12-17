function [img_blend] = alphaBlend(I1, I2)    
    I1_gray = rgb2gray(I1);
    I2_gray = rgb2gray(I2);
    I1_bin = (I1_gray > 0);
    I2_bin = (I2_gray > 0);
    I1_bin_inv = (I1_bin == 0);
    I2_bin_inv = (I2_bin == 0);
    I1_dist = bwdist(I1_bin_inv);
    I2_dist = bwdist(I2_bin_inv);
    
    alpha1 = I1_dist ./ (I1_dist + I2_dist);
    alpha1(isnan(alpha1)) = 0;
    I1 = im2double(I1) .* repmat(alpha1, [1, 1, 3]);
    I1 = uint8(255 * I1);
    
    alpha2 = I2_dist ./ (I1_dist + I2_dist);
    alpha2(isnan(alpha2)) = 0;
    I2 = im2double(I2) .* repmat(alpha2, [1, 1, 3]);
    I2 = uint8(255 * I2);
    
    img_blend = imadd(I1, I2);
end