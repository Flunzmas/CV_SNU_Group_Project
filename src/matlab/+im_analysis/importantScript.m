%important script

i_temp_cap  = rgb2gray(im2double(imread('001-cap.png')));
i_test      = rgb2gray(im2double(imread('001-notext.png')));

im_analysis.getErrorImage(i_temp_cap, i_test, 1);