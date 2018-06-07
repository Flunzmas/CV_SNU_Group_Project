%important script

if 1
    i_test      = im2double(imread('002-notext.png'));
    resSize001  = [89 180];
    resSize002  = [90 184];
    
    elemList    = im_analysis.detectElements(i_test, resSize002);
    
end


if 0
    i_temp_cap  = rgb2gray(im2double(imread('001-cap.png')));
    i_test      = rgb2gray(im2double(imread('001-notext.png')));

    im_analysis.getErrorImage(i_temp_cap, i_test, 1);
end