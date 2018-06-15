% Entry function for the preprocessing. Takes a given image and
% preprocesses it in order to facilitate the following component
% retrieving step.
function [im_mute, im_binarized, im_thin, ocrResult] = preprocess(im_original, answer)

%% preprocessing parameters
bin_threshold = 150/255;

%% image region choosing
% if answer is a photo
if strcmp(answer, 'Photo')
    % rectify before proceeding
    im_original = preprocessing.rectifyPaper(im_original);
end

% show image and let user select area of interest
imshow(im_original);
title('select area of filter');
coords = floor(ginput(2));

% select area
im_original = im_original(coords(1,2):coords(2,2),coords(1,1):coords(2,1));

%% OCR and text removal
% imshow(im_original) ### no need for this I think ###

% if answer is a photo
if strcmp(answer, 'Photo')
    % im_dual = imbinarize(im_original, mean(im_original(:)*0.9));
    % im_dual = imbinarize(im_original, 'adaptive','ForegroundPolarity','dark','Sensitivity', mean(imcomplement(im_original(:)))*1.6);

    % im_dual = (medfilt2(im_dual));
    % im_dual = (medfilt2(im_dual));
else
    im_dual = imbinarize(im_original);
end 

[im_mute, ocrResult] = preprocessing.ocrCircuit(im_dual, answer);

% until user action
while(1)
    
    % show image
    imshow(im_mute);
    
    % open question dialog
    answer = questdlg('Did I remove all the text?', ...
        'Remaining Text', ...
        'Yes', 'No','Yes');
    
    % break loop
    if(strcmp(answer,'Yes'))
        break;
    end

    % retrieve coordinates
    title('select text area');
    coords = floor(ginput(2));
    
    % convert to roi syntax
    roi = [coords(1,1) coords(1,2) coords(2,1)-coords(1,1) coords(2,2)-coords(1,2)];

    %detect again with new roi
    [im_mute, ocrResultN] = preprocessing.ocrCircuit(im_mute, answer, roi);
    
    % append result
    if(~isempty(ocrResultN.words))
        ocrResult.wordBoundingBoxes(end+1,:) = ocrResultN.wordBoundingBoxes;
        ocrResult.words{end+1} = ocrResultN.words{:};
    end
end

left = [];
right = [];

% check for split ()
for k=1:numel(ocrResult.words)
    ocrResult.words{k} = strrep(ocrResult.words{k},'I.','L');
    if(strfind(ocrResult.words{k}, '('))
        left = k;
    elseif(strfind(ocrResult.words{k}, ')'))
        right = k;
    end
end

% concatenate
if(~isempty(left) && ~isempty(right))
    
    % rewrite left
    ocrResult.words{left} = [ocrResult.words{left} ' ' ocrResult.words{right}];
    ocrResult.wordBoundingBoxes(left, :) = [ocrResult.wordBoundingBoxes(left, 1) ...
                                            ocrResult.wordBoundingBoxes(right, 2) ...
                                            ocrResult.wordBoundingBoxes(left, 3) ...
                                            ocrResult.wordBoundingBoxes(right, 4) ];
                   
    % delete right
    ocrResult.words(right) = [];
    ocrResult.wordBoundingBoxes(right,:) = [];
end

ocrResult.words

%erode result if photo
if strcmp(answer, 'Photo')
    SE = strel('cube',4);
    im_mute = imerode(im_mute, SE);
end 

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