clc;

%Cell array returned from detection to output generation

%Element information
elemType    = "res";        %Element type: res, cap, ind, gnd, acc, acv, dcc, dcv
elemDirect  = "vert";       %Element direction: vert, hori

topLCoord   = [50, 39];     %Top left coordinate of element [row, col]
botRCoord   = [90, 59];     %Bottom right coordinate of element [row, col]


%Create cell array
elementList = cell(2, 4);   %3 elements with 4 fields

elementList(1, :)   = {"res"; "vert"; [150,39]; [190,59]};
elementList(2, :)   = {"ind"; "hori"; [39,50]; [59,90]};


%Accessing cell array
elementList{1, 1};
%cell2struct(elementList(1,1))
testList = cell(size(wordBoundingBoxes,1),2);

wordBoundingBoxes = {{'R1'};{'I1'};{'8.2Meg'};{'3.32n'}};
words = [[150 39 30 24];[39 50 30 24];[150 59 30 24];[39 70 30 24]];
for i=1:1:size(wordBoundingBoxes)
    testList{i,1} = wordBoundingBoxes{i};
    testList{i,2} = words(i,:);
end

objects = generate_objects(elementList, testList);
create_system('test_cell',objects,[])
