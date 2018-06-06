classdef ElectricalObject < matlab.mixin.Heterogeneous
    %OBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        x
        y
        width = 80
        height = 60
        orientation
        simscapeObjName
        simscapeObjPath = 'fl_lib/Electrical'
        simscapeBlock
    end
    
    methods
        function obj = ElectricalObject(name, x, y, orientation)
            if nargin > 0
                obj.name = name;
                obj.x = x;
                obj.y = y;
                obj.orientation = orientation;
            end
        end
        
        function block = addToSystem(obj, system)
            obj.simscapeBlock = add_block(obj.getSimscapeObjPath(),strcat(get_param(system,'Name'),'/',obj.getName()));
            x = obj.getXPos();
            y = obj.getYPos();
            h = obj.getHeight();
            w = obj.getWidth();            
            set_param(obj.simscapeBlock,'Position',[x-w/2 y-h/2 x+w/2 y+h/2]); % [left top right bottom]
            set_param(obj.simscapeBlock,'Orientation',obj.getOrientation());
            block = obj.simscapeBlock;
        end
        
        function ports = getPorts(obj, system)
            ports = get_param(strcat(get_param(system,'Name'),'/',obj.getName()),'PortHandles');
        end
        
        function name = getName(obj)
            name = obj.name;
        end
        
        function x = getXPos(obj)
            x = obj.x;
        end
        
        function y = getYPos(obj)
            y = obj.y;
        end
        
        function width = getWidth(obj)
            width = obj.width;
        end
        
        function height = getHeight(obj)
            height = obj.height;
        end
        
        function orientation = getOrientation(obj)
            orientation = obj.orientation;
        end
        
        function simscapeObjName = getSimscapeObjName(obj)
            simscapeObjName = obj.simscapeObjName;
        end
        
        function simscapeObjPath = getSimscapeObjPath(obj)
           simscapeObjPath = strcat(obj.simscapeObjPath,'/',obj.getSimscapeObjName());
        end
        
        function port = getPort(obj, system, name)
            error('Invalid call to getPort in superclass');
        end
    end
end

