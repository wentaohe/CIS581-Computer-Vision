img = imread('SourceImage.png');
targetImg = imread('TargetImage.png');
mask = maskImage(img);
offsetX = 200;
offsetY = 200;
resultImg = seamlessCloningPoisson(img, targetImg, mask, offsetX, offsetY);
imagesc(resultImg);