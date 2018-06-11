% Entry function for the model assembly. Takes the components and assembles
% a simulink model out of them.
function ec_system = generate_output(elem_list, connection_endpoints, ocr_result)

testList = cell(size(ocr_result.wordBoundingBoxes,1),2);
for i=1:1:size(ocr_result.wordBoundingBoxes)
    testList{i,2} = ocr_result.wordBoundingBoxes(i,:);
    testList{i,1} = ocr_result.words(i,:);
end

for i=1:1:size(elem_list,1)
    e = elem_list(i,:);
    e3 = e(3); e4 = e(4);
    c3 = cell(1); c4 = cell(1);
    c3{1} = [e3{1}(2) e3{1}(1)];
    c4{1} = [e4{1}(2) e4{1}(1)];
    elem_list(i,:) = cat(2,e(1:2),c3,c4);
end

%connection_endpoints = connection_endpoints(:,[2 1 4 3]);

objects = output_generation.generate_objects(elem_list, testList);
wireList = output_generation.preprocess_wires(connection_endpoints);
wires = output_generation.process_wires(elem_list, objects, wireList);
ec_system = output_generation.create_system('test_cell',objects,wires);