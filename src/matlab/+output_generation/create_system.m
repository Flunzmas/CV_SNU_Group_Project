function model = create_system(name,elements,connections)
    if bdIsLoaded(name)
        bdclose(name);
    end
    
    system = new_system(name);
    open_system(name);
    
    for i=1:1:size(elements)
       elements(i).addToSystem(system);
    end
    
    for i=1:1:size(connections)
       connections(i).connect(system);
    end
    
end

