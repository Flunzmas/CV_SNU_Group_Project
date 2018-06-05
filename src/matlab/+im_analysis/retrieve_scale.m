% TODO resistors = skewed lines bipartite parallel and intersections form a
% parallelogram.
function [long_side, short_side] = retrieve_scale(skewed_lines, pixel_tol);

% assumption: the longest skewed lines are mostly resistor lines.
line_lengths = skewed_lines(:,1);
line_angles = skewed_lines(:,2);
max_length = max(skewed_lines(:,1));
long_up_lines = skewed_lines(line_lengths >= max_length - pixel_tol ...
                     & line_angles < 0, :)

if size(long_up_lines, 1) < 1
   error('No resistor lines detected, cannot compute scale!'); 
end

line_diffs = [long_up_lines(:,5) - long_up_lines(:,3), ...
     long_up_lines(:,4) - long_up_lines(:,6)]

for i = 1:numel(line_diffs(:,1))
    if line_diffs(i,2) < line_diffs(i,1)
        temp = line_diffs(i,1);
        line_diffs(i,1) = line_diffs(i,2);
        line_diffs(i,2) = temp;
    end
end
line_diffs

long_side = mean(line_diffs(:,1)) * 4
short_side = mean(line_diffs(:,2))