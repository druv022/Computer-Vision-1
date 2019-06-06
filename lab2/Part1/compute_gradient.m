function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)
I = double(imread(image));

sobel_x =  [1 0 -1 ; 2 0 -2 ; 1 0 -1];
sobel_y =  [1 2 1 ; 0 0 0 ; -1 -2 -2];

Gx = filter2(sobel_x, I);
Gy = filter2(sobel_y, I);

im_magnitude = sqrt(Gx.*Gx + Gy.*Gy);
im_direction = atan(Gy./Gx)*(180/pi);
end

