classdef Resistor < Element
    %RESISTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ohm
    end
    
    methods
        function obj = Resistor(name, x, y, orientation, ohm)
            obj = obj@Element(name, x, y, orientation);
            obj.ohm = ohm;
            obj.simscapeObjName = 'Resistor';
        end
        
        function block = addToSystem(obj, system)
            block = obj.addToSystem@Element(system);
            set_param(block,'R',num2str(obj.getOhm()));
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
        
        function ohm = getOhm(obj)
            ohm = obj.ohm;
        end
    end
end

