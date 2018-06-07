% Testing Script for Basic Detection

%% Load template and testing image
    %T1 series - simple detection no scaling
%     i_temp1     = rgb2gray(im2double(imread('T1_temp1.png')));
%     i_temp2     = rgb2gray(im2double(imread('T1_temp2.png')));
%     
%     i_test1     = rgb2gray(im2double(imread('T1_01_27,70.png')));
%     i_test2     = rgb2gray(im2double(imread('T1_02_72,41.png')));
%     i_test3     = rgb2gray(im2double(imread('T1_03_39,22.png')));
%     i_test4     = rgb2gray(im2double(imread('T1_04_39,22,79,52,19,73.png')));
%     
%     i_tempR005  = rgb2gray(im2double(imread('005-res.png')));
%     i_tempR002  = rgb2gray(im2double(imread('002-res.png')));
%     
%     i_testR005  = rgb2gray(im2double(imread('005-notext.png')));
%     i_testR002  = rgb2gray(im2double(imread('002-notext.png')));
    
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
if 0
    % Input data
    i_temp      = rgb2gray(im2double(imread('007-cap.png')));
    i_test      = rgb2gray(im2double(imread('007-notext.png')));
    
    % Parameters
    bw_thresh   = 150/200;
    t_param     = 5;
    sigma       = 1;
    scale       = 0.25;
    
    
    while 1
        % Pre processing
        i_testPP    = ppDetection(i_test, bw_thresh, t_param, sigma, scale);
        i_tempPP    = ppDetection(i_temp, bw_thresh, t_param, sigma, scale);

        % Get error image and coordinates of element-maxima
        i_error     = getErrorImage(i_tempPP, i_testPP, 1);
        [coords, i_max]     = getMaxima(i_error);

        % Check for sucessfull maximas
        if ~isnan(coords)
            fprintf("\tgetMaxima successfull with t_param = %d\n", t_param);
            break;
        end
        fprintf("\tgetMaxima failed with t_param = %d\n", t_param);
        t_param     = t_param + 1;
    end
    
    % Re-scale 
    
    %Visualize
    imagesc(i_max);
    
    if 0    %Compare input image and error image
        %close all
        colormap('gray');
        subplot(1,2,1),     imagesc(i_test),   title("Input image");
        %subplot(1,3,2),     imagesc(i_error),  title("Error image");
        subplot(1,2,2),     imagesc(i_max),    title("Max image");
    end
end


