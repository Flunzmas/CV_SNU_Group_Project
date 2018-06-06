%analyseImage

%% Input values
    i_testRGB   = im2double(imread('005-notext.png'));
    i_test      = rgb2gray(i_testRGB);
    
    %HORIZONTAL DIRECTION
    resRows     = 71;
    resCols     = 157;
    
    
%% Preparation
    HWR         = round(resRows / 2) * 1.2;     %Half row size + tolerance
    HWC         = round(resCols / 2) * 1.2;     %Half col size + tolerance


%% Load template data (object data)
    %Horizontal templates
    i_temp_cap  = rgb2gray(im2double(imread('001-cap.png')));
    i_temp_ind  = rgb2gray(im2double(imread('001-ind.png')));
    i_temp_res  = rgb2gray(im2double(imread('001-res.png')));
    
    %Integrate templates into struct (manually) and resize 
    templ(1).name   = "cap";
    templ(1).temp   = imresize(i_temp_cap, [resRows*1.0000 resCols*0.2928]);
    templ(2).name   = "ind";
    templ(2).temp   = imresize(i_temp_ind, [resRows*0.8462 resCols*1.2431]);
    templ(3).name   = "res";
    templ(3).temp   = imresize(i_temp_res, [resRows*1.0000 resCols*1.0000]);
    
    
%% Find elements
    for i = 1:size(templ, 2)
        i_temp = templ(i).temp;
                
        elemCoords  = findElement(i_temp, i_test);    


        %For Visualization
        if 1
            elemRects   = zeros(size(elemCoords, 1), 4);
            elemCenters = zeros(size(elemCoords, 1), 3);

            for j = 1:size(elemCoords, 1)
                elemRects(j, 1) = elemCoords(j, 2) - HWC;
                elemRects(j, 2) = elemCoords(j, 1) - HWR;
                elemRects(j, 3) = 2 * HWC;
                elemRects(j, 4) = 2 * HWR;
                elemCenters(j, 1) = elemCoords(j, 2);
                elemCenters(j, 2) = elemCoords(j, 1);
                elemCenters(j, 3) = (HWR + HWC) / 6;
            end

            i_testANA   = insertShape(i_testRGB, 'Rectangle', elemRects, 'Color', 'r');
            i_testANA   = insertShape(i_testANA, 'Circle', elemCenters, 'Color', 'r');

            imagesc(i_testANA);
        end    
    end
    
    