% Extracts the corners of the paper displayed in given image, assuming the
% surroundings of the paper are darker.
function p_correspondences = detect_paper(im_original)

p_correspondences = [0 0 0 0;
                     0 0 0 0];

% TODO