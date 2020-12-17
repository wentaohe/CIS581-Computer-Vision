files = dir('canny_dataset/*.jpg');
%files = dir('training_photos/*.jpg');
len = length(files);
for i = 1: len
    oldname = files(i).name;
    I = imread(['canny_dataset/',oldname]);
    newfile = cannyEdge(I);
    
    pass = true;
    
    if ndims(newfile) ~= 2
    fprintf('incorrect edge map size\n');
    pass = false;
    end

    szI = size(I);
    szE = size(newfile);
    if(szI(1) ~= szE(1) || szI(2) ~= szE(2))
        fprintf('Edge map not the same size as the input image\n');
        pass = false;
    end

    if ~isa(newfile,'logical')
        fprintf('Edge map is not logical\n');
        pass = false;
    end

    if pass
        fprintf(['Tests Passed for ', oldname, '\n']);
    end
    
    oldname = files(i).name(1: end - 4);
    imwrite(newfile, [oldname, '_result.jpg'])
end
