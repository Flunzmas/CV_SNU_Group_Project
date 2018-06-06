function prepImage = preprocessForBasicDetection(i_input, bw_thresh, r_thicken, sigma, scale)
    
    %i_blurr     = imgaussfilt(i_input, sigma);
    i_binar     = ~imbinarize(i_input, bw_thresh);
    i_morph     = imdilate   (i_binar, strel('disk', r_thicken));
    i_resize    = ~imresize   (i_morph, scale);
    
    
%% Visualization and return
if 0
    f = figure;
    colormap('gray');
    subplot(1,2,1), imshow(i_input),    title("original");
    subplot(1,2,2), imshow(i_resize),  title("Preprocessed");
    waitfor(f)    
end
    
    prepImage   = i_resize;   
return