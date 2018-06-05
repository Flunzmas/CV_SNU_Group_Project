% TODO inductor = a series of connected half-circles
function ec_inductors = detect_inductors(axis_lines, corners, circles)

% check for at least three equal distances between circle centers
circ_distances = squareform(pdist(circles(:, 1:2)));
distance_buddies = im_analysis.find_distance_buddies(circ_distances, 3);




ec_inductors = 0;