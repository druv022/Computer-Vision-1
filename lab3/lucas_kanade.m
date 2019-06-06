function [u,v, R, C] = lucas_kanade(img1, img2)

img1 = imread(img1);
img2 = imread(img2);


win_sze = 15;
if length(img1)==3
    im1 = double(rgb2gray(img1));
    im2 = double(rgb2gray(img2));
else
    im1 = double(img1);
    im2 = double(img2);
end


% im1 = padarray(im1, [mod(h,win_sze), mod(w, win_sze)],'replicate','post');
% im2 = padarray(im2, [mod(h,win_sze), mod(w, win_sze)],'replicate','post');

% figure(1)
% imshow(im1, [])
% figure(2)
% imshow(im2, [])

dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
dy = dx';

I_x = imfilter(im1, dx, 'circular');
I_y = imfilter(im1, dy, 'circular');
I_t = im1 - im2;


uv_len = floor(size(im1, 1)/win_sze);
% 
u = zeros(uv_len^2, 1);
v = zeros(uv_len^2, 1);
R = zeros(uv_len^2, 1);
C = zeros(uv_len^2, 1);
% 
% 
k =0;
for i = 1: uv_len
    q = 1+win_sze*(i-1);
    for j = 1: uv_len
        p = 1+win_sze*(j-1);

        %calculate region around (i,j) with window_size=15 
        i_x = I_x(q : q+win_sze -1, p : p+win_sze -1);
        i_y = I_y(q : q+win_sze -1, p : p+win_sze -1);
        i_t = I_t(q : q+win_sze -1, p : p+win_sze -1);

        %subplot(13, 13, 13*k+j), imshow(i_x,[])
        [h,w] = size(i_x);

        A = [i_x(:) i_y(:)];
        b = -i_t(:);

        %least squares        
        V = pinv(A)*b;
%         size(V)
        u(uv_len*k+j) = V(1,1);
        v(uv_len*k+j) = V(2,1);

        %central coordinate

        if j==1
            C(uv_len*k+j, 1) = floor(w/2);
        else
            C(uv_len*k+j, 1) = C(uv_len*k+j-1, 1) + 2*floor(w/2);

        end
        R(uv_len*k+j, 1) = floor(h/2) + win_sze*k;

  end
 k = k+1;
 
end

figure();
imshow(img2);
hold on;
quiver(C,R, u,v,1,'r')

end

