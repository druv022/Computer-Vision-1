function visualize(input_image, colorspace)
if strcmp(colorspace, 'opponent')
    
    O1 = input_image(:,:,1);
    O2 = input_image(:,:,2);
    O3 = input_image(:,:,3);
    subplot(2, 2, 1), imshow(input_image), title('Opponent Image')
    subplot(2, 2, 2), imshow(O1), title('O1 channel')
    subplot(2, 2, 3), imshow(O2), title('O2 channel')
    subplot(2, 2, 4), imshow(O3), title('O3 channel')

elseif strcmp(colorspace, 'rgb')  
    
    r = input_image(:, : , 1);
    g = input_image(:, : , 2);
    b = input_image(:, : , 3);
    subplot(2, 2, 1), imshow(input_image), title('rgb Normalized Image')
    subplot(2, 2, 2), imshow(r), title('r channel')
    subplot(2, 2, 3), imshow(g), title('g channel')
    subplot(2, 2, 4), imshow(b), title('b channel')

elseif strcmp(colorspace, 'hsv') 
    
    h = input_image(:,:,1);
    s = input_image(:,:,2);
    v = input_image(:,:,3);
    subplot(2, 2, 1), imshow(input_image), title('HSV Image')
    subplot(2, 2, 2), imshow(h), title('h channel')
    subplot(2, 2, 3), imshow(s), title('s channel')
    subplot(2, 2, 4), imshow(v), title('v channel') 
   
elseif strcmp(colorspace, 'ycbcr')
    
    y = input_image(:, :, 1);
    cb = input_image(:, :, 2);
    cr = input_image(:, :, 3);
    subplot(2, 2, 1), imshow(input_image), title('YCbCr Image')
    subplot(2, 2, 2), imshow(y), title('Y channel')
    subplot(2, 2, 3), imshow(cb), title('Cb channel')
    subplot(2, 2, 4), imshow(cr), title('Cr channel') 
   
    
else strcmp(colorspace, 'gray')
    
    rgb2L = input_image(:, :, 1);
    rgb2avg = input_image(:, :, 2);
    rgb2lum = input_image(:, :, 3);
    rgb2Mat = input_image(:, :, 4);
    subplot(2, 2, 1), imshow(rgb2L), title('Lightness based')
    subplot(2, 2, 2), imshow(rgb2avg), title('Average based')
    subplot(2, 2, 3), imshow(rgb2lum), title('Luminosity based')
    subplot(2, 2, 4), imshow(rgb2Mat), title('Matlab in-built') 
    

end 
    
    
end


 