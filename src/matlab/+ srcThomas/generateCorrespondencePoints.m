function pointsN = generateCorrespondencePoints(points)

%% calculate new points

%point corners
pos = zeros(2,2);

%process for both axes
for k=1:2
    %find the closest two points (defines edges of paper)
    [~, ind] = min(pdist(points(:,k)));

    %minimize cases
    sw = min(7-ind, ind);

    %depending on index we have different correlating pairs
    switch(sw)
        case 1
            pair1=[1 2];
            pair2=[3 4];
        case 2
            pair1=[1 3];
            pair2=[2 4];
        case 3
            pair1=[1 4];
            pair2=[2 3];
    end

    %evaluate position where new points should lie (inbetween pairs)
    pos(k,1) = floor(pdist(points(pair1,k))/2+min(points(pair1,k)));
    pos(k,2) = floor(pdist(points(pair2,k))/2+min(points(pair2,k)));
end

%generate new points out of evaluated corners
pointsN = [pos(1,1) pos(1,1) pos(1,2) pos(1,2); pos(2,1) pos(2,2) pos(2,1) pos(2,2)]';

%% match points

%distances and indexes
dist = zeros(4, 1);
ind = zeros(4, 1);

%calculate for all points
for k=1:4
    in = points(k,:);
    for n=1:4
        out = pointsN(n,:);
        
        %calculate distance between all points
        dist(n) = pdist([in; out]);
    end
    
    %calculate closest point according to distance
    [~, ind(k)] = min(dist);
end

%update points
pointsN = pointsN(ind, :);

%% define aspect ratio

%get width between points
widthX = abs(pos(1,1) - pos(1,2));
widthY = abs(pos(2,1) - pos(2,2));

%depending on orientation, change aspect ratio
if widthX > widthY
    pointsN(pointsN(:,1) == pos(1,1), 1) = floor(pos(1,2) + sqrt(2)*widthY);
else
    pointsN(pointsN(:,2) == pos(2,1), 2) = floor(pos(2,2) + sqrt(2)*widthX);
end



