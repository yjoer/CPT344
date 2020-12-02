clear
clc
close all

% Custom Parameters
debug = false;
with_shape = true;
with_colour = true;

filter = false;
complement = true;
threshold = 0.88;

save_output = false;

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
    if (with_shape == true)
        labels = shape_texts{c};
    end
    if (with_colour == true)
        labels = colour_texts{c};
    end
    if (with_shape == true && with_colour == true)
        labels = [shape_texts{c}, colour_texts{c}];
    end
    
    text(centroids{c}(1), centroids{c}(2), labels, 'HorizontalAlignment', 'center');
end

if (save_output == true)
    saveas(figure(5), 'out.png');
end