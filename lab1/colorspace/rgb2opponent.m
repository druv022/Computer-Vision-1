function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space

output_image = zeros(size(input_image));
R = input_image(:, :, 1);
G = input_image(:, :, 2);
B = input_image(:, :, 3);

output_image(:,:,1) = (R-G)./(2^0.5);
output_image(:,:,2) = (R + G- B*.2)./(6^0.5);
output_image(:,:,3) = (R + G + B)./(3^0.5);

imwrite(output_image, 'rgb_opponent.jpg');



end

