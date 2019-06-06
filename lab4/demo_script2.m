close all
clear all

image1 = imread('left.jpg');
image2 = imread('right.jpg');

% right upon left
stitch(image1, image2);

% left upon right
% subjected to error of few pixels sometimes; run it again
stitch(image2, image1);