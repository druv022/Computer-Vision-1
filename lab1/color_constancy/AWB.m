
im = imread('awb.jpg');

dim = size(im,3);

for i=1:dim
    scal = sum(sum(im(:,:,i)))/numel(im(:,:,i));
    output(:,:,i) = im(:,:,i) .* (128/scal);
end
figure, imshow(output), title('color constant');