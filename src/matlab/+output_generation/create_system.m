function ec_system = create_system(name,elements,connections)
    if bdIsLoaded(name)
        bdclose(name);
    end
    
    ec_system = new_system(name);
    open_system(name);
    
    for i=1:1:size(elements)
       elements(i).addToSystem(ec_system);
    end
    
    for i=1:1:size(connections)
        i
       connections(i).connect(ec_system);
    end
    
end

