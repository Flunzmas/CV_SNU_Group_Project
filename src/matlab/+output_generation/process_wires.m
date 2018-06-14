function connections = process_wires(elementList, objects, wires)
%PROCESS_WIRES Summary of this function goes here
%   Detailed explanation goes here

    objCount = size(elementList,1);
    ports = zeros(objCount*2,4);
    threshold = 10;
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
            ports(i*2-1,4) = 0;
            ports(i*2,4) = 1;
        elseif e{2}=="vert"
            ports(i*2-1,2) = e{3}(2);
            ports(i*2-1,1) = e{3}(1) + (e{4}(1) - e{3}(1))/2;
            ports(i*2,2) = e{4}(2);
            ports(i*2,1) = e{4}(1) - (e{4}(1) - e{3}(1))/2;
            ports(i*2-1,4) = 0;
            ports(i*2,4) = 1;
        end
    end
    points = [];
    pcopy = ports;
    
    while size(pcopy,1) > 0
        % find all endpoints of wires leading from the first port
        points = [];
        wind = [];
        for i=1:1:size(wires,1)
            d1 = output_generation.calc_distance([pcopy(1,1) pcopy(1,2)], [wires(i,1) wires(i,2)]);
            d2 = output_generation.calc_distance([pcopy(1,1) pcopy(1,2)], [wires(i,3) wires(i,4)]);
            if d1 < threshold
                points = cat(1,points,wires(i,3:4));
                wind = cat(1,wind,i);
            elseif d2 < threshold
                points = cat(1,points,wires(i,1:2));
                wind = cat(1,wind,i);
            end
        end
        
        % remove the wires leading to the found points
        wcopy = wires;
        for i=1:1:size(wind,1)
            wcopy = cat(1,wcopy(1:wind(i)-1,:),wcopy(wind(i)+1:size(wcopy,1),:));
            wind = wind -1;
        end
        
        % search ports connected to those points
        port = pcopy(1,:);
        for i=1:1:size(points,1)
            p = output_generation.find_next_port(points(i,:),pcopy,wcopy);
            port = cat(1,port,p);
        end
        
        % connect ports
        head = objects(port(1,3));
        if port(1,4) == 0
            hport = "+";
        else
            hport = "-";
        end
        for i=2:1:size(port)
            tail = objects(port(i,3));
            if port(i,4) == 0
                tport = "+";
            else
                tport = "-";
            end
            connections = cat(1,connections,output_generation.Connection(head,hport,tail,tport));
        end
        
        % remove connected ports
        p = pcopy;
        pcopy = [];
        for i=1:1:size(p)
            found = 0;
            for j=1:1:size(port)
                if (port(j,:) == p(i,:))
                    found = 1;
                end
            end
            if found == 0
                pcopy = cat(1,pcopy,p(i,:));
            end
        end
    end

