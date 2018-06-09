function nwires = preprocess_wires(wires)
%PREPROCESS_WIRES Summary of this function goes here
%   Detailed explanation goes here
    wcount = size(wires,1);
    wcopy = wires;
    nwires = [];
    threshold = 5;
    
    %eliminate interscections and move the intersection point to the end of
    %the line
    for i=3:1:wcount    
        for j=2:1:wcount
            if output_generation.is_on_line([wcopy(i,1) wcopy(i,2)], wcopy(j,:))
                wcopy(i,1:2) = wcopy(j,1:2);
            end
            if output_generation.is_on_line([wcopy(i,3) wcopy(i,4)], wcopy(j,:))
                wcopy(i,3:4) = wcopy(j,1:2);
            end
        end
    end
    
    nwires = wcopy;
        
end

