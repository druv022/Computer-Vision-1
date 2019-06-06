function G = gauss1D( sigma , kernel_size )

    x = -floor(kernel_size/2):floor(kernel_size/2);
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    ex = exp(-x.*x/(2 * sigma * sigma ));
    G = 1/(sqrt(2*pi)*sigma)*ex;
    G = G/sum(G);
    %% solution
end
