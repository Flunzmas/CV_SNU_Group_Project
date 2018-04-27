% Entry function for the EC component recognition. Takes a given
% preprocessing result and creates a data structure with all relevant EC
% components which should form part of the simulink model to be built.
function components = get_components(im_binarized, im_thin, im_edges)

%% object recognition parameters
todo = 0;

%% set-up
components = todo;

%% retrieve lines
[h_trans, theta, rho] = hough(im_edges);
peaks = houghpeaks(h_trans, 200, 'threshold', ceil(0.005*max(h_trans(:))));
lines = houghlines(im_edges, theta,rho,peaks,'FillGap',2,'MinLength',10);

%% retrieve corners
corners = detectHarrisFeatures(im_binarized, 'MinQuality', 0.1);

%% retrieve circles
% TODO retrieve circles
circles = 0;

%% TODO obj recog
ec_sources = comp_recognition.retrieve_sources(lines, corners, circles);
ec_resistors = comp_recognition.retrieve_resistors(lines, corners, circles)
ec_capacitors = comp_recognition.retrieve_capacitors(lines, corners, circles);
ec_inductors = comp_recognition.retrieve_inductors(lines, corners, circles);

%% arrange components structure


%% analyse corresponding text
components = comp_recognition.analyse_text(im_edges, components);

%% show stuff (for debugging)

figure, imshow(im_thin), hold on
plot(corners.selectStrongest(200));
viscircles(circ_centers, circ_radii, 'EdgeColor','b');

for N = 1 : length(lines)
   xy = [lines(N).point1; lines(N).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
end
