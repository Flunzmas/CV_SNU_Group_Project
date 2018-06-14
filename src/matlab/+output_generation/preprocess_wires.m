function nwires = preprocess_wires(wires)
%PREPROCESS_WIRES Summary of this function goes here
%   Detailed explanation goes here
    wcount = size(wires,1);
    threshold = 5;
    
    % sort wires to smaller end first
    for i=1:1:wcount
       if abs(wires(i,2)-wires(i,4)) < threshold % horizontal
            if (wires(i,1)) > wires(i,3)
                t = wires(i,1);
                wires(i,1) = wires(i,3);
                wires(i,3) = t;
            end
            wires(i,5) = 1;
        else % vertical
            if (wires(i,2)) > wires(i,4)
                t = wires(i,2);
                wires(i,2) = wires(i,4);
                wires(i,4) = t;
            end
            wires(i,5) = 0;
        end 
    end
    
    % connect lines which represent same physical line
    i = 1;
    while i <= size(wires,1)
        if wires(i,5) == 1
            j = i;
            changed = 0;
            while j <= size(wires,1)
                if i~=j && abs(wires(i,2)-wires(j,2)) < threshold && wires(i,5) == wires(j,5)
                    if wires(j,1) >= wires(i,1) && wires(j,1) <= wires(i,3) && wires(j,3) > wires(i,3)
                        wires(i,3) = wires(j,3);
                        changed = 1;
                    end
                    if wires(j,3) >= wires(i,1) && wires(j,3) <= wires(i,3) && wires(j,3) < wires(i,1)
                        wires(i,1) = wires(j,1);
                        changed = 1;
                    end
                    if wires(j,1) >= wires(i,1) && wires(j,1) <= wires(i,3) && wires(j,3) >= wires(i,1) && wires(j,3) <= wires(i,3)
                        changed = 1;
                    end
                    if changed
                        wires = cat(1,wires(1:j-1,:),wires(j+1:size(wires,1),:));
                    else
                        j = j+1;
                    end
                else
                    j = j+1;
                end
            end
        end
        i = i+1;
    end
    %vertical lines
    i = 1;
    while i <= size(wires,1)
        if wires(i,5) == 0
            j = i;
            changed = 0;
            while j <= size(wires,1)
                if i~=j && abs(wires(i,1)-wires(j,1)) < threshold && wires(i,5) == wires(j,5)
                    if wires(j,2) >= wires(i,2) && wires(j,2) <= wires(i,4) && wires(j,4) > wires(i,4)
                        wires(i,4) = wires(j,4);
                        changed = 1;
                    end
                    if wires(j,4) >= wires(i,2) && wires(j,4) <= wires(i,4) && wires(j,4) < wires(i,2)
                        wires(i,2) = wires(j,2);
                        changed = 1;
                    end
                    if wires(j,2) >= wires(i,2) && wires(j,2) <= wires(i,4) && wires(j,4) >= wires(i,2) && wires(j,4) <= wires(i,4)
                        changed = 1;
                    end
                    if changed
                        wires = cat(1,wires(1:j-1,:),wires(j+1:size(wires,1),:));
                    else
                        j = j+1;
                    end
                else
                    j = j+1;
                end
            end
        end
        i = i+1;
    end
    
    wcount = size(wires,1);
    wcopy = wires;
    
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

