% Testing Script for Basic Detection

% Load template and testing image
    % T1 series - simple detection no scaling
    i_temp1     = rgb2gray(im2double(imread('T1_temp1.png')));
    i_temp2     = rgb2gray(im2double(imread('T1_temp2.png')));
    
    i_test1     = rgb2gray(im2double(imread('T1_01_27,70.png')));
    i_test2     = rgb2gray(im2double(imread('T1_02_72,41.png')));
    i_test3     = rgb2gray(im2double(imread('T1_03_39,22.png')));
    i_test4     = rgb2gray(im2double(imread('T1_04_39,22,79,52,19,73.png')));

% Test Basic Detection
if 0
    i_error     = getErrorImage(i_templ, i_test4, 1);
    
    close all
    colormap('gray');
    imagesc(i_error);
end

% Test Basic Detection with blurred images
    sigma_temp  = 2;
    sigma_test  = 2;
    
    i_temp      = i_temp2;
    i_test      = i_test4;

    i_error     = getErrorImage(i_temp, i_test, 1);
    
    i_temp      = imgaussfilt(i_temp, sigma_temp);
    i_test      = imgaussfilt(i_test, sigma_test);
    
    i_errorBlur = getErrorImage(i_temp, i_test, 1);
    
    %close all
    colormap('gray');
    subplot(1,2,1), imagesc(i_error),       title("No smoothing");
    subplot(1,2,2), imagesc(i_errorBlur),   title(["sigma_{temp} = " + sigma_temp + ", sig_{ref} = " + sigma_test]);

