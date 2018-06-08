classdef Inductor < output_generation.Element
    %Inductor Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        henry
    end
    
    methods
        function obj = Inductor(name, x, y, orientation, henry)
            obj = obj@Element(name, x, y, orientation);
            obj.henry = henry;
            obj.simscapeObjName = 'Inductor';
        end
        
        function block = addToSystem(obj, system)
            block = obj.addToSystem@Element(system);
            set_param(block,'l',num2str(obj.getHenry()));
        end
        
        function port = getPort(obj, system, port)
            switch port
               case '+'
                  port = obj.getPorts(system).LConn;
               case '-'
                  port = obj.getPorts(system).RConn;
               otherwise
                  error('Invalid port');
            end
            
        end
        
        function henry = getHenry(obj)
            henry = obj.henry;
        end
    end
end

