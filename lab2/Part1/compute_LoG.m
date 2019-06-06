function imOut = compute_LoG(image, LOG_type)
I = imread(image);
switch LOG_type
    case 1
        gaus = fspecial('gaussian',5, .5);
        I = filter2(gaus, I);
        laplace = fspecial('laplacian');
        imOut = filter2(laplace, I);
        %method 1
        
    case 2
        %method 2
        log = fspecial('log', 5, 0.5);
        imOut = filter2(log, I);

    case 3
        %method 3
        g1 = fspecial('gaussian',5, 1);
        g2 = fspecial('gaussian',5, 0.3); 
        DoG = g1-g2;
%         surf(DoG)
        imOut = filter2(DoG, I);
       

end
end

