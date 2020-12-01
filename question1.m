clear
clc
close all

% Custom Parameters
threshold = 0.88;
complement = true;

%Read Image
Image1=imread('3.1.png');
%figure(1),imshow(Image1);
%title('original image');

%Convert rgb image from to grayscale image
grayImage=rgb2gray(Image1);
%figure(2),imshow(grayImage);
%title('grayscale image');

%Convert it into black and white image
%Preparation for the boundary tracing using bwboundaries
if (threshold == -1)
    threshold = graythresh(grayImage);
end

BW = im2bw(grayImage, threshold);

if (complement == true)
    BW = imcomplement(BW);
end

figure(3),imshow(BW);
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
    circularity = stats(x).Circularity;
    extent = stats(x).Extent;
    bbox = stats(x).BoundingBox;
    extrema = stats(x).Extrema;
    
    majorAxisLength = stats(x).MajorAxisLength;
    minorAxisLength = stats(x).MinorAxisLength;
    
    topLeftX = extrema(1,1);
    topRightX = extrema(2,1);
    rightTopX = extrema(3,1);
    rightBottomX = extrema(4,1);
    bottomRightX = extrema(5,1);
    bottomLeftX = extrema(6,1);
    leftBottomX = extrema(7,1);
    leftTopX = extrema(8,1);
    
    topLeftY = extrema(1,2);
    topRightY = extrema(2,2);
    rightTopY = extrema(3,2);
    rightBottomY = extrema(4,2);
    bottomRightY = extrema(5,2);
    bottomLeftY = extrema(6,2);
    leftBottomY = extrema(7,2);
    leftTopY = extrema(8,2);
    
    hold on;
    plot(extrema(:,1), extrema(:,2), 'ko');
    
    shapeName = {};
    
    if (abs(bbox(3) - bbox(4)) < 10 && extent == 1)
        shapeName{end+1} = 'square';
    end
    if (abs(bbox(3) - bbox(4)) > 10 && extent == 1)
        shapeName{end+1} = 'rectangle';
    end
    if (((abs(extrema(1,1)-extrema(2,1)))<3)&&((abs(extrema(3,1)-extrema(4,1)))<2)...
        &&((abs(extrema(4,1)-extrema(5,1)))<2)&&((abs(extrema(6,1)-extrema(7,1)))<2)...
        &&((abs(extrema(7,1)-extrema(8,1)))<2)&&extent~=1)
        shapeName{end+1} = 'triangle';
    end
    if (((abs(extrema(1,1)-extrema(2,1)))<3)&&((abs(extrema(3,1)-extrema(4,1)))<2)...
        &&((abs(extrema(5,1)-extrema(6,1)))<3)&&((abs(extrema(7,1)-extrema(8,1)))<2)&&extent~=1)
        shapeName = [shapeName, 'diamond'];
    end
    if (abs(topLeftX - topRightX) > 10 &&...
        (topLeftX - bottomLeftX) > 10 &&...
        (topRightX - bottomRightX) > 10)
        shapeName = [shapeName, 'parallelogram'];
    end
    if (abs(topLeftX - topRightX) > 10 &&...
        (topLeftX - bottomLeftX) > 10 &&...
        (topRightX - bottomRightX) < -10)
        shapeName{end+1} = 'trapezium';
    end
    if (abs(topLeftX - topRightX) < 5 &&...
        abs(rightTopX - rightBottomX) < 5 &&...
        abs(bottomLeftX - bottomRightX) > 10 &&...
        abs(leftTopX - leftBottomX) < 5 &&...
        ...
        abs(topRightY - rightTopY) > 10 &&...
        abs(rightTopY - rightBottomY) < 5 &&...
        abs(rightBottomY - bottomRightY) > 10 &&...
        ...
        abs(topLeftY - leftTopY) > 10 &&...
        abs(leftTopY - leftBottomY) < 5 &&...
        abs(leftBottomY - bottomLeftY) > 10)
        shapeName{end+1} = 'pentagon';
    end
    if (abs(topLeftX - topRightX) > 10 &&...
        abs(rightTopX - rightBottomX) < 5 &&...
        abs(bottomLeftX - bottomRightX) > 10 &&...
        abs(leftTopX - leftBottomX) < 5 &&...
        ...
        abs(topRightY - rightTopY) > 10 &&...
        abs(rightTopY - rightBottomY) < 5 &&...
        abs(rightBottomY - bottomRightY) > 10 &&...
        ...
        abs(topLeftY - leftTopY) > 10 &&...
        abs(leftTopY - leftBottomY) < 5 &&...
        abs(leftBottomY - bottomLeftY) > 10)
        shapeName{end+1} = 'hexagon';
    end
    if (abs(topLeftX - topRightX) > 10 &&...
        abs(rightTopX - leftTopX) > 10 &&...
        abs(rightBottomX - leftBottomX) > 10 &&...
        abs(bottomLeftX - bottomRightX) > 10 &&...
        ...
        abs(topRightY - rightTopY) > 10 &&...
        abs(rightTopY - rightBottomY) > 10 &&...
        abs(rightBottomY - bottomRightY) > 10 &&...
        ...
        abs(topLeftY - leftTopY) > 10 &&...
        abs(leftTopY - leftBottomY) > 10 &&...
        abs(leftBottomY - bottomLeftY) > 10)
        shapeName{end+1} = 'octagon';
    end
    if (abs(bbox(3) - bbox(4)) < 5 &&...
        abs(circularity - 1) < 0.01 &&...
        extent ~= 1)
        shapeName{end+1} = 'circle';
    end
    if (abs(bbox(3) - bbox(4)) > 10 &&...
        (abs(majorAxisLength - bbox(3)) < 5 || abs(majorAxisLength - bbox(4)) < 5) &&...
        (abs(minorAxisLength - bbox(3)) < 5 || abs(minorAxisLength - bbox(4)) < 5) &&...
        extent ~= 1)
        shapeName{end+1} = 'ellipse';
    end
    
    text(centroid(1), centroid(2), strjoin(shapeName, ', '), 'HorizontalAlignment', 'center');
end
