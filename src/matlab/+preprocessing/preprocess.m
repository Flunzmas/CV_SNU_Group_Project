% Entry function for the preprocessing. Takes a given image and
% preprocesses it in order to facilitate the following component
% retrieving step.
function [im_binarized, im_thin, im_edges] = preprocess(im_original)

%% preprocessing variables
bin_threshold = 128/255;

%% convert to grayscale if colored
[~, ~, colors] = size(im_original);
if colors > 1
    im_original = rgb2gray(im_original);
end

%% rectify the image. ASSERT: connections parallel to paper edges!
p_correspondences = preprocessing.detectPlane(im_original);
im_rectified = preprocessing.rectify(im_original, p_correspondences);

%% prepare different versions of the image
im_binarized = imbinarize(im_rectified, bin_threshold);
im_half_thin = bwmorph(im_binarized, 'thicken'); % 'thicken' is actually thinning the lines - don't ask me why!
im_thin = bwmorph(im_half_thin, 'thicken');
im_edges = edge(im_thin);
imshow(im_edges)