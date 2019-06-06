function[new_image] = transform_image(image, best_transform)
% Transform an image using the given transfprmation matrix
% image  : image to be transformed
% best_transform : transformation matrix
% new_image : transformed output image

[h,w] = size(image);

% coordinates of corner points
corner_points = [1,1;w,1;w,h;1,h];
new_corners = zeros(2,4);
% transformed coordinates of the corner points
for i = 1:4
    new_corners(:,i) = transform_coordinates(corner_points(i,1),corner_points(i,2),best_transform);
end

min_corner = round(min(new_corners,[],2));
% shift required to fit image
if(min_corner(1,1) < 0)
    shift_x = abs(min_corner(1,1)) + 1;
else
    shift_x = 0;
end
if(min_corner(2,1) < 0)
    shift_y = abs(min_corner(2,1)) + 1;
else
    shift_y = 0;
end
w_new = w + shift_x;
h_new = h + shift_y;

max_corner = round(max(new_corners,[],2));
% addition frame size required
if max_corner(1,1) > w
    w_new = w_new + (max_corner(1,1) - w);
else
    w_new = max_corner(1,1);
end
if max_corner(2,1) > h
    h_new = h_new + (max_corner(2,1) - h);
else
    w_new = max_corner(2,1);
end
new_image = - ones(h_new, w_new);

% corners in new frame  
new_corners = new_corners + [shift_x;shift_y];
    
% breaking the transformation matrix into its component
tmatx = best_transform;
rotation_matrix = [tmatx(1,1),tmatx(2,1);tmatx(3,1),tmatx(4,1)];
translation_matrix = [tmatx(5,1);tmatx(6,1)];

% obtain the new image by transfomring pixel wise
for i = 1:h
    for j = 1:w
        new_coordinates = rotation_matrix * [j; i] + translation_matrix;
        new_coordinates = round(new_coordinates);
        new_image(new_coordinates(2,1)+ shift_y, new_coordinates(1,1)+shift_x) = image(i,j);
    end
end

% applying interpolation to obtain the missing pixel values on those pixels
% nearest neighbor interpolation
H = [tmatx(1,1),tmatx(2,1),tmatx(5,1);tmatx(3,1),tmatx(4,1),tmatx(6,1);0,0,1];
H_inv = inv(H);
for i = 1:h_new
    for j = 1:w_new
        if (new_image(i,j) == -1 && inpolygon(j,i,new_corners(1,:),new_corners(2,:))) 
            nearest_pixel = H_inv * [j-(shift_x + 1);i - (shift_y + 1);1];
            nearest_pixel = round(nearest_pixel);
            if (nearest_pixel(1,1) > 0) && (nearest_pixel(2,1) > 0) && (nearest_pixel(1,1) < w) && (nearest_pixel(2,1) < h)
                new_image(i,j) = image(nearest_pixel(2,1),nearest_pixel(1,1));
            end
        end
    end
end

% median interpolation
% for i = 1:h_new - 1
%     for j = 1:w_new - 1
%         if (new_image(i,j) == -1 ) && (i > 1) && (j > 1)
%             new_image(i,j) = median([new_image(i-1,j+1), new_image(i+1,j+1), new_image(i+1,j-1), new_image(i-1,j-1),new_image(i-1,j),new_image(i,j+1),new_image(i+1,j),new_image(i,j-1)]);
%         end
%     end
% end

% bilinear interpolation
% for i = 1:h_new - 1
%     for j = 1:w_new - 1
%         if (new_image(i,j) == -1 ) && (i > 1) && (j > 1)
%             new_image(i,j) = ((new_image(i-1,j+1) + new_image(i+1,j+1) + new_image(i+1,j-1) + new_image(i-1,j-1))/4);
%         end
%     end
% end

end