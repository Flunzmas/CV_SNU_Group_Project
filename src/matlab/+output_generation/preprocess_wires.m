function nwires = preprocess_wires(wires)
%PREPROCESS_WIRES Summary of this function goes here
%   Detailed explanation goes here
    wcount = size(wires,1);
    wcopy = wires;
    nwires = [];
    threshold = 5;
    
    %eliminate interscections
    for i=1:1:wcount    
        for j=1:1:wcount
            if is_on_line([wcopy(i,1) wcopy(i,2)], wcopy(j,:))
                wcopy(i,1:2) = wcopy(j,1:2);
            end
            if is_on_line([wcopy(i,3) wcopy(i,4)], wcopy(j,:))
                wcopy(i,3:4) = wcopy(j,1:2);
            end
        end
    end
        
    % eliminate corners: restart the loops every time a corner is
    % eliminated
    wire = zeros(1,4);
    i=0;
    while i<wcount
        i=i+1;
        f=0;
        wire = wcopy(i,:);
        j = 0;
        while j<wcount
            if f==1
                break
            end
            j=j+1;
            if i ~= j
                d = calc_distance([wire(1), wire(2)], [wcopy(j,1), wcopy(j,2)]);
                if d < threshold
                    wire = [wire(3) wire(4) wcopy(j,3) wcopy(j,4)];
                    wcopy = cat(1,wcopy(1:i-1,:),wcopy(i+1:j-1,:),wcopy(j+1:wcount,:),wire);
                    wcount = wcount-1;
                    j = 0; i=0; f=1;
                    continue
                end

                d = calc_distance([wire(1), wire(2)], [wcopy(j,3), wcopy(j,4)]);
                if d < threshold
                    wire = [wire(3) wire(4) wcopy(j,1) wcopy(j,2)];
                    wcopy = cat(1,wcopy(1:i-1,:),wcopy(i+1:j-1,:),wcopy(j+1:wcount,:),wire);
                    wcount = wcount-1;
                    j = 0; i=0; f=1;
                    continue
                end
                
                d = calc_distance([wire(3), wire(4)], [wcopy(j,1), wcopy(j,2)]);
                if d < threshold
                    wire = [wire(1) wire(1) wcopy(j,3) wcopy(j,4)];
                    wcopy = cat(1,wcopy(1:i-1,:),wcopy(i+1:j-1,:),wcopy(j+1:wcount,:),wire);
                    wcount = wcount-1;
                    j = 0; i=0; f=1;
                    continue
                end
                
                d = calc_distance([wire(3), wire(4)], [wcopy(j,3), wcopy(j,4)]);
                if d < threshold
                    wire = [wire(1) wire(2) wcopy(j,1) wcopy(j,2)];
                    wcopy = cat(1,wcopy(1:i-1,:),wcopy(i+1:j-1,:),wcopy(j+1:wcount,:),wire);
                    wcount = wcount-1;
                    j = 0; i=0; f=1;
                    continue
                end
            end
        end
    end
    
    nwires = wcopy;
        
end

