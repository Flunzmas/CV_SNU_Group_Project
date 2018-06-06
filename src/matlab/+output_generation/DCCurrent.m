classdef DCCurrent < Source
    %DCVOLTAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ampere
    end
    
    methods
        function obj = DCCurrent(name, x, y, orientation, ampere)
            obj = obj@Source(name, x, y, orientation);
            obj.ampere = ampere;
            obj.simscapeObjName = 'DC Current Source';
        end
        
        function block = addToSystem(obj, system)
            block = obj.addToSystem@Source(system);
            set_param(block,'i0',num2str(obj.getAmpere()));
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
        
        function ampere = getAmpere(obj)
            ampere = obj.ampere;
        end
    end
end

