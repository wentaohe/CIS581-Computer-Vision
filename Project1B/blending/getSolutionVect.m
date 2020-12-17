function solVectorb = getSolutionVect(indexes, source, target, offsetX, offsetY)
%% Enter Your Code Here

laplacian=[0, -1, 0;
           -1, 4, -1;
           0, -1, 0;];
source = conv2(double(source), double(laplacian), 'same');
[index_row, index_col] = size(indexes);
[source_row, source_col] = size(source);

map = zeros(index_row + 2 * source_row, index_col + 2 * source_col);

row_start = source_row + offsetY + 1;
row_finish = row_start + source_row - 1;
col_start = source_col + offsetX + 1;
col_finish = col_start + source_col - 1;

map(row_start:row_finish, col_start:col_finish) = source; 
map = map(source_row + 1:source_row + index_row, source_col + 1:source_col + index_col);
mask = indexes>0;
map = mask .* map;
mask = ~mask;
targetmap = double(mask) .* double(target); 
resultmap = double(map) + double(targetmap);

[colInd, rowInd] = find(indexes'>0);
numPixel =size(rowInd, 1);
solVectorb = zeros(1, numPixel);

for i = 1:numPixel
    A = -1;
    B = -1;
    C = -1;
    D = -1;
    
    if (rowInd(i)+1) <= index_row
        A = indexes(rowInd(i)+1, colInd(i));
    end
    
    if (rowInd(i)-1)>=1
        B = indexes(rowInd(i)-1, colInd(i));
    end
    
    if (colInd(i)+1)<=index_col
        C = indexes(rowInd(i), colInd(i)+1);
    end
    
    if (colInd(i)-1)>=1
        D = indexes(rowInd(i), colInd(i)-1);
    end
    
    val = resultmap(rowInd(i), colInd(i));
    
    if A == 0
        val = val + resultmap(rowInd(i)+1, colInd(i));
    end
    
    if B == 0
        val = val + resultmap(rowInd(i)-1, colInd(i));
    end
    
    if C == 0
        val = val + resultmap(rowInd(i), colInd(i)+1);
    end
    
    if D == 0
        val = val + resultmap(rowInd(i), colInd(i)-1);
    end
    
    solVectorb(1, i) = val;
end

end
