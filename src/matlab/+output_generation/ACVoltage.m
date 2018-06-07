classdef ACVoltage < Source
    %ACVOLTAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        amplitude
        frequency
    end
    
    methods
        function obj = ACVoltage(name, x, y, orientation, amplitude, frequency)
            obj = obj@Source(name, x, y, orientation);
            obj.amplitude = amplitude;
            obj.frequency = frequency;
            obj.simscapeObjName = 'AC Voltage Source';
        end
        
        function block = addToSystem(obj, system)
            block = obj.addToSystem@Source(system);
            set_param(block,'amp',num2str(obj.getAmplitude()));
            set_param(block,'frequency',num2str(obj.getFrequency()));
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
        
        function amplitude = getAmplitude(obj)
            amplitude = obj.amplitude;
        end
        
        function frequency = getFrequency(obj)
            frequency = obj.frequency;
        end
    end
end

