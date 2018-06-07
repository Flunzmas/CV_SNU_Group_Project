function i_err  = getErrorImage(i_tem, i_ref, stepsize)
%Returns the error image of i_tem sliding over i_ref
%i_tem   : template  grayscale image, which contains desired object
%i_ref   : reference grayscale image, in which detection is conducted
%stepsize: stepsize of detection window (both vertically and horizontally)
%i_err   : calculated error image

%TODO: is padding needed? --> assume template image is properly cropped!

fprintf("   >Start\tgetErrorImage");
vis = 0;

%% Check inputs
    %Check for accidental RGB images
    if ndims(i_tem) ~= 2 || ndims(i_ref) ~= 2
        error("Input images have wrong dimensionality");
    end

    %Check if i_templ is accidentally larger than i_ref
    if size(i_tem) > size(i_ref)
        error("i_templ is larger than i_ref");
    end

    
%% Preperation
    
    [rows_tem, cols_tem]    = size(i_tem);    %Size of template = detection window
    
    %Pad template if even numbered size with 1 pixel
    if mod(rows_tem, 2) == 0,   i_tem = padarray(i_tem, [1 0], 'post'); end
    if mod(cols_tem, 2) == 0,   i_tem = padarray(i_tem, [0 1], 'post'); end
    [rows_tem, cols_tem]    = size(i_tem);    %Size of template = detection window
    
    i_ref   = padarray(i_ref, [floor(rows_tem / 2), floor(cols_tem / 2)]);  %pad with zeros
    [rows_ref, cols_ref]    = size(i_ref);    %Size of reference image
    
    maxRow  = rows_ref - rows_tem;    %Max row where upper left corner of detection window starts
    maxCol  = cols_ref - cols_tem;    %Max col where upper left corner of detection window starts
    
    
%% Generate error image
    i_error     = ones(rows_ref, cols_ref);     %Error image, initialize with max normalized error = 1
    
    fprintf("\tprogress: %6.2f%s", 0, '%');
    %Loop through reference image
    for row = 1:stepsize:maxRow + 1
        for col = 1:stepsize:maxCol + 1
            
            %get error window (sum or MSE)
            errSum  = abs(i_ref(row:rows_tem + row - 1, col:cols_tem + col - 1) - i_tem);
            errMSE  = abs(i_ref(row:rows_tem + row - 1, col:cols_tem + col - 1) - i_tem).^2;
            err     = errMSE;
            %get normalized error value
            errNorm = sum(sum(err)) / numel(err);
            %assign errNorm to THE CENTER of detection window
            i_error(row + floor(rows_tem / 2), col + floor(cols_tem / 2))   = errNorm;
            %invert error image, so that higher values correspond to better fit
            %i_errorInv = imcomplement(i_error);
            
            if 0    %Visualization
                i_vis1  = zeros(rows_ref, cols_ref);
                i_vis1(row:rows_tem + row - 1, col:cols_tem + col - 1) = 0.5 * imcomplement(i_tem);
                i_vis1  = i_vis1 + 0.5 * imcomplement(i_ref);

                i_vis2  = double(zeros(rows_ref, cols_ref, 3));
                i_vis2(:,:,1)   = i_vis1; i_vis2(:,:,2)   = i_vis1; i_vis2(:,:,3)   = i_vis1;
                i_vis2          = imcomplement(i_vis2);

                i_vis3  = zeros(rows_ref, cols_ref, 3);
                i_vis3(:,:,2)   = 0.5 * i_errorInv; i_vis3(:,:,3)   = 0.5 * i_errorInv;

                i_vis4  = i_vis2 - i_vis3;

                imagesc(i_vis4);
            end
        end
        progress    = row / maxRow * 100;
        if mod(round(progress), 10) == 3
            fprintf(repmat('\b', 1, 18));
            fprintf("\tprogress: %6.2f%s", progress, '%'); 
        end
    end
    fprintf(repmat('\b', 1, 18));
    
%% Visualization and return
    i_errorInv = imcomplement(i_error);

    if vis
        f = figure;
        colormap('gray');
        i_compare   = imcomplement(imfuse(i_ref, i_errorInv, 'diff'));
        subplot(1,3,1), imagesc(i_ref),         title("Reference image");
        subplot(1,3,2), imagesc(i_errorInv),    title("MSE Error image");
        subplot(1,3,3), imagesc(i_compare),     title("Comparison");
        waitfor(f)
    end

    %Get error image in original (unpadded) i_ref size
    i_err = i_errorInv(floor(rows_tem / 2) + 1:rows_ref - floor(rows_tem / 2), ...
                       floor(cols_tem / 2) + 1:cols_ref - floor(cols_tem / 2));

fprintf("\t...Ended\n");
    
return