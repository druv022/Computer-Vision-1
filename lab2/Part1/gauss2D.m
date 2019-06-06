function G = gauss2D( sigma , kernel_size )

    Gx = gauss1D(sigma, kernel_size);
    Gy = gauss1D(sigma, kernel_size);
    G = Gx'* Gy;
   
    %% solution
end
