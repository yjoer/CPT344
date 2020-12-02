clear
clc
close all

% Custom Parameters
debug = true;
with_shape = true;
with_colour = true;

filter = false;
complement = true;
threshold = 0.88;

% Read Image
image=imread('3.3.png');

if (debug == true)
    figure(1), imshow(image);
    title('Original Image');
end

if (filter == true)
    % 3x3 mean filter
    % filterWindow = ones(3) / 9;
    % image = imfilter(image, filterWindow);
    
    % Gaussian filter
    image = imgaussfilt(image, 0.5);
    
    if (debug == true)
        figure(2), imshow(image);
        title('Filtered Image');
    end
end

% Convert rgb image to grayscale image
grayImage=rgb2gray(image);

if (debug == true)
    figure(3), imshow(grayImage);
    title('Grayscale Image');
end

% Convert grayscale image into black and white image
% Preparation for the boundary tracing using bwboundaries
if (threshold == -1)
    threshold = graythresh(grayImage);
end

BW = imbinarize(grayImage, threshold);

if (complement == true)
    BW = imcomplement(BW);
end

if (debug == true)
    figure(4), imshow(BW);
    title('Binary Image');
end

% Get label matrix of contiguous region
[L,n] = bwlabel(BW);

figure(5), imshow(image);
title('Final Image');

hold on
if (with_shape == true)
    [centroids, shape_texts] = recognize_shape(debug, L);
end
if (with_colour == true)
    [centroids, colour_texts] = recognize_colour(debug, image, L);
end

for c = 1:length(centroids)
    labels = [shape_texts{c}, colour_texts{c}];
    text(centroids{c}(1), centroids{c}(2), labels, 'HorizontalAlignment', 'center');
end

function [centroids, labels] = recognize_shape(debug, label)
    % Get properties of the image region
    stats  = regionprops(label, 'all');
    
    centroids = {};
    labels = {};
    
    % Traverse every object in the image region
    % Recognize shape using image properties
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

        % Plot extrema points
        if (debug == true)
            hold on;
            plot(extrema(:,1), extrema(:,2), 'ko');
        end
        
        shapeName = {};

        if (abs(bbox(3) - bbox(4)) < 10 && abs(extent - 1) < 0.01)
            shapeName{end+1} = 'square';
        end
        if (abs(bbox(3) - bbox(4)) > 10 && abs(extent - 1) < 0.01)
            shapeName{end+1} = 'rectangle';
        end
        if (abs(topLeftX - topRightX) < 5 &&...
            abs(rightTopX - rightBottomX) < 5 &&...
            abs(rightBottomX - bottomRightX) < 5 &&...
            abs(bottomLeftX - leftBottomX) < 5 &&...
            abs(leftBottomX - leftTopX) < 5 &&...
            extent ~= 1)
            shapeName{end+1} = 'triangle';
        end
        if (abs(topLeftX - topRightX) < 5 &&...
            abs(rightTopX - rightBottomX) < 5 &&...
            abs(bottomRightX - bottomLeftX) < 5 &&...
            abs(leftBottomX - leftTopX) < 5 &&...
            extent ~= 1)
            shapeName{end+1} = 'diamond';
        end
        if (abs(topLeftX - topRightX) > 10 &&...
            (topLeftX - bottomLeftX) > 10 &&...
            (topRightX - bottomRightX) > 10)
            shapeName{end+1} = 'parallelogram';
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
        
        centroids{end+1} = centroid;
        labels{end+1} = {strjoin(shapeName, ', ')};
    end
end