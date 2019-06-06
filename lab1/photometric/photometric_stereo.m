close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = 'photometrics_images/MonkeyGray/';   % TODO: get the path of the script
image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
disp(size(image_stack))
disp(size(scriptV))
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
% 
% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true);
% subplot(1,2,1), imshow(albedo), title('Albedo');
% subplot(1,2,2), imshow(normals), title('Normal Map');
% imwrite(albedo,'albdeo25_without.jpg')
% imwrite(normals,'normals25_without.jpg')
% x = 1: size(albedo, 1);
% y = 1: size(albedo, 2);
% [X,Y] = meshgrid(x,y);
% plot3(X,Y,albedo);



% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));
% 
% compute the surface height 
height_map = construct_surface( p, q,'average');%give parameter for each column, row or average
% 
% %% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map);


% % Face
% [image_stack, scriptV] = load_face_images('photometrics_images/yaleB02/');
% [h, w, n] = size(image_stack);
% fprintf('Finish loading %d images.\n\n', n);
% disp('Computing surface albedo and normal map...')
% [albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);
% 
% %% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
% disp('Integrability checking')
% [p, q, SE] = check_integrability(normals);
% 
% threshold = 0.005;
% SE(SE <= threshold) = NaN; % for good visualization
% fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));
% 
% %% compute the surface height!!!!! give parameter column or row or average
% 
% height_map = construct_surface( p, q, 'column');
% 
% show_results(albedo, normals, SE);
% show_model(albedo, height_map);

