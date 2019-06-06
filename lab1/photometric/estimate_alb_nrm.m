function [ albedo, normal ] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal


[h, w, stck] = size(image_stack)
if nargin == 2
    shadow_trick = true;
end
% image_stack = image_stack;
% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(h, w, 1);
normal = zeros(h, w, 3);
     G = zeros(h, w, 3);
     
shadow_trick
% =========================================================================
% YOUR CODE GOES HERE
% for each point in the image array
for y= 1 : h
    
    for x = 1 : w
        %stack image values into a vector i
        i = reshape(image_stack(y, x , :), [stck, 1]);
%         disp(size(i))
        %construct the diagonal matrix scriptI
        if shadow_trick
            scriptI = diag(i);
% %             disp(size(scriptI));
% %             disp(size(scriptV));
            %solve scriptI * scriptV * g = scriptI * i to obtain g for this point
            [G(y, x, :), R] = linsolve(scriptI * scriptV, scriptI * i);
        
        else
            
            %solve without shadow trick scriptV * g = i
            [G(y, x, :), R] = linsolve( scriptV, i); 
        end
            
        
        
        g = reshape(G(y, x, :), [3,1]);
       
        %albedo at this point is |g|
        albedo(y, x, 1) = norm(g); 
        %normal at this point is g / |g|
        if norm(g)==0
            normal(y, x, :) = 0;
        else
            normal(y, x, :) = G(y, x, :)./norm(g);
        end
        
    end


end

% =========================================================================

end

