function elementList = detectElements(i_testRGB, resSize)
%elementList searches and detects elements. The elements must be inserted
%into this function manuelly!
%i_testRGB is the rectified, no-text, RGB image of the circuit
%resSize are the dimensions of the detected resistor
%elementList returns a cell array of found elements:
%See elementList is formatted according to "cellArrayExample.m"

fprintf("\n\n-----------------------\n");
fprintf(" >>>Start\tanalyseImage\n");


%% Parameters
    elemPad             = 1.2;  %Pads coordinates of found elements
    doubtAndiFactor     = 1.5;  %Tolerance for scoring and filtering
    

%% Preparation
    resRows     = min(resSize);
    resCols     = max(resSize);
    HWR_o       = round(resRows / 2) * elemPad;     %Half row size + tolerance
    HWC_o       = round(resCols / 2) * elemPad;     %Half col size + tolerance

    i_test      = rgb2gray(i_testRGB);  %test image
    elCount     = 1;                    %Element counter
    elList      = cell(1, 5);           %Initialize elList - wip version
    elementList = cell(1, 4);           %Initialize elementList - output version
    
    
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
    for i = 1:0.5:size(templ, 2)        %Double the loops for vert/hori direction
        
        %Load current template and name
        k           = floor(i);
        i_temp      = templ(k).temp;
        elType      = templ(k).name;
        
        %Set horizontal/vertical
        if mod(i, 1) == 0
            elDir   = "hori";   %default (horizontal) stored template
            HWR     = HWR_o;
            HWC     = HWC_o;
        else
            i_temp  = imrotate(i_temp, 90); %rotate template to vertical
            elDir   = "vert";   %rotated (vertical) template
            HWR     = HWC_o;
            HWC     = HWR_o;
        end
                
        %Find elements
        [elCoords, score]   = findElement(i_temp, i_test);
        
        %Check if no elements have been found
        if isnan(elCoords)       
            fprintf("\tfindElement found no elements of type <%s>\n", elType);
        else
            elFound     = size(elCoords, 1);
            fprintf("\tfindElement found %d element(s) of type <%s>\n", elFound, elType);

            %Store found element information in elList
            for j = 1:elFound
                topLCoord   = [elCoords(j, 1) - HWR, elCoords(j, 2) - HWC];
                botRCoord   = [elCoords(j, 1) + HWR, elCoords(j, 2) + HWC];
                elList(elCount, :) = {elType; elDir; topLCoord; botRCoord; score};

                elCount     = elCount + 1;
            end

            %For Visualization (show found elements in current sweep)
            if 0
                elemRects   = zeros(elFound, 4);
                elemCenters = zeros(elFound, 3);

                for j = 1:elFound
                    elemRects(j, 1) = elCoords(j, 2) - HWC;
                    elemRects(j, 2) = elCoords(j, 1) - HWR;
                    elemRects(j, 3) = 2 * HWC;
                    elemRects(j, 4) = 2 * HWR;
                    elemCenters(j, 1) = elCoords(j, 2);
                    elemCenters(j, 2) = elCoords(j, 1);
                    elemCenters(j, 3) = (HWR + HWC) / 6;
                end

                i_testANA   = insertShape(i_testRGB, 'Rectangle', elemRects, 'Color', 'r', 'LineWidth', 3);
                i_testANA   = insertShape(i_testANA, 'Circle', elemCenters, 'Color', 'r');

                f = figure;
                imagesc(i_testANA);
                waitfor(f)
            end    
        end
    end
        
    
%% Filter uncertain elements
    elCountPre  = size(elList, 1);              %element count before filtering
    elCountPost = 0;                            %element count after filtering
    scores      = cell2mat(elList(:, 5));       %score values of found elements
    minScore    = floor(min(scores * doubtAndiFactor));     %minimal score (the smaller, the better)
    
    % Filter for proper elements and assign to output elementList
    for i = 1:elCountPre
        if elList{i, 5} <= minScore
            elCountPost     = elCountPost + 1;
            elementList(elCountPost, :) = elList(i, 1:4);
        end
    end
   

%% Visualization
    %For Visualization (show found elements)
    if 0
        elemRects   = zeros(elCountPost, 4);
        elemCenters = zeros(elCountPost, 3);

        for j = 1:elFound
            elemRects(j, 1) = elCoords(j, 2) - HWC;
            elemRects(j, 2) = elCoords(j, 1) - HWR;
            elemRects(j, 3) = 2 * HWC;
            elemRects(j, 4) = 2 * HWR;
            elemCenters(j, 1) = elCoords(j, 2);
            elemCenters(j, 2) = elCoords(j, 1);
            elemCenters(j, 3) = (HWR + HWC) / 6;
        end

        i_testANA   = insertShape(i_testRGB, 'Rectangle', elemRects, 'Color', 'r', 'LineWidth', 3);
        i_testANA   = insertShape(i_testANA, 'Circle', elemCenters, 'Color', 'r');

        f = figure;
        imagesc(i_testANA);
        waitfor(f)
    end    
    
    
fprintf(" >>>End\tanalyseImage\n");
fprintf("-----------------------\n\n");

end
    
    