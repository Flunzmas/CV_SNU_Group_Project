function [coords, i_max] = getMaxima(i_err)
%Given an error image (i_err), the function getMaxima returns a matrix of
%coordinates, where maxima have been found. The matrix has the following 
%format: 
%Every row is a new maximum. 
%Column 1 is the row-coordinate of the maximum.
%Column 2 is the col-coordinate of the maximum
%It also returns the binarized image from which the maximums have been
%collected.

%fprintf("   >Start\tgetMaxima");
vis = 0;

%% Binarize maxima
    %Binarize maxima
    minMaxErr   = round(min(max(i_err)), 4);
    i_sup       = imhmin(i_err, minMaxErr * 0.9);
    maxMaxSup   = round(max(max(i_sup)), 4);
    i_supBin    = imbinarize(i_sup, maxMaxSup * 0.9);
    
    %Check for faulty binarization type 1 - all white
    if sum(sum(i_supBin)) >= numel(i_err) * 0.8
        coords  = NaN;
        i_max   = i_supBin;
        %fprintf("\t\t...Ended - Type 1 failure\n");
        if 0    %Compare error image and minima supressed image
            f = figure;
            colormap('gray');
            subplot(1,3,1), imagesc(i_err),     title("Input - err Image");
            subplot(1,3,2), imagesc(i_sup),     title("Minima supressed");
            subplot(1,3,3), imagesc(i_supBin),  title("Binarized");
            waitfor(f)    
        end
        return
    end
    
    %Check for faulty binarization type 2 - white stripes
    if max(sum(i_supBin, 1)) >= size(i_supBin, 1) * 0.1 ...
    || max(sum(i_supBin, 2)) >= size(i_supBin, 2) * 0.1
        coords  = NaN;
        i_max   = i_supBin;
        %fprintf("\t\t...Ended - Type 2 failure\n");
        if 0    %Compare error image and minima supressed image
            f = figure;
            colormap('gray');
            subplot(1,3,1), imagesc(i_err),     title("Input - err Image");
            subplot(1,3,2), imagesc(i_sup),     title("Minima supressed");
            subplot(1,3,3), imagesc(i_supBin),  title("Binarized");
            waitfor(f)    
        end
        return
    end
    
    
%% Get coordinates of maxima
    comp    = bwconncomp(i_supBin);             %returns a cell array with found objects
    centers = regionprops(comp, 'Centroid');    %get centroids of found objects
    elemN   = size(centers, 1);                 %number of found objects
    coords  = zeros(elemN, 2);                  %init coords matrix
    for i = 1:elemN
        coords(i, 1)    = centers(i).Centroid(2);   %get row
        coords(i, 2)    = centers(i).Centroid(1);   %get col
    end
    
%% Visualization
if vis    %Compare error image and minima supressed image
    f = figure;
    colormap('gray');
    subplot(1,3,1), imagesc(i_err),     title("Input - err Image");
    subplot(1,3,2), imagesc(i_sup),     title("Minima supressed");
    subplot(1,3,3), imagesc(i_supBin),  title("Binarized");
    waitfor(f)    
end

if vis    %Compare minima supressed image and 
    f = figure;
    colormap('gray');
    subplot(1,2,1), imagesc(i_sup),     title("Minima supressed");
    subplot(1,2,2), imagesc(i_supBin),  title("Binarized");
    waitfor(f) 
end

%% Return
    i_max   = i_supBin;

%fprintf("\t\t...Ended - successfull\n");

return