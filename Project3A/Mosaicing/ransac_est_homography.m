% File name: ransac_est_homography.m
% Author: Wentao He
% Date created: Nov. 1st, 2018

function [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, thresh)
% Input:
%    y1, x1, y2, x2 are the corresponding point coordinate vectors Nx1 such
%    that (y1i, x1i) matches (x2i, y2i) after a preliminary matching
%    thresh is the threshold on distance used to determine if transformed
%    points agree

% Output:
%    H is the 3x3 matrix computed in the final step of RANSAC
%    inlier_ind is the nx1 vector with indices of points in the arrays x1, y1,
%    x2, y2 that were found to be inliers

% Write Your Code Here
    numDataPoints = size(x1, 1);
    N = 10000; 
    NMax = 100000;
    HBest = [];
    InliersBest = 0;
    
    i = 0;
    
    while (i < N)
        % Randomly sample four feature pairs.
        idx = randperm(size(x1, 1));
        idx = idx(1:4);
        
        x_source = x1(idx);
        y_source = y1(idx);
        
        x_dest = x2(idx);
        y_dest = y2(idx);
        
        HTemp = est_homography(x_dest, y_dest, x_source, y_source);
        [xDestTemp, yDestTemp] = apply_homography(HTemp, x1, y1);   
        inlier_ind_temp = ((xDestTemp - x2).^2 + (yDestTemp - y2).^2 < thresh);
        InliersTemp = sum(inlier_ind_temp);

        if (InliersTemp > InliersBest)
            InliersBest = InliersTemp;
            HBest = HTemp;   
            
            e = (numDataPoints - InliersBest) / numDataPoints; 
            p = 0.99;
            s = 4;
            
            NTemp = log(1 - p) / log(1 - (1 - e)^s);

            if (NTemp > N)
                if (NTemp > NMax)
                    N = NMax;
                else
                    N = NTemp;
                end
            end
        end
        
        i = i + 1;
    end
    
    H = HBest;  
    [xDestTemp, yDestTemp] = apply_homography(H, x1, y1);
    inlier_ind = ((xDestTemp - x2).^2 + (yDestTemp - y2).^2 < thresh);
end