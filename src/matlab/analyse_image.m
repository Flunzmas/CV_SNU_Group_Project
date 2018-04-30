% Entry function for the EC component recognition. Takes a given
% preprocessing result and creates a data structure with all relevant EC
% components which should form part of the simulink model to be built.
function components = analyse_image(im_binarized, im_thin, im_edges)

%% object recognition parameters
hough_rho_resolution = 0.5;
hpeak_threshold = 0.02;
hpeak_areasize = 0.020;
hline_max_gap = 5;
hline_min_length = 10;
angle_tol = 3;
cor_min_quality = 0.1;
cor_filter_size = 3;
cir_sensitivity = 0.90;

%% retrieve lines
[hough_h, theta, rho] = hough(im_thin, 'RhoResolution', hough_rho_resolution);
hough_p = houghpeaks(hough_h, 200, 'Threshold', ceil(hpeak_threshold*max(hough_h(:))), ...
    'NHoodSize', 2 * floor(hpeak_areasize.*size(hough_h) / 2) + 1);
hough_l = houghlines(im_thin, theta, rho, hough_p, 'FillGap', hline_max_gap, ...
    'MinLength', hline_min_length);

% analyse and sort the lines for further usage
[lines axis_lines skewed_lines] = im_analysis.check_line_angle(hough_l, angle_tol);

%% retrieve corners
corners = detectHarrisFeatures(im_thin, 'MinQuality', cor_min_quality, ...
                                             'FilterSize', cor_filter_size);

%% retrieve circles
circles = zeros(1, 3);
for i = 6 : 10 : (min(size(im_thin)) / 4)
    [centers, radii] = imfindcircles(im_thin, [i i+10], 'Sensitivity', cir_sensitivity);
    if size(centers) > 0
        circles = [circles; [centers radii]]; %#ok<AGROW>
    end
end
if size(circles(:, 1)) > 0
    circles = circles(2:end, :);
end

%% TODO obj recog
ec_sources = im_analysis.detect_sources(lines, corners, circles);
ec_grounds = im_analysis.detect_grounds(lines, corners, circles);
ec_resistors = im_analysis.detect_resistors(lines, corners, circles);
ec_inductors = im_analysis.detect_inductors(lines, corners, circles);
ec_capacitors = im_analysis.detect_capacitors(lines, corners, circles);
ec_connections = im_analysis.detect_connections(lines, corners, circles);

%% fill the 'components' data structure
components = 0;

%% analyse corresponding text
components = im_analysis.detect_text(im_binarized, components);

%% [for debugging] show stuff

figure, imshow(im_thin), hold on
plot(corners);
viscircles(circles(:, 1:2), circles(:, 3), 'EdgeColor','b');

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
