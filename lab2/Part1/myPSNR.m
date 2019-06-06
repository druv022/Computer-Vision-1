function [ PSNR ] = myPSNR( orig_image, approx_image )

% I_orig = double(imread(orig_image));
% I_appr = double(imread(approx_image));
I_orig = double(orig_image);
I_appr = double(approx_image);
diff = I_orig - I_appr;
mse = sum(sum((diff.*diff)))/prod(size(I_orig));

I_max = max(max(I_orig));
ratio_ = log10(I_max/sqrt(mse));
PSNR = 20*ratio_;

end

