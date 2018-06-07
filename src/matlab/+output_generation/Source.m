classdef Source < ElectricalObject
    %ELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = Source(name, x, y, orientation)
            obj = obj@ElectricalObject(name, x, y, orientation);
            obj.simscapeObjPath = strcat(obj.simscapeObjPath,'/','Electrical Sources');
            obj.width = 60;
            obj.height = 90;
        end
    end
end

