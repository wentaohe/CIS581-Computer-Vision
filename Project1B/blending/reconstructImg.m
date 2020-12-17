function resultImg = reconstructImg(indexes, red, green, blue, targetImg)
%% Enter Your Code Here
[col, row] = find(indexes'>0);

for i = 1:size(row, 1)
    targetImg(row(i), col(i), 1) = red(1,i);
    targetImg(row(i), col(i), 2) = green(1,i);
    targetImg(row(i), col(i), 3) = blue(1,i);
end

resultImg = uint8(targetImg);

end