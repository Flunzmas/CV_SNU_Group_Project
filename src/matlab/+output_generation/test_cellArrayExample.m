clc;

%Cell array returned from detection to output generation

%Element information
elemType    = "res";        %Element type: res, cap, ind, gnd, acc, acv, dcc, dcv
elemDirect  = "vert";       %Element direction: vert, hori

topLCoord   = [50, 39];     %Top left coordinate of element [row, col]
botRCoord   = [90, 59];     %Bottom right coordinate of element [row, col]


%Create cell array
elementList = cell(2, 4);   %3 elements with 4 fields

elementList(1, :)   = {"res"; "vert"; [250,239]; [290,259]};
elementList(2, :)   = {"ind"; "hori"; [139,150]; [159,190]};


%Accessing cell array
elementList{1, 1};
%cell2struct(elementList(1,1))
testList = cell(size(wordBoundingBoxes,1),2);

wordBoundingBoxes = {{'R1'};{'I1'};{'8.2Meg'};{'3.32n'}};
words = [[250 239 30 24];[139 150 30 24];[250 259 30 24];[139 170 30 24]];
%wireList = [[170,60,172,105];[130,105,174,105];[130,70,130,105];[60,70,130,70]];
wireList = [[200,150,159,170];[270,239,270,170];[270,170,200,150];[139,170,270,259]];
%[270,170,159,170];[270,239,270,170];
for i=1:1:size(wordBoundingBoxes)
    testList{i,1} = wordBoundingBoxes{i};
    testList{i,2} = words(i,:);
end

objects = generate_objects(elementList, testList);
wireList = preprocess_wires(wireList);
wires = process_wires(elementList, objects, wireList);
%create_system('test_cell',objects,wires);
run();
