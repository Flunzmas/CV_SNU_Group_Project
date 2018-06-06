function coords = findElement(i_temp, i_test)
%findElement returns the center-coordinates of all found objects. 
%i_temp is the template/object to be found
%i_test is the probed/tested image, in which the object is searched for
%coords is a matrix containing the coordinates of the centers
%Every row is a new center of a found object 
%Column 1 is the row-coordinate of the found object .
%Column 2 is the col-coordinate of the found object 
%This function uses: ppDetection, getErrorImage, getMaxima

%% Parameters
    bw_thresh   = 150/200;
    t_param     = 5;
    sigma       = 1;
    scale       = 0.25;

    
%% Find coordinates of element
    while 1
        % Pre processing
        i_testPP    = ppDetection(i_test, bw_thresh, t_param, sigma, scale);
        i_tempPP    = ppDetection(i_temp, bw_thresh, t_param, sigma, scale);

        % Get error image and coordinates of element-maxima
        i_error         = getErrorImage(i_tempPP, i_testPP, 1);
        [coords, i_max] = getMaxima(i_error);

        % Check for sucessfull maximas
        if ~isnan(coords)
            fprintf("\tgetMaxima successfull with t_param = %d\n", t_param);
            break;
        end
        fprintf("\tgetMaxima failed with t_param = %d\n", t_param);
        t_param     = t_param + 1;
    end

    % Re-scale
    coords  = round(coords / scale);

    
%% Visualization
    if 1    %Compare input image, error image and max image
        %close all
        f = figure;
        colormap('gray');
        subplot(1,3,1),     imagesc(i_test),   title("Input image");
        subplot(1,3,2),     imagesc(i_error),  title("Error image");
        subplot(1,3,3),     imagesc(i_max),    title("Max image");
        waitfor(f);
    end


