function E = edgeLink(M, Mag, Ori)
%%  Description
%       use hysteresis to link edges
%%  Input: 
%        M = (H, W), logic matrix, output from non-max suppression
%        Mag = (H, W), double matrix, the magnitude of gradient
%    		 Ori = (H, W), double matrix, the orientation of gradient
%
%%  Output:
%        E = (H, W), logic matrix, the edge detection result.
%
%% ****YOU CODE STARTS HERE**** 
%T_Low = 0.075; %low threshold
T_Low = 0.135;
%T_High = 0.175; %high threshold
T_High = 0.5;
T_Low = T_Low * max(max(M));
T_High = T_High * max(max(M));
[H, W] = size(Mag);
E = zeros (H, W);

for row = 1  : H
    for col = 1 : W
        if (M(row, col) < T_Low)
            E(row, col) = 0;
        elseif (M(row, col) > T_High)
            E(row, col) = 1;
        elseif (M(row + 1, col)>T_High ||...
                M(row - 1, col)>T_High ||...
                M(row, col + 1)>T_High ||...
                M(row, col - 1)>T_High ||...
                M(row - 1, col - 1)>T_High ||...
                M(row - 1, col + 1)>T_High ||...
                M(row + 1, col + 1)>T_High ||...
                M(row + 1, col - 1)>T_High)
            E(row, col) = 1;
        end
    end
end

E = logical(E);

end