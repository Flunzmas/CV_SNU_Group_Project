% analyse image interface example

% Input image - rectified, RGB, no text
i_testRGB   = im2double(imread('001-notext.png'));

% Size of resistor, in pixels
resSize     = [91 181];

%Call analyseImage function
elemList    = detectElements(i_testRGB, resSize);