% Takes the binarized image and the components list to retrieve textual
% information for the corresponding components and add them to the
% components structure.
function new_components = analyse_text(im_binarized, components)

%% TODO
ocr_result = ocr(im_binarized);
new_components = components;