function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
%% Enter Your Code Here

[row, col] = size(mask);

indexes = zeros(targetH + 2 * row, targetW + 2 * col);

row_start = row + offsetY +1;
row_finish = row_start + row - 1;
col_start = col + offsetX + 1;
col_finish = col_start + col - 1;

indexes(row_start:row_finish, col_start:col_finish) = mask;

indexes = indexes(row+1:row +targetH, col+1:col+targetW);

counter = 1;

for i = 1:targetH
    for j = 1:targetW
        if indexes(i, j) == 1
            indexes(i, j) = counter;
            counter = counter + 1;
        end
    end
end

end