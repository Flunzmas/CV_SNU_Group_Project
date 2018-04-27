% Entry function for the preprocessing. Takes a given image and
% preprocesses it in order to facilitate the following component
% retrieving step.
function [im_binarized, im_edges] = preprocess(im_original)

%% preprocessing variables
bin_threshold = 128/255;

%% rectify the image
im_rectified = preprocessing.rectify(im_original);

%% prepare different versions of the image
im_binarized = imbinarize(im_rectified, bin_threshold);
im_edges = edge(im_rectified);
imshow(im_edges)