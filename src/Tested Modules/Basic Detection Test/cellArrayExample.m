%Cell array returned from detection to output generation

%Element information
elemType    = "res";        %Element type: res, cap, ind, gnd, acc, acv, dcc, dcv
elemDirect  = "vert";       %Element direction: vert, hori

topLCoord   = [50, 39];     %Top left coordinate of element [row, col]
botRCoord   = [90, 59];     %Bottom right coordinate of element [row, col]


%Create cell array
elementList = cell(3, 4);   %3 elements with 4 fields

elementList(1, :)   = {elemType; elemDirect; topLCoord; botRCoord};
elementList(2, :)   = {elemType; elemDirect; topLCoord; botRCoord};
elementList(3, :)   = {elemType; elemDirect; topLCoord; botRCoord};


%Accessing cell array
elementList{1, 1}
elementList{1, 2}
elementList{1, 3}
elementList{1, 4}