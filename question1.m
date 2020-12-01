%Read Image
Image1=imread('1.png');
%figure(1),imshow(Image1);
%title('original image');

%Convert rgb image from to grayscale image
grayImage=rgb2gray(Image1);
%figure(2),imshow(grayImage);
%title('grayscale image');

%Convert it into black and white image
%Preparation for the boundary tracing using bwboundaries
threshold = graythresh(grayImage);
BW = im2bw(grayImage, threshold);
%BW = imcomplement(BW);
%figure(3),imshow(BW);
%title('binary image');

%get label matrix of contiguous region
[L,n] = bwlabel(BW);

%get properties of the image region
stats  = regionprops(L, 'all');

figure(2),imshow(Image1);
title('final image');

hold on
%traverse every object in the image region
%recognize shape using image properties
for x = 1:length(stats)
    centroid = stats(x).Centroid;
    extent = stats(x).Extent;
    bbox = stats(x).BoundingBox;
    extrema = stats(x).Extrema;
    
    hold on;
    plot(extrema(:,1), extrema(:,2), 'ko');
    
    text(centroid(1) + 40, centroid(2), string());
    
    if (abs(bbox(3)-bbox(4))<10&&extent==1)
        text(centroid(1)-22,centroid(2),'square');
    end
    if (abs(bbox(3)-bbox(4))>10&&extent==1)
        text(centroid(1)-25,centroid(2),'rectangle');
    end
    if (((abs(extrema(1,1)-extrema(2,1)))<2)&&((abs(extrema(3,1)-extrema(4,1)))<2)...
        &&((abs(extrema(4,1)-extrema(5,1)))<2)&&((abs(extrema(6,1)-extrema(7,1)))<2)...
        &&((abs(extrema(7,1)-extrema(8,1)))<2)&&extent~=1)
        text(centroid(1)-20,centroid(2),'triangle');
    end
    if (((abs(extrema(1,1)-extrema(2,1)))<2)&&((abs(extrema(3,1)-extrema(4,1)))<2)...
        &&((abs(extrema(5,1)-extrema(6,1)))<2)&&((abs(extrema(7,1)-extrema(8,1)))<2)&&extent~=1)
        text(centroid(1)-25,centroid(2),'diamond');
    end
    if (abs(bbox(3)-bbox(4))<10&&extent~=1)
        text(centroid(1)-17,centroid(2),'circle');
    end
    if (abs(extrema(1, 1) - extrema(2, 1)) > 2 &&...
        abs(extrema(5, 1) - extrema(6, 1)) > 2 &&...
        abs(bbox(3)-bbox(4))>10&&extent~=1)
        text(centroid(1)-15,centroid(2),'ellipse');
    end
end
