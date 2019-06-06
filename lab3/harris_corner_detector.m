function[H, r, c] = harris_corner_detector(image,sigma,window_size,threshold,neighbor)
% image       : colored image in uint8 format
% sigma       : standard deviation of the gaussian kernel
% window_size : window size of gaussian kernel
% threshold:    value of R above which a point is classified as corner
% neighbor    : distance from current pixel to which max comparision is
%               performed
% 
% best value (image, 3, 7, 2, 3) for toy
% best value (image, 3, 5, 18, 3) for pingpong

% convert to gray scale
if length(size(image)) > 2
    image = double(rgb2gray(image));
else
    image = double(image);
end
[h,w] = size(image);

% first order derivative of gaussian
gaussian_filter = fspecial('gaussian',window_size,sigma);
[gx, gy] = gradient(gaussian_filter);

% smoothed derivative of image in x-direction
Ix = imfilter(image, gx,'symmetric','conv');
% smoothed derivative of image in y-direction
Iy = imfilter(image, gy,'symmetric','conv');

% evaluate A, B, C and further smoothing with gaussian filter
A = Ix.^2;
A = imfilter(A, gaussian_filter,'symmetric','conv');
C = Iy.^2;
C = imfilter(C, gaussian_filter,'symmetric','conv');
B = Ix .* Iy;
B = imfilter(B, gaussian_filter,'symmetric','conv');

H = zeros([h,w]);

for i = 1:h
    for j = 1:w
        Q = [A(i,j) B(i,j); B(i,j) C(i,j)];
        H(i,j) = det(Q) - (0.06 * (trace(Q))^2);
    end
end

max_neighbor = 2 * neighbor + 1;
H_max = ordfilt2(H, max_neighbor^2, ones(max_neighbor));
H = (H == H_max) & (H >threshold);
[r, c] = find(H);


% figure(1)
% imshow(H)

subplot(1,3,1), imshow(Ix,[]), title('x-derivative');
subplot(1,3,2), imshow(Iy,[]), title('y-derivative');
subplot(1,3,3), imagesc(image), axis image, colormap(gray), hold on
plot(c,r,'r*'), title('corners detected');
end


