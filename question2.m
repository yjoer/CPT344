Image1=imread('36290692-shapes.jpg');
figure(1),imshow(Image1);
title('original image');

redChannel = Image1(:,:,1);
greenChannel = Image1(:,:,2);
blueChannel = Image1(:,:,3);

grayImage = rgb2gray(Image1);
figure(2),imshow(Image1);
title("Color detected image");

BW = im2bw(grayImage,0.9);
BW=~BW;
[L,n] = bwlabel(BW);

statsRed = regionprops(L, redChannel, 'centroid', 'MeanIntensity');
statsGreen = regionprops(L, greenChannel, 'centroid', 'MeanIntensity');
statsBlue = regionprops(L, blueChannel, 'centroid', 'MeanIntensity');

redIntensity = [statsRed.MeanIntensity];
greenIntensity = [statsGreen.MeanIntensity];
blueIntensity = [statsBlue.MeanIntensity];

