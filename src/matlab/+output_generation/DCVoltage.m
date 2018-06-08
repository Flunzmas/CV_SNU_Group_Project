classdef DCVoltage < output_generation.Source
    %DCVOLTAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        volt
    end
    
    methods
        function obj = DCVoltage(name, x, y, orientation, volt)
            obj = obj@output_generation.Source(name, x, y, orientation);
            obj.volt = volt;
            obj.simscapeObjName = 'DC Voltage Source';
        end
        
        function block = addToSystem(obj, system)
            block = obj.addToSystem@output_generation.Source(system);
            set_param(block,'v0',num2str(obj.getVolt()));
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
        
        function volt = getVolt(obj)
            volt = obj.volt;
        end
    end
end

