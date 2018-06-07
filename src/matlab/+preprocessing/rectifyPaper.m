function imOut = rectifyPaper(imIn)

%get corner points
pointsCn = getCornerPoints(imIn);

%generate correspondence points
pointsCd = generateCorrespondencePoints(pointsCn);

%calculate transformaiton matrix
T = fitgeotrans(pointsCn,pointsCd,'projective');

%transfrom image
imW = (imwarp(imIn, T));

%recalculate corner points from warped image
pointsW = getCornerPoints(imW);

%cut out paper area
imOut = imW(min(pointsW(:,2)):max(pointsW(:,2)),min(pointsW(:,1)):max(pointsW(:,1)));




