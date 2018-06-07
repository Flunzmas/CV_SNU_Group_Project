%% examlpe code

%open question dialog
answer = questdlg('What type of image are you supplying?', ...
	'Image Type', ...
	'Photo', 'Screenshot','Screenshot');

%switch between response
switch answer
    case 'Photo'
        %load and rectify
        imI = rectifyPaper(selectImage());
    case 'Screenshot'
        %just load
        imI = selectImage();
    otherwise
        return;
end

%show image and let user select area
imshow(imI);
title('select area of filter');
coords = floor(ginput(2));

%cut image area
imA = imI(coords(1,2):coords(2,2),coords(1,1):coords(2,1));

imshow(imA)

[imO, ocrResult] = ocrCircuit(imA);

imshow(imO)


%open question dialog
answer = questdlg('Still some text remaining?', ...
	'Remaining Text', ...
	'Yes', 'No','No');

%switch between response
switch answer
    case 'Yes'
        %run with roi
        title('select text area');
        coords = floor(ginput(2));
        
        %[x y width height]
        roi = [coords(1,1) coords(1,2) coords(2,1)-coords(1,1) coords(2,2)-coords(1,2)];
        
        [imO, ocrResult] = ocrCircuit(imO, roi);
        
        imshow(imO);
        return;
    case 'No'
        %exit
        return;
    otherwise
        return;
end