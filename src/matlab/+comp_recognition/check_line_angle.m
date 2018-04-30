% given line start and and points: 'lines' has got all lines sorted desc. by
% length, 'axis_lines' and 'skewed_lines' contain their lines sorted by
% angle.
function [lines, axis_lines, skewed_lines] = check_line_angle(hough_l, angle_tol)

% container structure: each line a row like [length angle x1 y1 x2 y2]
lines = zeros(length(hough_l), 6);
skewed_lines = zeros(length(hough_l), 6);
axis_lines = zeros(length(hough_l), 6);

% check each line:
num_skewed = 0;
num_axis = 0;
for N=1 : length(hough_l)
    
    % retrieve line info
    xy = [hough_l(N).point1; hough_l(N).point2];
    d_y = xy(2,2) - xy(1,2);
    d_x = xy(2,1) - xy(1,1);
    cur_line =  [(sqrt(d_y^2 + d_x^2))        ...
                 (atan2(d_y, d_x) * 180 / pi) ...
                 (hough_l(N).point1)          ...
                 (hough_l(N).point2)         ];
    
    % determine whether line is skewed, categorize accordingly
    if min(mod(cur_line(2), 90), 90 - mod(cur_line(2), 90)) > angle_tol
        num_skewed = num_skewed + 1;
        skewed_lines(num_skewed, :) = cur_line;
    else
        num_axis = num_axis + 1;
        axis_lines(num_axis, :) = cur_line;
    end
    lines(N, :) = cur_line;
end

% sort lines according to length or angle
lines = sortrows(lines, 1, 'descend'); % LENGTH
skewed_lines = sortrows(skewed_lines(1:num_skewed, :), 2); % ANGLE
axis_lines = sortrows(axis_lines(1:num_axis, :), 2); % ANGLE
