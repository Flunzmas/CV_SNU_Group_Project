% Entry function for the model assembly. Takes the components and assembles
% a simulink model out of them.
function ec_system = generate_output(elem_list, connection_endpoints, ocr_result)

objects = output_generation.generate_objects(elem_list, ocr_result);
wireList = output_generation.preprocess_wires(connection_endpoints);
wires = output_generation.process_wires(elem_list, objects, wireList);
ec_system = output_generation.create_system('test_cell',objects,wires);