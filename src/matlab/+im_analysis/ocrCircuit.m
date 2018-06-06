function [imO, ocrResult] = ocrCircuit(imC, roi)

%% Init

%minium confidence
minConf = 0.8;

%location of trained ocr language
lang = 'circLang\tessdata\circLang.traineddata';

%block layout for best results
lay = 'Block';

%do some pre processing
imP = imcomplement(imbinarize(imsharpen(imC)));

%% OCR

%if there is a region specified
if nargin == 2
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