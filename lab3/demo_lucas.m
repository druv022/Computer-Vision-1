function [] = demo_lucas(image_type)

if strcmp(image_type, 'synth')
   
    [u, v, R, C]=lucas_kanade('synth2.pgm','synth1.pgm');

elseif strcmp(image_type, 'sphere')
   
   [u, v, R, C]=lucas_kanade('sphere2.ppm','sphere1.ppm');

else
    disp('pass the correct argument sphere or synth')
    
end


end