% THIS IS THE MAIN SCRIPT, THE PROGRAM STARTS AND ENDS HERE.

%% environment variables
data_path = '../data/';
results_path = '../results/';
result_name = 'ec_model';

%% use a dialog to get the image
answer = questdlg('What type of image are you supplying?', ...
	'Image Type', ...
	'Photo', 'Screenshot','Screenshot');
im_original = selectImage();
imshow(im_original)
%% apply preprocessing
disp('main: preprocessing')
[im_mute, im_binarized, im_thin, ocr_result] = preprocess(im_original, answer);

%% retrieve EC components out of preprocessing results
disp('main: component recognition')
[elem_list, connection_endpoints] = analyse_image(im_binarized, im_thin, im_mute);

%% assemble simulink-model out of components
disp('main: model assembly')
ec_system = generate_output(elem_list, connection_endpoints, ocr_result);

%% save model
disp('main: save model')
save_system(ec_model, [results_path 'ec_model']);

%% done!
disp('main: done.')
