function M = nonMaxSup(Mag, Ori)
%%  Description
%       compute the local minimal along the gradient.
%%  Input: 
%         Mag = (H, W), double matrix, the magnitude of derivative 
%         Ori = (H, W), double matrix, the orientation of derivative
%%  Output:
%         M = (H, W), logic matrix, the edge map
%
%% ****YOU CODE STARTS HERE**** 

%% Parameters
alpha = 0.1; %threshold parameter
%alpha = 0.2;
%alpha = 0.3;
real_max = max(max(Mag));
real_min = min(min(Mag));
th_level = alpha * (real_max - real_min) + real_min;
[H, W] = size(Mag);
M = zeros(H, W);
X = [-1, 0, 1;
    -1, 0, 1;
    -1, 0, 1];
Y = [-1, -1, -1;
    0, 0, 0;
    1, 1, 1];

%% Fixing orientation
for i = 1 : H
    for j = 1 : W
        if (Ori(i, j) < 0) 
            Ori(i, j)= 180 + Ori(i, j);
        end
    end
end

%% Thresholding
for row = 2 : H-1
    for col = 2 : W-1
        if Mag(row, col) > th_level
            Z = [Mag(row - 1, col -1 ), Mag(row - 1,col), Mag(row - 1, col + 1);
                 Mag(row, col - 1), Mag(row, col),Mag(row, col + 1);
                 Mag(row + 1, col - 1), Mag(row + 1, col), Mag(row + 1, col + 1)];
            XI = [abs(cos(Ori(row, col))), -abs(cos(Ori(row, col)))];
            YI = [abs(sin(Ori(row, col))), -abs(sin(Ori(row, col)))];
            ZI = interp2(X, Y, Z, XI, YI);
            if Mag(row, col) >= ZI(1) && Mag(row, col) >= ZI(2)
                M(row, col) = real_max;
            else
            	M(row, col) = th_level;
            end
        else
            M(row, col)=real_min;
        end
    end
end
end