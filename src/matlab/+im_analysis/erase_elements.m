% given the list of elements with their boundaries, removes them from the
% image by coloring corresponding regions in black.
function im_connections = erase_elements(image, elem_list)

im_connections = image;
[i_rows, i_cols, ~] = size(im_connections);

% some boundary case/wrong order handling needed
for i = 1 : size(elem_list, 1)
   endpoints = [elem_list{i,3}; elem_list{i, 4}]'; % row row \\ col col
   endpoints(endpoints < 1) = 1;
   endpoints(endpoints(endpoints(1,:) > i_rows), :) = i_rows;
   endpoints(endpoints(endpoints(2,:) > i_cols), :) = i_cols;
   im_connections(min(endpoints(1,:)):max(endpoints(1,:)), ...
                  min(endpoints(2,:)):max(endpoints(2,:))) = false;
end