function [r,c] = lucas_kanade_track(img1, img2, r, c, cnt, path)

img1 = imread(img1);
img2 = imread(img2);
% [h, r, c] = harris_corner_detector(img2, 3, 5 ,7, 3);

win_sze = 15;
w = floor(win_sze/2);
if length(img1)==3
    im1 = double(rgb2gray(img1));
    im2 = double(rgb2gray(img2));
else
    im1 = double(img1);
    im2 = double(img2);
end

% filter out points at top and bottom tha tare in the corner
k =1;
R = []; C=[];
for m = 1:length(r)
    y = r(m);
    x = c(m);
    if x-w>=1 && y-w>=1 && x+w<=(size(im1, 2)-1) && y+w<=(size(im1, 1)-1)
        R(k)=r(m);
        C(k)=c(m);
        k = k+1;
    end
end


dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
dy = dx';

I_x = imfilter(im1, dx, 'circular');
I_y = imfilter(im1, dy, 'circular');
% I_t = conv2(im1, ones(2), 'valid') + conv2(im2, -ones(2), 'valid'); % partial on t
I_t = im1 - im2;

% subplot(1,2,1), imshow(I_x, []);
% subplot(1,2,2), imshow(I_y, []);

u = zeros(length(R), 1);
v = zeros(length(R), 1);
r = zeros(length(R), 1);
c = zeros(length(C), 1);

for p = 1:length(R)
    i = R(p);
    j = C(p);
    
    %calculate region around (i,j) with window_size=15 
    
    i_x = I_x(i-w:i+w, j-w:j+w);
    i_y = I_y(i-w:i+w, j-w:j+w);
    i_t = I_t(i-w:i+w, j-w:j+w);
    
    A = [i_x(:) i_y(:)];
    b = -i_t(:);
    
    %least squares        
    V = pinv(A)*b;
    
    u(p) = V(1);
    v(p) = V(2);
    
%     mag = sqrt(v(p)^2+u(p)^2);
%     ang = atan(v(p)/u(p));
    r(p) = R(p)+ round(10 * V(2,1));
    c(p) = C(p)+ round(10 * V(1,1));
 
    
end

h = figure;set(h,'Visible', 'off');

imshow(img1);
hold on;
quiver(C', R', u, v,'r')
j = [path '/' int2str(cnt), '.jpg'];
saveas(h,j)

end