clear all
close all

R = im2double(imread('ball_reflectance.png'));
S = im2double(imread('ball_shading.png'));

I = R .* S;

figure;
subplot(221);
imshow('ball.png');
subplot(222);
imshow(I);
subplot(223);
imshow(R);
subplot(224);
imshow(S);
