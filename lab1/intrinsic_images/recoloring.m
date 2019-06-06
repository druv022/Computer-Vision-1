clear all
close all

R = im2double(imread('ball_reflectance.png'));
S = im2double(imread('ball_shading.png'));

% Original image
O = imread('ball.png');
% Reconstructed Image
I = R .* S;

% changing reflectance color to green
R_green = zeros(size(R));
R_green(:,:,2) = R(:,:,2);

% changing reflectance color to magenta
R_magenta = zeros(size(R));
R_magenta(:,:,1) = R(:,:,1);
R_magenta(:,:,3) = R(:,:,3);

% Reconstructing the images
I_green = R_green .* S;
I_magenta = R_magenta .* S;


figure,imshow(I), title("Original");
figure,imshow(I_green), title("Recoloured Green");
figure,imshow(I_magenta), title('Recoloured Magenta')
