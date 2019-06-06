function[rgb_image] = stitch(image_1, image_2)
% Perform stitching of two image
% image_1: reference image
% image_2: second image which will be aligned and stitched to image_1
% rgb_image: return the stitched image in rgb format

% conversion to gray scale
if length(size(image_1)) > 2
    image1 = rgb2gray(image_1);
end    
if length(size(image_2)) > 2
    image2 = rgb2gray(image_2);
end

% obtaining the matching points
[points1, points2] = keypoint_matching(image1, image2);

% obtain transformation matrix for image 2 to image 1, 
best_transform = RANSAC(points2, points1,1000, 3);

[h1, w1] = size(image1);
[h2,w2] = size(image2);

% obtain the transformed corner points
corner_points = [1,1;w2,1;w2,h2;1,h2];
new_corners = zeros(2,4);
for i = 1:4
    new_corners(:,i) = transform_coordinates(corner_points(i,1),corner_points(i,2),best_transform);
end

min_corner = round(min(new_corners,[],2));
% shift required for fixed image on new frame
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
w_new = w1 + shift_x;
h_new = h1 + shift_y;

max_corner = round(max(new_corners,[],2));
% Extra space required for the new frame
if max_corner(1,1) > w1
    w_new = w_new + (max_corner(1,1) - w1);
end
if max_corner(2,1) > h1
    h_new = h_new + (max_corner(2,1) - h1);
end

% initialize the new frame
new_frame = zeros(h_new,w_new);

translation_matrix = [1;0;0;1;shift_x;shift_y];
% shifted coordinate of fixed image in new frame
corner_points = [1,1;w1,1;w1,h1;1,h1];
new_coordinate = zeros(2,4);
for i = 1:4
    new_coordinate(:,i) = transform_coordinates(corner_points(i,1),corner_points(i,2),translation_matrix);
end

% obtain a rgb frame
image_size = size(image_1,3);
new_image = zeros(h_new,w_new,image_size);

% iterate for all three r,g,b values and constract a transformed rbg matrix finally
for z = 1:image_size
    new_image2 = transform_image(image_2(:,:,z),best_transform);

    [h2, w2] = size(new_image2);
    % iterate of all the pixels in the new frame and put the cooresponding
    % pixel values from their respective images
    for i = 1:h_new
        for j = 1:w_new
            if inpolygon(j,i,new_coordinate(1,:),new_coordinate(2,:)) && (i-shift_y <= h1 && j-shift_x <= w1)
                new_frame(i,j) = image_1(i-shift_y,j-shift_x,z);
            elseif (i < h2 && j < w2)
                new_frame(i,j) = new_image2(i,j);
            end
        end
    end
new_image(:,:,z) = new_frame(:,:,1); 
end
% concatinate the rgb matrix
if image_size > 1
    rgb_image = cat(3,new_image(:,:,1),new_image(:,:,2),new_image(:,:,3));
end
rgb_image = uint8(rgb_image);
figure,imshow(rgb_image);
end

