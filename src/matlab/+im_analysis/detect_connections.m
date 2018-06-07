% TODO
function ec_connections = detect_connections(im_connections)

elem_endpoints = find_endpoints(elems);
line_endpoints = reshape(axis_lines(:,[3 5 4 6])); % all poitns

connections = cell();

cur_start = source_pt;






















ec_connections = 0;
end

function point = find_near_point(line_endpoints, cur_point)

point = [-1, -1];
points = find()

end

function lines_new = remove_line(lines, row_nr)

index = true(1, size(lines, 1));
index([row_nr]) = false;
lines_new = lines(index, :);
clear('lines');

end