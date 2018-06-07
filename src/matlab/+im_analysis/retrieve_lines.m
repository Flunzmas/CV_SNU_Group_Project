
function lines = retrieve_lines(image, hough_rho_resolution, hpeak_threshold, ...
    hpeak_areasize, hline_max_gap, hline_min_length)

% use hough transform to retrieve lines
[hough_h, theta, rho] = hough(image, 'RhoResolution', hough_rho_resolution);
hough_p = houghpeaks(hough_h, 200, 'Threshold', ceil(hpeak_threshold*max(hough_h(:))), ...
    'NHoodSize', 2 * floor(hpeak_areasize.*size(hough_h) / 2) + 1);
hough_l = houghlines(image, theta, rho, hough_p, 'FillGap', hline_max_gap, ...
    'MinLength', hline_min_length);

% container structure: each line a row like [length angle x1 y1 x2 y2]
lines = zeros(length(hough_l), 6);

% check each line:
for N=1 : length(hough_l)
    
    % retrieve line info
    xy = [hough_l(N).point1; hough_l(N).point2];
    d_y = xy(2,2) - xy(1,2);
    d_x = xy(2,1) - xy(1,1);
    cur_line =  [(sqrt(d_y^2 + d_x^2))        ...
                 (atan2(d_y, d_x) * 180 / pi) ...
                 (hough_l(N).point1)          ...
                 (hough_l(N).point2)         ];
    lines(N, :) = cur_line;
end

% sort lines according to length
lines = sortrows(lines, 1, 'descend');