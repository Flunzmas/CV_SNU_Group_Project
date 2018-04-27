% Entry function for the EC component recognition. Takes a given
% preprocessing result and creates a data structure with all relevant EC
% components which should form part of the simulink model to be built.
function components = get_components(im_binarized, im_edges)

%% object recognition parameters
todo = 0;

%% set-up
components = todo;

%% retrieve lines
[h_trans, theta, rho] = hough(im_edges);
peaks = houghpeaks(h_trans, 200, 'threshold', ceil(0.1*max(h_trans(:))));
lines = houghlines(im_edges,theta,rho,peaks,'FillGap',5,'MinLength',30);

%% retrieve corners
corner_points = detectHarrisFeatures(im_binarized,'MinQuality',0.1);

%% TODO obj recog


%% analyse corresponding text
components = comp_recognition.analyse_text(im_binarized, components);

%% show stuff (for debugging)
% 
% figure, imshow(im_binarized), hold on
% 
% for N = 1 : length(lines)
%    xy = [lines(N).point1; lines(N).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% end
% 
% plot(corner_points.selectStrongest(200), 'LineWidth', 3, 'Color', 'red');    
