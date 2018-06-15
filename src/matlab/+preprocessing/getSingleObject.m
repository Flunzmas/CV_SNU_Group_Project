function imO = getSingleObject(imI)

%% settings

%threshold for binarizing
threshold = 102/255;

%% image processing

%convert image to grayscale
if size(imI, 3) > 1
    imI = rgb2gray(imI);
end

%binarize image with threshold
imI = imbinarize(imI, threshold);

%paper must be biggest area
imI = bwareafilt(imI,1);

%detect edges
imI = edge(imI, 'sobel');

%dilation and erosion
se = strel('disk', 2);
imI = imdilate(imI,se);
imI = imerode(imI,se);

%fill holes
imO = imfill(imI, 'holes');
