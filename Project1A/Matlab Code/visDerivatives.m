function visDerivatives(I_gray, Mag, Magx, Magy)
%% Visualize magnitude and orientation of derivatives

figure('Name', 'Mag'); imagesc(Mag); colormap(gray);
figure('Name', 'Magx'); imagesc(Magx); colormap(gray);
figure('Name', 'Magy'); imagesc(Magy); colormap(gray);


%% Visualize orientation of derivatives
[cnt, val] = hist(Mag(:), 100);
thr = val(find(cumsum(cnt) / sum(cnt) < 0.95, 1, 'last'));

[x, y] = meshgrid(1 : size(I_gray, 2), 1 : size(I_gray, 1));
Magx(Mag < thr) = 0; 
Magy(Mag < thr) = 0;
figure('Name', 'Orientation of derivatives'); imshow(I_gray); hold on
quiver(x, y, Magx, Magy,'AutoScale', 'off');
hold off

end
