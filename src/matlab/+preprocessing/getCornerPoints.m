function points = getCornerPoints(imI)

%% image analysis

%get region boundary
B = bwboundaries(preprocessing.getSingleObject(imI), 8, 'noholes');
B = B{1};

%boudary signature
%convert boundary from cartesian to ploar coordinates
objB = bsxfun(@minus, B, mean(B));
[theta, rho] = cart2pol(objB(:,2), objB(:,1));

%sort theta for finding peaks
[thetaS, thetaI] = sort(theta, 'ascend');

%sort rho accordingly
rhoS = rho(thetaI,:);

%find if there are duplicate values in theta (not allowed for findpeaks)
[~, indx] = unique(thetaS,'first');
dup = find(not(ismember(1:numel(thetaS),indx)));

%create 'fake' value to retain number of indexes
for k=1:numel(dup)
    thetaS(dup(k)) = (thetaS(dup(k)+1)+thetaS(dup(k)))/2;
end

%find peaks in function (highest rho values, local maximum)
[pks,~,~,p] = findpeaks(rhoS, thetaS);

%sort peak prominences 
[~, pI] = sort(p, 'descend');

%sort peaks accordingly
pksS = pks(pI,:);

%largest four values are our four corners
pksS = pksS(1:4);

%find rho index for that value
mem = ismember(rho, pksS);
ind = find(mem);

%extract points for image coordinates
points = [B(ind,2) B(ind,1)];

%% result processing

%in case of duplicate points (from rho index)
if(size(points, 1) > 4)
    %get indexes
    [~, indr] = unique(points(:,1), 'first');
    [~, indc] = unique(points(:,2), 'first');
    
    %get duplicate index
    dupr = find(not(ismember(1:numel(points(:,1)),indr)));
    dupc = find(not(ismember(1:numel(points(:,2)),indc)));
    
     %find location where duplicate point is
    dup = dupr == dupc;
    
    %delete point
    points(dup,:) = [];
end

% %get center for clockwise sorting
% cx = mean(points(:,1));
% cy = mean(points(:,2));
% 
% %get angle and sort
% angle = atan2(points(:,1) - cy, points(:,2) - cx);
% [~, ind] = sort(angle);
% 
% %update points
% points(:,2) = points(ind,2);
% points(:,1) = points(ind,1);