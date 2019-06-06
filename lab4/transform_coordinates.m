function[new_coordinates] = transform_coordinates(x, y, tmatx)
% transform single coordinates
% x      : x coordinate
% y      : y coordinate
% tmatx  : transformation matrix
% new_coordinate: return transformed coordinates in [x;y] format


rotation_matrix = [tmatx(1,1),tmatx(2,1);tmatx(3,1),tmatx(4,1)];
translation_matrix = [tmatx(5,1);tmatx(6,1)];

new_coordinates = rotation_matrix * [x; y] + translation_matrix;
 
end