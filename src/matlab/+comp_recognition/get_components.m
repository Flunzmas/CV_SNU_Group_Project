% Entry function for the EC component recognition. Takes a given
% preprocessing result and creates a data structure with all relevant EC
% components which should form part of the simulink model to be built.
function components = get_components(im_binarized, im_thin, im_edges)

%% object recognition parameters
hough_rho_resolution = 0.5;
hpeak_threshold = 0.02;
hpeak_areasize = 0.020;
hline_max_gap = 5;
hline_min_length = 10;
angle_tol = 3;

%% retrieve lines
[hough_h, theta, rho] = hough(im_thin, 'RhoResolution', hough_rho_resolution);
hough_p = houghpeaks(hough_h, 200, 'Threshold', ceil(hpeak_threshold*max(hough_h(:))), ...
    'NHoodSize', 2 * floor(hpeak_areasize.*size(hough_h) / 2) + 1);
hough_l = houghlines(im_thin, theta, rho, hough_p, 'FillGap', hline_max_gap, ...
    'MinLength', hline_min_length);

% analyse and sort the lines for further usage
[lines axis_lines skewed_lines] = comp_recognition.check_line_angle(hough_l, angle_tol);
lines
axis_lines
skewed_lines

%% retrieve corners
corners = detectHarrisFeatures(im_binarized, 'MinQuality', 0.1);

%% retrieve circles
% TODO retrieve circles
circles = 0;

%% TODO obj recog
ec_sources = comp_recognition.detect_sources(lines, corners, circles);
ec_resistors = comp_recognition.detect_resistors(lines, corners, circles);
ec_inductors = comp_recognition.detect_inductors(lines, corners, circles);
ec_capacitors = comp_recognition.detect_capacitors(lines, corners, circles);
ec_connections = comp_recognition.detect_connections(lines, corners, circles);

%% fill the 'components' data structure
components = 0;

%% analyse corresponding text
components = comp_recognition.analyse_text(im_edges, components);

%% [for debugging] show stuff

figure, imshow(im_thin), hold on
% plot(corners.selectStrongest(200));
% viscircles(circ_centers, circ_radii, 'EdgeColor','b');

for N = 1 : length(axis_lines)
   plot([axis_lines(N, 3); axis_lines(N, 5)], ...
        [axis_lines(N, 4); axis_lines(N, 6)], ...
        'LineWidth',2,'Color','r');
end
for N = 1 : length(skewed_lines)
   plot([skewed_lines(N, 3); skewed_lines(N, 5)], ...
        [skewed_lines(N, 4); skewed_lines(N, 6)], ...
        'LineWidth',2,'Color','g');
end
