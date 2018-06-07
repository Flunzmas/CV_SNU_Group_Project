function imIn = selectImage()

%options
fileExtensions = '*.png;*.jpg;*.jpeg';

%open file picker
[file, path] = uigetfile(fileExtensions);

%read image as double
imIn = im2double(imread(strcat(path, file)));