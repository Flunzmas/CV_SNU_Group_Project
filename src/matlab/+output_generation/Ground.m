classdef Ground < output_generation.Element
    %ElectricalReference Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Ground(name, x, y, orientation)
            obj = obj@output_generation.Element(name, x, y, orientation);
            obj.simscapeObjName = 'Electrical Reference';
            obj.width = 30;
            obj.height = 30;
        end
        
        function block = addToSystem(obj, system)
            block = obj.addToSystem@output_generation.Element(system);
        end
        
        function port = getPort(obj, system, port)
            switch port
               case '+'
                  port = obj.getPorts(system).LConn;
               otherwise
                  error('Invalid port');
            end
            
        end
    end
end

