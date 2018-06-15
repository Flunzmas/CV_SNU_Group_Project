function [imO, ocrResult] = ocrCircuit(imC, answer, roi)

%% Init

%minium confidence
minConf = 0.8;

% if answer is a photo
if strcmp(answer, 'Photo')
    minConf = 0.825;
end 


%location of trained ocr language
lang = 'src\matlab\+preprocessing\circLang\tessdata\circLang.traineddata';

%block layout for best results
lay = 'Block';

%rgb?
if size(imC, 3) > 1
    imC = rgb2gray(imC);
end

%do some pre processing
imP = imcomplement(imC);

%% OCR

%if there is a region specified
if nargin == 3
    minConf = minConf - 0.2;  %lower confidence
    ocrData = ocr(imP, roi, 'Language', lang, 'TextLayout', lay);
else
    ocrData = ocr(imP, 'Language', lang, 'TextLayout', lay);
end

%% Result extraction

%find confident words
minConfInd = ocrData.WordConfidences > minConf;

%extract words and boxes with min confidence
ocrResult.wordBoundingBoxes = ocrData.WordBoundingBoxes(minConfInd, :);
ocrResult.words = ocrData.Words(minConfInd, :);

%in case of empty results with high confidence??
empt = cellfun('isempty', ocrResult.words);

%remove errors
ocrResult.wordBoundingBoxes(empt,:) = [];
ocrResult.words(empt) = [];

%% Image post processing

%create invisible figure with image
tempF = figure;
set(tempF, 'Visible', 'off');
imshow(imC, 'border', 'tight');

%draw rectangle on locations with text
hold on;
for pos=1:length(ocrResult.words)
    rectangle('Position', ocrResult.wordBoundingBoxes(pos, :), 'FaceColor','w','EdgeColor','w', 'LineWidth', 2);
end

%extract image from figure
tempFr = getframe(tempF);
close(tempF);
imO = tempFr.cdata;