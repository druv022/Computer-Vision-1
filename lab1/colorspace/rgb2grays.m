function [output_image] = rgb2grays(input_image)
% converts an RGB into grayscale by using 4 different methods
[h, w, ~] = size(input_image);
output_image = zeros(h, w, 4);
R = input_image(:, :, 1);
G = input_image(:, :, 2);
B = input_image(:, :, 3);

% ligtness method
rgb2L = (max(max(R, G), B) + min(min(R, G), B))./2;
output_image(:,:, 1) = rgb2L;

% average method
rgb2avg = (R+G+B)./3 ;
output_image(:,:, 2)= rgb2avg;

% luminosity method
rgb2lum = R.*0.21 + G.*0.72 + B.*0.07;
output_image(:,:, 3) = rgb2lum; 

% built-in MATLAB function 
I = rgb2gray(input_image);
output_image(:,:, 4) = I; 
 
end

