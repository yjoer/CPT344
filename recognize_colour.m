function [centroids, labels] = recognize_colour(debug, image, label)
    redChannel = image(:,:,1);
    greenChannel = image(:,:,2);
    blueChannel = image(:,:,3);
    
    statsRed = regionprops(label, redChannel, 'centroid', 'MeanIntensity');
    statsGreen = regionprops(label, greenChannel, 'MeanIntensity');
    statsBlue = regionprops(label, blueChannel, 'MeanIntensity');
    
    centroids = {};
    labels = {};
    
    for x = 1:length(statsRed)
        centroid = statsRed(x).Centroid;
        
        red = statsRed(x).MeanIntensity;
        green = statsGreen(x).MeanIntensity;
        blue = statsBlue(x).MeanIntensity;
        
        rgb = [red, green, blue];
        lab = rgb2lab(rgb / 255);
        
        texts = {};
        
        % Read colour table from a CSV file
        colours = readmatrix('colours.csv', 'OutputType', 'string');
        
        % Find the closest colour
        minDistance = -1;
        minIndex = 1;
        
        for c = 1:length(colours)
            refRgb = [colours(c, 4), colours(c, 5), colours(c, 6)];
            refRgb = str2double(refRgb);
            refLab = rgb2lab(refRgb / 255);
            
            % Remove square root to speed up calculation
            distance = (...
                (lab(1) - refLab(1))^2 +...
                (lab(2) - refLab(2))^2 +...
                (lab(3) - refLab(3))^2 ...
            );
            
            if (minDistance == -1 || distance < minDistance)
                minDistance = distance;
                minIndex = c;
            end
        end
        
        name = colours(minIndex, 2);
        texts{end+1} = name;
        
        if (debug == true)
            texts{end+1} = string(minDistance);
            texts{end+1} = join(string(rgb));
            texts{end+1} = join(string(lab));
        end
        
        centroids{end+1} = centroid;
        labels{end+1} = texts;
    end
end