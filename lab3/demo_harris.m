function [] = demo_harris(image_type, rotate)
% image_type: person or pingpong
% rotate    : boolean, true or false only
%
% call:  demo_harris('person', false)
%
if strcmp(image_type, 'person')
    image = imread('person_toy/00000001.jpg');
    
    % rotate the image
    if rotate
        angle = rand * 360;
        image = imrotate(image, angle);
    end
    
    % evaluate Harris corners
    [H, r, c]=harris_corner_detector(image,3,7,2,3);
    
elseif strcmp(image_type, 'pingpong')
    image = imread('pingpong/0000.jpeg');
    
    % rotate the image
    if rotate
        angle = rand * 360;
        image = imrotate(image, angle);
        disp(['Angle of rotation:' num2str(angle)]);
    end
    
    % evaluate Harris corners
    [H, r, c]=harris_corner_detector(image,3,5,18,3);
    
else
    disp('pass the correct argument person or pingpong')
end

end