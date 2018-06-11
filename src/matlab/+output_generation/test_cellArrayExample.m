clc;

%Cell array returned from detection to output generation

%Element information
elemType    = "res";        %Element type: res, cap, ind, gnd, acc, acv, dcc, dcv
elemDirect  = "vert";       %Element direction: vert, hori

topLCoord   = [50, 39];     %Top left coordinate of element [row, col]
botRCoord   = [90, 59];     %Bottom right coordinate of element [row, col]


%Create cell array
elementList = cell(6, 4);   %3 elements with 4 fields

elementList(1, :)   = {"res"; "vert"; [250,150]; [270,190]};
elementList(2, :)   = {"acv"; "vert"; [150,150]; [170,190]};
elementList(3, :)   = {"cap"; "vert"; [350,150]; [370,190]};
elementList(4, :)   = {"res"; "vert"; [450,150]; [470,190]};
elementList(5, :)   = {"res"; "hori"; [190,90]; [210,110]};
elementList(6, :)   = {"gnd"; "vert"; [300,400]; [320,420]};


%Accessing cell array
elementList{1, 1};
%cell2struct(elementList(1,1))

wordBoundingBoxes = {{'S1'};{'SINE(18 5)'};{'R1'};{'1.2Meg'};{'C1'};{'1Meg'};{'R3'};{'1Meg'};{'R2'};{'1n'}};
testList = cell(size(wordBoundingBoxes,1),2);
words = [[160 160 30 24];[160 170 30 24]; [260 160 30 24];[270 170 30 24]; [360 160 30 24];[370 170 30 24]; [460 160 30 24];[470 170 30 24];[200 110 30 24];[200 120 30 24]];
%wireList = [[170,60,172,105];[130,105,174,105];[130,70,130,105];[60,70,130,70]];
wireList = [[160 150 160 100];[160 100 190 100];[210 100 460 100];[260 100 260 150];[360 100 360 150];[460 100 460 150]];
wireList = cat(1,wireList,[[310 400 310 300];[160 190 160 300];[160 300 460 300];[260 300 260 190];[360 300 360 190];[460 300 460 190]]);
%[270,170,159,170];[270,239,270,170];
testList = cell(size(wordBoundingBoxes,1),2);
for i=1:1:size(wordBoundingBoxes)
    testList{i,1} = wordBoundingBoxes{i};
    testList{i,2} = words(i,:);
end

objects = output_generation.generate_objects(elementList, testList);
wireList = output_generation.preprocess_wires(wireList);
wires = output_generation.process_wires(elementList, objects, wireList);
output_generation.create_system('test_cell',objects,wires);
