function [smth] = filter_function(image, sigma)
% This function smooths the image with a Gaussian filter of width sigma

smask = fspecial('gaussian', ceil(3*sigma), sigma);
smth = filter2(smask, image, 'same');
