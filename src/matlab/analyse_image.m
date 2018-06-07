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
angle_tol = 1.5;
line_percentage_tol = 0.1;
resistor_line_angle = 26.5;
cor_min_quality = 0.1;
cor_filter_size = 3;
cir_sensitivity = 0.90;

%% retrieve lines
lines = im_analysis.retrieve_lines(im_thin, hough_rho_resolution, hpeak_threshold, ...
    hpeak_areasize, hline_max_gap, hline_min_length);

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

% retrieve dimensions of a resistor in order to determine the scale of the
% ec's elements.
resistor_dim = im_analysis.retrieve_resistor_dim(lines, resistor_line_angle, angle_tol, line_percentage_tol)

% use a sliding-window approach to detect all relevant elements.
% TODO

% After detection, erases the elements from the image so that only the
% connections are left to deal with.
element_list = 0;
im_connections = im_analysis.erase_elements(im_thin, element_list);

% Retrieve the endpoints of all connections (-> parallel to the axes)
connection_lines = im_analysis.retrieve_lines(im_connections, ...
    hough_rho_resolution, hpeak_threshold, ...
    hpeak_areasize, hline_max_gap, hline_min_length);

line_angles = connection_lines(:,2);
connection_lines = connection_lines(min(mod(line_angles, 90), mod(-line_angles, 90)) < angle_tol, :);
connection_endpoints = connection_lines(:, 3:6);

%% fill the 'components' data structure
components = 0;

%% analyse corresponding text
components = im_analysis.detect_text(im_binarized, components);

%% [for debugging] show stuff

figure, imshow(im_thin), hold on
% plot(corners);
% viscircles(circles(:, 1:2), circles(:, 3), 'EdgeColor','b');

for N = 1 : length(connection_lines)
   plot([connection_lines(N, 3); connection_lines(N, 5)], ...
        [connection_lines(N, 4); connection_lines(N, 6)], ...
        'LineWidth',2,'Color','r');
end
% for N = 1 : length(skewed_lines)
%    plot([skewed_lines(N, 3); skewed_lines(N, 5)], ...
%         [skewed_lines(N, 4); skewed_lines(N, 6)], ...
%         'LineWidth',2,'Color','g');
% end
