function elementList = detectElements(i_testRGB, resSize)
%elementList searches and detects elements. The elements must be inserted
%into this function manuelly!
%i_testRGB is the rectified, no-text, RGB image of the circuit
%resSize are the dimensions of the detected resistor
%elementList returns a cell array of found elements:
%See elementList is formatted according to "cellArrayExample.m"

fprintf("\n-----------------------\n");
fprintf(" >>>Start\tdetectElements\n");
vis1 = 1;
vis2 = 0;


%% Parameters
    elemPad         = 1.5;  %Pads coordinates of found elements
    doubtAndiFactor = 2.0;  %Tolerance for scoring and filtering
    bndExt          = 50;   %To filter out rogue elements (at bounds of image)
    

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
    i_temp_gnd  = rgb2gray(im2double(imread('001-gnd.png')));
    i_temp_dcv  = rgb2gray(im2double(imread('001-dcv.png')));
    
    %Integrate templates into struct (manually) and resize 
    templ(3).name   = "cap";
    templ(3).temp   = imresize(i_temp_cap, [resRows*1.0000 resCols*0.2928]);
    templ(2).name   = "ind";
    templ(2).temp   = imresize(i_temp_ind, [resRows*0.8462 resCols*1.2431]);
    templ(1).name   = "res";
    templ(1).temp   = imresize(i_temp_res, [resRows*1.0000 resCols*1.0000]);
    templ(4).name   = "dcv";
    templ(4).temp   = imresize(i_temp_dcv, [resRows*0.9011 resCols*1.3481]);
    templ(5).name   = "gnd";
    templ(5).temp   = imresize(i_temp_gnd, [resRows*1.1319 resCols*0.5691]);
    
    
%% Find elements
    for i = 1:0.5:size(templ, 2) + 0.5  %Double the loops for vert/hori direction
        
        %Load current template and name
        k           = floor(i);
        i_temp      = templ(k).temp;
        elType      = templ(k).name;
        
        HWR_o       = round(elemPad * size(templ(k).temp, 1) / 2);
        HWC_o       = round(elemPad * size(templ(k).temp, 2) / 2);

        %Set horizontal/vertical
        if mod(i, 1) == 0
            elDir   = "hori";   %default (horizontal) stored template
            HWR     = HWR_o;
            HWC     = HWC_o;
            if elType == "gnd", continue; end   %there shan't be horizontal grounds
        else
            i_temp  = imrotate(i_temp, 90); %rotate template to vertical
            elDir   = "vert";   %rotated (vertical) template
            HWR     = HWC_o;
            HWC     = HWR_o;
        end
                
        %Find elements
        [elCoords, score]   = im_analysis.findElement(i_temp, i_test);
        
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
            if vis2
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
                
                i_testANA   = padarray   (i_testRGB, [60 60], 'replicate', 'post');
                i_testANA   = insertShape(i_testANA, 'Rectangle', elemRects, 'Color', 'r', 'LineWidth', 3);
                i_testANA   = insertShape(i_testANA, 'Circle', elemCenters, 'Color', 'r');

                f = figure;
                imagesc(i_testANA);
                waitfor(f)
            end    
        end
    end
        
    
%% Filter elements
    elCountPre  = size(elList, 1);              %element count before filtering
    elCountPost = 0;                            %element count after filtering
    scores      = cell2mat(elList(:, 5));       %score values of found elements
   minScore    = floor(min(scores * doubtAndiFactor));     %minimal score (the smaller, the better)
     keepVec     = ones(elCountPre, 1);         %decision if to keep or not is stored here
    
    % Build position vector for element rectangles
    elRects     = zeros(elCountPre, 4);        %position vector of all possible elements
    for j = 1:elCountPre
        elRects(j, 1) = round(elList{j, 3}(2)); %x-coord
        elRects(j, 2) = round(elList{j, 3}(1)); %y-coord
        elRects(j, 3) = round(elList{j, 4}(2) - elList{j, 3}(2)); %width
        elRects(j, 4) = round(elList{j, 4}(1) - elList{j, 3}(1)); %height
    end
    
    % Search for contested areas
    inter1       = rectint(elRects, elRects);   %Get intersection matrix
    for j = 1:size(inter1, 1)
        if keepVec(j) == 0, continue; end
        for k = j + 1:size(inter1, 2)
            if inter1(j, k) ~= 0                %Check for shared area
                %Hack around gnd and res similarity. Give res priority
                if      elList{j, 1} == "res" && elList{k, 1} == "gnd"
                    keepVec(k) = 0;
                elseif  elList{j, 1} == "gnd" && elList{k, 1} == "res"
                    keepVec(j) = 0;
                elseif  scores(j) <= scores(k)  %figure out which has a better (lower) score
                    keepVec(k) = 0;
                else
                    keepVec(j) = 0;
                end
            end
        end
    end
    
    % Search for rogue elements (well beyond image bounds)
    inter2  = rectint(elRects, [-bndExt, -bndExt, size(i_testRGB, 2) + 2*bndExt, size(i_testRGB, 1) + 2*bndExt]);
    areas   = elRects(:,3) .* elRects(:,4); %Gets ares of all rectangles
    isInImg = (inter2 == areas);            %Checks if element is fully contained in (padded) image
    keepVec = keepVec .* isInImg;           %Performs and operation
    
    % Assign valid elements to output
    for j = 1:elCountPre
        if keepVec(j) == 1
            elCountPost = elCountPost + 1;
            elementList(elCountPost, :) = elList(j, 1:4);
        end
    end
    
