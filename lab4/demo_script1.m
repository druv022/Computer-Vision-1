close all;
clear all;

% read images
image1 = imread('boat1.pgm');
image2 = imread('boat2.pgm');

% obtain matching points
[points1, points2] = keypoint_matching(image1, image2);

% display image side by side
figure(1), imshow([image1,image2]), title('Before Ransac');

width_image1 = size(image1,2);

% draw random 50 lines of matching points
perm = randperm(size(points1,2));
for j = 1:50
    i = perm(j);
    x = [points1(1,i) width_image1 + points2(1,i)];
    y = [points1(2,i) points2(2,i)];
    hold on;
    line(x,y,'Color','y','linewidth',2);
end

%transforming image 1 to image 2
best_transform = RANSAC(points1, points2, 100, 3);
h = best_transform;
H = [h(1) h(2) h(5); h(3) h(4) h(6); 0 0 1]';
tform = maketform('affine', H);
J = imtransform(image1, tform);
new_image1 = transform_image(image1,best_transform);
new_image1 = uint8(new_image1);

figure(2), imshow([image1,image2]), title('After Ransac');
new_coordinates = transform_coordinates(points1(1,:),points1(2,:),best_transform);

% show lines after RANSAC
for j = 1:50
    i = perm(j);
    x = [points1(1,i) width_image1 + new_coordinates(1,i)];
    y = [points1(2,i) new_coordinates(2,i)];
    hold on;
    line(x,y,'Color','y','linewidth',2);
end
figure(3)
subplot(2,2,1), imshow(new_image1), title('Transformed image1 using our implementation');
subplot(2,2,2), imshow(J), title('Tranformed image1 using imtransform');


%------- Image 2 to Image 1-------------------------
% transforming image 2 to image 1
best_transform = RANSAC(points2, points1, 100, 3);
new_image2 = transform_image(image2,best_transform);
new_image2 = uint8(new_image2);
h = best_transform;
H = [h(1) h(2) h(5); h(3) h(4) h(6); 0 0 1]';
tform = maketform('affine', H);
I = imtransform(image2, tform);
subplot(2,2,3), imshow(new_image2), title('Tranformed image2 using our implementation');
subplot(2,2,4), imshow(I), title('Tranformed image2 using imtransform');
