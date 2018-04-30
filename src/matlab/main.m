% THIS IS THE MAIN SCRIPT, THE PROGRAM STARTS AND ENDS HERE.

%% set environment variables
data_path = '../data/';
results_path = '../results/';
result_name = 'ec_model';

%% read the image
disp('main: loading image')
im_original = double(imread(sprintf('%scirc1.png', data_path)))/255;

%% apply preprocessing
disp('main: preprocessing')
[im_binarized, im_thin, im_edges] = preprocess(im_original);

%% retrieve EC components out of preprocessing results
disp('main: component recognition')
components = analyse_image(im_binarized, im_thin, im_edges);

%% assemble simulink-model out of components
disp('main: model assembly')
ec_model = generate_output(components);

%% view and save model
disp('main: view and save')
% open_system(ec_model);
% save_system(ec_model, [results_path 'ec_model']);
imwrite (im_thin, [results_path 'im_thin.png']); % temporarily here
imwrite (ec_model, [results_path result_name '.png']); % temporarily here

%% done!
disp('main: done.')
