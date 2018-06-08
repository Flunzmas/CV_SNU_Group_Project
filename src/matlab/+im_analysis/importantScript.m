%Demo Script

%% Demo ppDetection
    i_temp_res  = rgb2gray(im2double(imread('001-res.png')));
    i_test      = rgb2gray(im2double(imread('001-notext.png')));

    bw_thresh   = 150/200;
    t_param     = 20;        %start value
    sigma       = 1;
    scale       = 0.25;
    
    temp_PP     = im_analysis.ppDetection(i_temp_res, bw_thresh, t_param, sigma, scale);
    test_PP     = im_analysis.ppDetection(i_test,     bw_thresh, t_param, sigma, scale);

    
%% Demo getErrorImage
    i_temp_res  = rgb2gray(im2double(imread('001-res.png')));
    i_test      = rgb2gray(im2double(imread('001-notext.png')));

    i_err       = im_analysis.getErrorImage(i_temp_res, i_test, 1);
    imagesc(i_err);
    colormap('gray');
    
    
%% Demo detectElements
    i_test      = im2double(imread('002-notext.png'));
    resSize001  = [89 180];
    resSize002  = [90 184];
    
    elemList    = im_analysis.detectElements(i_test, resSize002);


