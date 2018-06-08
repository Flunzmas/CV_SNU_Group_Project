function connections = process_wires(elementList, objects, wires)
%PROCESS_WIRES Summary of this function goes here
%   Detailed explanation goes here

    objCount = size(elementList,1);
    ports = zeros(objCount*2,3);
    threshold = 5;
    connections = [];
    
    % find estimated location of ports
    for i=1:1:objCount
        e = elementList(i,:);
        x = (e{3}(1)+e{4}(1))/2;
        y = (e{3}(2)+e{4}(2))/2;
            
        ports(i*2-1,3) = i;
        ports(i*2,3) = i;
        if e{2}=="hori"
            ports(i*2-1,1) = e{3}(1);
            ports(i*2-1,2) = e{3}(2) + (e{4}(2) - e{3}(2))/2;
            ports(i*2,1) = e{4}(1);
            ports(i*2,2) = e{4}(2) - (e{4}(2) - e{3}(2))/2;
        elseif e{2}=="vert"
            ports(i*2-1,2) = e{3}(2);
            ports(i*2-1,1) = e{3}(1) + (e{4}(1) - e{3}(1))/2;
            ports(i*2,2) = e{4}(2);
            ports(i*2,1) = e{4}(1) - (e{4}(1) - e{3}(1))/2;
        end
    end
    
    wire = 0;
    for i=1:1:size(ports,1)
        obj1 = 0; obj2 = 0; port1 = 0; port2 = 0;
        newCoords = zeros(2);
        % find the wire connected to the port
        for j=1:1:size(wires,1)
            d1 = calc_distance([ports(i,1) ports(i,2)], [wires(j,1) wires(j,2)]);
            d2 = calc_distance([ports(i,1) ports(i,2)], [wires(j,3) wires(j,4)]);
            
            if d1 < threshold 
                obj1 = objects(ports(i,3));
                newCoords = [wires(j,3) wires(j,4)];
                wire = j;
                if mod(i,2) == 1
                    port1 = '+';
                else
                    port1 = '-';
                end
                break
            elseif d2 < threshold
                obj1 = objects(ports(i,3));
                newCoords = [wires(j,1) wires(j,2)];
                wire = j;
                if mod(i,2) == 1;
                    port1 = '+';
                else
                    port1 = '-';
                end
                break
            end
        end
        
        % find direct connections
        found = 0;
        j=1;
        for j=1:1:size(ports,1)
            d = calc_distance(newCoords, [ports(j,1) ports(j,2)]);
            t = wires(j) - [newCoords(1) newCoords(2) ports(j,1) ports(j,2)];
            if d < threshold
                obj2 = objects(ports(j,3));
                found = 1;
                break;
            end
        end
        
        if found == 1
            if mod(j,2) == 1;
                port2 = '+';
            else
                port2 = '-';
            end
            if size(connections,1) == 0
                connections = [Connection(obj1, port1, obj2, port2)];
            else
                connections(size(connections,1)+1) = Connection(obj1, port1, obj2, port2);
            end
            wires(wire,:) = [0 0 0 0]; % make wire unusable in next steps
            found = 0;
        end
    end
    connections = transpose(connections);
end

