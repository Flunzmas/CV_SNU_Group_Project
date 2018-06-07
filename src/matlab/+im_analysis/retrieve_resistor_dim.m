% Retrieves the dimensions of resistors in this EC image in order to
% retrieve the scale of all EC elements in the image.
function resistor_dim = retrieve_resistor_dim(lines, min_angle_deviance, res_angle_tol, line_percentage_tol);

% assumption: at least one resistor in the circuit.
% retrieve longest line with sufficient angle, assumption: resistor line.
line_angles = lines(:,2);
res_line_cand = lines(min(mod(line_angles, 90), mod(-line_angles, 90)) > min_angle_deviance, :);

% if no line found: abort
if size(res_line_cand, 1) < 1
   error('No skewed lines detected, cannot compute scale!'); 
end
   
lls = res_line_cand(:,1); % line_lengths
longest_line = res_line_cand(1,:);

% use the angle of the longest line to add all half-length resistor lines.
% when doubled, they might yield a better dimension approximation.
la = longest_line(2);
A = res_line_cand(abs(lls./max(lls) - 0.5) < line_percentage_tol, :);
B = [A(:,1) (A(:,2) + la) A(:,3:6); A(:,1) (A(:,2) - la) A(:,3:6)];
prepped_angles = min(abs(mod(B(:,2), 90)), abs(mod(-B(:,2), 90)));

B = B(prepped_angles < res_angle_tol, :); % half-length resistor lines
res_line_cand = [res_line_cand(1,:); 2 * B]; % longest line and doubled B

% the now longest line is our reference line
[~,ind] = max(res_line_cand(:,1));
ref_line = res_line_cand(ind, :);

% use the x- and y- differences to get the resistor's dimensions.
diffs = [abs(ref_line(5) - ref_line(3)), abs(ref_line(6) - ref_line(4))];
resistor_dim = [max(diffs), 4 * min(diffs)];

end