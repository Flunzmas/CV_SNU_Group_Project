% Entry function for the preprocessing. Takes a given image and
% preprocesses it in order to facilitate the following component
% retrieving step.
function [im_mute, im_binarized, im_thin, ocrResult] = preprocess(im_original, answer)

%% preprocessing parameters
bin_threshold = 150/255;

%% image region choosing
% switch between response types
switch answer
    case 'Photo'
        % rectify before proceeding
        im_original = preprocessing.rectifyPaper(im_original);
end

% show image and let user select area of interest
imshow(im_original);
title('select area of filter');
coords = floor(ginput(2));
im_original = im_original(coords(1,2):coords(2,2),coords(1,1):coords(2,1));

%% OCR and text removal
imshow(im_original)
[im_mute, ocrResult] = preprocessing.ocrCircuit(im_original);
imshow(im_mute)

% TODO successive OCRs if still text present
% %open question dialog
% answer = questdlg('Still some text remaining?', ...
% 	'Remaining Text', ...
% 	'Yes', 'No','No');
% 
% %switch between response
% switch answer
%     case 'Yes'
%         %run with roi
%         title('select text area');
%         coords = floor(ginput(2));
%         
%         %[x y width height]
%         roi = [coords(1,1) coords(1,2) coords(2,1)-coords(1,1) coords(2,2)-coords(1,2)];
%         
%         [imO, ocrResult] = ocrCircuit(imO, roi);
%         
%         imshow(imO);
%         return;
%     case 'No'
%         %exit
%         return;
%     otherwise
%         return;
% end

%% convert to grayscale if colored
[~, ~, colors] = size(im_mute);
im_colorless = im_mute;
if colors > 1
    im_colorless = rgb2gray(im_mute);
end

%% generate binarized and thinned image
im_binarized = ~imbinarize(im_colorless, bin_threshold);
im_half_thin = bwmorph(im_binarized, 'thin');
im_thin = bwmorph(im_half_thin, 'thin');
