function imOut = rectifyPaper(imIn)

%get corner points
pointsCn = preprocessing.getCornerPoints(imIn);

%generate correspondence points
pointsCd = preprocessing.generateCorrespondencePoints(pointsCn);

%calculate transformaiton matrix
T = fitgeotrans(pointsCn,pointsCd,'projective');

%transfrom image
imW = (imwarp(imIn, T));

%recalculate corner points from warped image
pointsW = preprocessing.getCornerPoints(imW);

%cut out paper area
imOut = imW(min(pointsW(:,2)):max(pointsW(:,2)),min(pointsW(:,1)):max(pointsW(:,1)));