%     %older, more primitive filtering method
%     % Filter for proper elements and assign to output elementList
%     for i = 1:elCountPre
%         if elList{i, 5} <= minScore
%             elCountPost     = elCountPost + 1;
%             elementList(elCountPost, :) = elList(i, 1:4);
%         end
%     end
   

%% Visualization
    % Show all potential elements
    if vis1
        elemRects   = zeros(elCountPre, 4);
        elemMarks   = zeros(elCountPre, 2);
        elemTexts   = zeros(elCountPre, 2);
        elemNames   = cell(elCountPre, 1);

        for j = 1:elCountPre
            elemRects(j, 1) = round(elList{j, 3}(2));  %x-coord
            elemRects(j, 2) = round(elList{j, 3}(1));  %y-coord
            elemRects(j, 3) = round(elList{j, 4}(2) - elList{j, 3}(2)); %width
            elemRects(j, 4) = round(elList{j, 4}(1) - elList{j, 3}(1)); %height
            
            elemMarks(j, 1) = elemRects(j, 1) + elemRects(j, 3) / 2;    %Center x-coord
            elemMarks(j, 2) = elemRects(j, 2) + elemRects(j, 4) / 2;    %Center y-coord
           
            elemTexts(j, 1) = elemRects(j, 1);                          %x-coord
            elemTexts(j, 2) = elemRects(j, 2) + elemRects(j, 4) - 10;   %botton y-coord
            elemNames{j}    = char(elList{j, 1} + " " + elList{j, 5});
        end

        i_testANA   = padarray(i_testRGB, [60 60], 'replicate', 'post');
        i_testANA   = insertShape (i_testANA, 'Rectangle', elemRects, 'Color', 'r', 'LineWidth', 2);
        i_testANA   = insertMarker(i_testANA, elemMarks, 'Color', 'r', 'Size', 10);
        i_testANA   = insertText  (i_testANA, elemTexts, elemNames, 'TextColor', 'black', 'FontSize', 20, 'BoxOpacity' , 0);
        
        f = figure;
        imagesc(i_testANA);
        waitfor(f)
    end    
    
    % Show found elements
    if vis1
        elemRects   = zeros(elCountPost, 4);
        elemMarks   = zeros(elCountPost, 2);
        elemTexts   = zeros(elCountPost, 2);
        elemNames   = cell(elCountPost, 1);

        for j = 1:elCountPost
            elemRects(j, 1) = round(elementList{j, 3}(2));  %x-coord
            elemRects(j, 2) = round(elementList{j, 3}(1));  %y-coord
            elemRects(j, 3) = round(elementList{j, 4}(2) - elementList{j, 3}(2)); %width
            elemRects(j, 4) = round(elementList{j, 4}(1) - elementList{j, 3}(1)); %height
            
            elemMarks(j, 1) = elemRects(j, 1) + elemRects(j, 3) / 2;    %Center x-coord
            elemMarks(j, 2) = elemRects(j, 2) + elemRects(j, 4) / 2;    %Center y-coord
           
            elemTexts(j, 1) = elemRects(j, 1);                          %x-coord
            elemTexts(j, 2) = elemRects(j, 2) + elemRects(j, 4) - 10;   %botton y-coord
            elemNames{j}    = char(elementList{j, 1});
        end

        i_testANA   = padarray    (i_testRGB, [60 60], 'replicate', 'post');
        i_testANA   = insertShape (i_testANA, 'Rectangle', elemRects, 'Color', 'r', 'LineWidth', 3);
        i_testANA   = insertMarker(i_testANA, elemMarks, 'Color', 'r', 'Size', 20);
        i_testANA   = insertText  (i_testANA, elemTexts, elemNames, 'TextColor', 'r', 'FontSize', 30, 'BoxOpacity' , 0);
        
        f = figure;
        imagesc(i_testANA);
        waitfor(f)
    end
    
    
fprintf(" >>>End\tdetectElements\n");
fprintf("-----------------------\n\n");

end
    
    