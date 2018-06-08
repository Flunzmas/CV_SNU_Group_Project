classdef Capacitor < output_generation.Element
    %Capacitor Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        farad
    end
    
    methods
        function obj = Capacitor(name, x, y, orientation, farad)
            obj = obj@output_generation.Element(name, x, y, orientation);
            obj.farad = farad;
            obj.simscapeObjName = 'Capacitor';
            obj.width = 60;
            obj.height = 120;
        end
        
        function block = addToSystem(obj, system)
            block = obj.addToSystem@output_generation.Element(system);
            set_param(block,'C',num2str(obj.getFarad()));
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
        
        function farad = getFarad(obj)
            farad = obj.farad;
        end
    end
end

