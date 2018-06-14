function is = is_on_line(point, line)
%IS_ON_LINE Summary of this function goes here
%   Detailed explanation goes here
    threshold = 5;
    online = 0;
    
    if abs(line(2) - line(4)) < threshold % horizontal
        if abs(point(2) - line (2)) < threshold
            if (point(1) < line(1) && point(1) > line (3)) || (point(1) < line(3) && point(1) > line (1))
                online = 1;
            end
        end
    else % vertical
        if abs(point(1) - line (3)) < threshold
            if (point(2) < line(2) && point(2) > line (4)) || (point(2) < line(4) && point(2) > line (2))
                online = 1;
            end
        end
    end
    
    is = online;
        
end

