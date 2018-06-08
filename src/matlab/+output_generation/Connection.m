classdef Connection
    %CONNECTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        head
        tail
        hPort
        tPort
        lines
    end
    
    methods
        function obj = Connection(head, hPort, tail, tPort)
            obj.head = head;
            obj.tail = tail;
            obj.hPort = hPort;
            obj.tPort = tPort;
        end
        
        function connect(obj, system)
            name = get_param(system,'Name');
            hPort = obj.getHead().getPort(system, obj.hPort);
            tPort = obj.getTail().getPort(system, obj.tPort);
            line = add_line(name,hPort,tPort,'autorouting','on');
        end
        
        function head = getHead(obj)
            head = obj.head;
        end
        
        function tail = getTail(obj)
            tail = obj.tail;
        end
        
        function obj = setLines(obj, lines)
            obj.lines = lines;
        end
    end
end

