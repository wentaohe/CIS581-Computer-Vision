function resultImg = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY)
%% Enter Your Code Here

[targetH, targetW, ~] = size(targetImg);
index = getIndexes(mask, targetH, targetW, offsetX, offsetY);

coeffA = getCoefficientMatrix(index);

R = getSolutionVect(index, double(sourceImg(:,:,1)), double(targetImg(:,:,1)), offsetX, offsetY);
G = getSolutionVect(index, double(sourceImg(:,:,2)), double(targetImg(:,:,2)), offsetX, offsetY);
B = getSolutionVect(index, double(sourceImg(:,:,3)), double(targetImg(:,:,3)), offsetX, offsetY);

R=coeffA\(R');
G=coeffA\(G');
B=coeffA\(B');

resultImg=reconstructImg(index, R', G', B', targetImg);


end