% Retrieves the dimensions of resistors in this EC image in order to
% retrieve the scale of all EC elements in the image.
function resistor_dim = retrieve_resistor_dim(lines, resistor_line_angle, angle_tol, line_percentage_tol);

% assumption: at least one resistor in the circuit.
% retrieve longest line after having stretched the half-lengthed lines at
% beginnings by the factor 2.
line_angles = lines(:,2);
resistor_lines = lines(abs(line_angles - resistor_line_angle) < angle_tol ...
                     | abs(line_angles - (90-resistor_line_angle)) < angle_tol ...
                     | abs(line_angles + resistor_line_angle) < angle_tol ...
                     | abs(line_angles + (90-resistor_line_angle)) < angle_tol, :);
lls = resistor_lines(:,1);
resistor_lines = [resistor_lines(1,:); ...
    2 * (resistor_lines(abs(lls/max(lls) - 0.5) < line_percentage_tol, :))];

if size(resistor_lines, 1) < 1
   error('No resistor lines detected, cannot compute scale!'); 
end

[~,ind] = max(resistor_lines(:,1));
ref_line = resistor_lines(ind, :);

% use the x- and y- differences to get the resistor's dimensions.
diffs = [abs(ref_line(5) - ref_line(3)), abs(ref_line(6) - ref_line(4))];
resistor_dim = [max(diffs), 4 * min(diffs)];