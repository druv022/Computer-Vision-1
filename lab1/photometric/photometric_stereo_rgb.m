close all
% clear all
clc
 
disp('Part 1: Photometric Stereo 3 Channel')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = 'photometrics_images/SphereColor/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir, 3);
disp(size(image_stack))
disp(size(scriptV))
[h, w, c, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);


% 
% compute the surface gradient from the stack of imgs and light source mat
% disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm_rgb(image_stack, scriptV, true,'max');


%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);
% 
threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

% compute the surface height
height_map = construct_surface( p, q, 'column');
% 
% %% Display

show_results(albedo, normals, SE);
show_model(albedo, height_map);


% figure
% subplot(2,3,1), imshow(albedo(:,:,1)), title("Albedo R-channel")
% subplot(2,3,2), imshow(albedo(:,:,2)), title("Albedo G-channel")
% subplot(2,3,3), imshow(albedo(:,:,3)), title("Albedo b-channel")
% % 
% subplot(2,3,4), imshow(normals(:,:,:,1)), title("Normal R-channel")
% subplot(2,3,5), imshow(normals(:,:,:,2)), title("Normal G-channel")
% subplot(2,3,6), imshow(normals(:,:,:,3)), title("Normal B-channel")