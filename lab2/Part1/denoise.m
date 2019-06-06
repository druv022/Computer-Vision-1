function [ imOut ] = denoise( image, kernel_type, varargin)

I = double(imread(image));

switch kernel_type
    case 'box'
        imOut = imboxfilt(I, varargin{1});
    case 'median'
        imOut = medfilt2(I,[varargin{1}, varargin{1}]);
    case 'gaussian'
%         varargin(1): sigma, varargin(2): kernel size
        K = gauss2D(varargin{1}, varargin{2});
        
        imOut = filter2(K, I);
        
end
end
