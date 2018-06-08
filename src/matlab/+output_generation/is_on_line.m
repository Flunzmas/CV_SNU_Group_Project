function is = is_on_line(point, line)
%IS_ON_LINE Summary of this function goes here
%   Detailed explanation goes here
    threshold = 5;
    online = 0;
    
    if point(1) ~= line(1) && point(1) ~= line(3) % not same point
        if abs(point(1)-(line(1)+line(3))/2) < threshold % on same line
            if (point(1) > line(1) && point(1) < line(3)) || (point(1) > line(3) && point(1) < line(1)) % between
                online = 1;
            end
        end
    end
    
    if point(2) ~= line(2) && point(2) ~= line(4) % not same point
        if abs(point(2)-(line(2)+line(4))/2) < threshold % on same line
            if (point(2) > line(2) && point(2) < line(4)) || (point(2) > line(4) && point(2) < line(4)) % between
                online = 1;
            end
        end
    end
    
    is = online;
        
end

