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

%% apply preprocessing
disp('main: preprocessing')
[im_mute, im_binarized, im_thin, ocr_result] = preprocess(im_original, answer);

%% retrieve EC components out of preprocessing results
disp('main: component recognition')
components = analyse_image(im_binarized, im_thin, im_mute);

%% assemble simulink-model out of components
disp('main: model assembly')
output_generation.run();
%ec_model = generate_output(components);

%% view and save model
disp('main: view and save')
% open_system(ec_model);
% save_system(ec_model, [results_path 'ec_model']);
%imwrite (im_thin, [results_path 'im_thin.png']); % temporarily here
%imwrite (ec_model, [results_path result_name '.png']); % temporarily here

%% done!
disp('main: done.')
