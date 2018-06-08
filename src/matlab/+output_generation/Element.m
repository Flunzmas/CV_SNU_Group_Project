classdef Element < output_generation.ElectricalObject
    %ELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = Element(name, x, y, orientation)
            obj = obj@output_generation.ElectricalObject(name, x, y, orientation);
            obj.simscapeObjPath = strcat(obj.simscapeObjPath,'/','Electrical Elements');
        end
    end
end

