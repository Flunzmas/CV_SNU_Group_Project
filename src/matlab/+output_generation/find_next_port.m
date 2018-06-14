function port = find_next_port(point,ports,wires)
%FIND_NEXT_PORT Summary of this function goes here
%   Detailed explanation goes here
    threshold = 5;
    found = 0;
    for i=1:1:size(ports,1)
        d = output_generation.calc_distance([ports(i,1) ports(i,2)], [point(1) point(2)]);
        if d < threshold
            port = ports(i,:);
            found = 1;
            break;
        end
    end
    
    port = [];
    if found == 1
        port = ports(i,:);
    end
    
    points = [];
    wind = [];
        
    for i=1:1:size(wires,1)
        d1 = output_generation.calc_distance([point(1) point(2)], [wires(i,1) wires(i,2)]);
        d2 = output_generation.calc_distance([point(1) point(2)], [wires(i,3) wires(i,4)]);
        if d1 < threshold
            points = cat(1,points,wires(i,3:4));
            wind = cat(1,wind,i);
        elseif d2 < threshold
            points = cat(1,points,wires(i,1:2));
            wind = cat(1,wind,i);
        end
    end
    wcopy = wires;
    for i=1:1:size(wind,1)
        wcopy = cat(1,wcopy(1:wind(i)-1,:),wcopy(wind(i)+1:size(wcopy,1),:));
        wind = wind - 1;
    end
    for i=1:1:size(points,1)
        p = output_generation.find_next_port(points(i,:),ports,wcopy);
        port = cat(1,port,p);
    end
end


