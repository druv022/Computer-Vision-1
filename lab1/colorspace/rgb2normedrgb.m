function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb

output_image = zeros(size(input_image));

R = input_image(:, :, 1);
G = input_image(:, :, 2);
B = input_image(:, :, 3);

Norm_ = R+G+B;

output_image(:,:,1) = (R)./Norm_;
output_image(:,:,2) = (G)./Norm_;
output_image(:,:,3) = (B)./Norm_;
imwrite(output_image, 'normrgb.jpg');

end

