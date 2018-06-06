% Testing Script for Basic Detection

%% Load template and testing image
    % T1 series - simple detection no scaling
     i_temp1     = rgb2gray(im2double(imread('T1_temp1.png')));
%     i_temp2     = rgb2gray(im2double(imread('T1_temp2.png')));
%     
%     i_test1     = rgb2gray(im2double(imread('T1_01_27,70.png')));
%     i_test2     = rgb2gray(im2double(imread('T1_02_72,41.png')));
%     i_test3     = rgb2gray(im2double(imread('T1_03_39,22.png')));
     i_test4     = rgb2gray(im2double(imread('T1_04_39,22,79,52,19,73.png')));
    
    i_tempR005  = rgb2gray(im2double(imread('005-res.png')));
    i_tempR002  = rgb2gray(im2double(imread('002-res.png')));
    
    i_testR005  = rgb2gray(im2double(imread('005-notext.png')));
    i_testR002  = rgb2gray(im2double(imread('002-notext.png')));
    
%% Test Basic Detection
if 0
    i_error     = getErrorImage(i_templ, i_test4, 1);
    
    close all
    colormap('gray');
    imagesc(i_error);
end   

%% Test Basic Detection with blurred images
if 0
    sigma_temp  = 1;                %Change blurr sigmas here
    sigma_test  = 1; 
    
    i_temp      = i_temp1;         %Change images to be tested here
    i_test      = i_test1;
    
    i_error     = getErrorImage(i_temp, i_test, 1);
    
    i_temp      = imgaussfilt(i_temp, sigma_temp);
    i_test      = imgaussfilt(i_test, sigma_test);
    
    i_errorBlur = getErrorImage(i_temp, i_test, 1);
    
    %close all
    colormap('gray');
    subplot(1,2,1), imagesc(i_error),       title("No smoothing");
    subplot(1,2,2), imagesc(i_errorBlur),   title(["sigma_{temp} = " + sigma_temp + ", sig_{ref} = " + sigma_test]);
end

%% Test Basic Detection with preprocessForBasicDetection
if 1
    % Input data
    i_temp      = rgb2gray(im2double(imread('002-res.png')));
    i_test      = rgb2gray(im2double(imread('002-notext.png')));
    
    % Parameters
    bw_thresh   = 150/200;
    r_thicken   = 6;
    sigma       = 1;
    scale       = 0.2;
    
    % Pre processing
    i_testPP    = preprocessForBasicDetection(i_test, bw_thresh, r_thicken, sigma, scale);
    i_tempPP    = preprocessForBasicDetection(i_temp, bw_thresh, r_thicken, sigma, scale);
    
    % Get error image
    i_error     = getErrorImage(i_tempPP, i_testPP, 1);

    %Visualize
    close all
    colormap('gray');
    subplot(1,2,1),     imagesc(i_test),   title("Input image");
    subplot(1,2,2),     imagesc(i_error),  title("Error image");
    
    
end
