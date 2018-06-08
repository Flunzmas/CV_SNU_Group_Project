function objects = generate_objects(elementList, textList)
    eLsize = size(elementList,1);

    for i=1:1:eLsize
        e = elementList(i,:);
        x = (e{3}(1)+e{4}(1))/2;
        y = (e{3}(2)+e{4}(2))/2;
        orientation = "";
        if e{2}=="hori"
            orientation = "right";
        elseif e{2}=="vert"
            orientation = "down";
        end
        
        % calculate the distance between the labels and the current object
        for j=1:1:size(textList,1)
            t = textList(j,:);
            loc = t{2};
            distance = calc_distance([(loc(1)+loc(3)/2) (loc(2)+loc(4)/2)], [x y]);
            textList{j,3} = loc(2);
            textList{j,4} = distance;
        end
        
        %get values with lowest distance and sort by y-value
        [~, idx] = sort(cell2mat(textList(:,4)));
        tL = textList(idx,:);
        tL = tL(1:2,:);
        [~, idx] = sort(cell2mat(tL(:,3)));
        tL = tL(idx,:);
        
        % find value and 10^x of the object
        label = tL{1,1}{1};
        valueLabel = tL{2,1}{1};
        exp = "[A-Za-z]*";
        value = str2double(regexprep(valueLabel,exp,""));
        exp = "[1-9]*\.[1-9]*";
        unit = regexprep(valueLabel,exp,"");
        
        % multiply the value with the found 10^x
        switch unit
            case "p"
                value = value*10^(-12);
            case "n"
                value = value*10^(-9);
            case "µ"
                value = value*10^(-6);
            case "m"
                value = value*10^(-3);
            case "k"
                value = value*10^(3);
            case "Meg"
                value = value*10^(6);
            case "G"
                value = value*10^(9);
            otherwise
                error("Invalid unit");
        end
        
        % create objects
        switch e{1}
            case "res"
                objects(i) = Resistor(label,x,y,orientation,value);
            case "ind"
                objects(i) = Inductor(label,x,y,orientation,value);
            case "cap"
                objects(i) = Capacitor(label,x,y,orientation,value);
            case "gnd"
                objects(i) = Ground(label,x,y,orientation,value);
            case "acc"
                objects(i) = ACCurrent(label,x,y,orientation,value);
            case "acv"
                objects(i) = ACVoltage(label,x,y,orientation,value);
            case "dcc"
                objects(i) = DCCurrent(label,x,y,orientation,value);
            case "dcv"
                objects(i) = DCVoltage(label,x,y,orientation,value);
            otherwise
                error("Invalid element");
        end
    end
    objects = transpose(objects);
end

