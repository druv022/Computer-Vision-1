function [ albedo, normal ] = estimate_alb_nrm_rgb( image_stack, scriptV, combined, type_)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal


[h, w, c, stck] = size(image_stack);

% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
% create albedo for all ecah channel separatley

if combined
    Normal = zeros(h, w, 3);
    G = zeros(h, w, 3);
    albedo = zeros(h, w, 1);
    
else
    Normal = zeros(h, w, 3, 3);
    G = zeros(h, w, 3, c);
    albedo = zeros(h, w, c);
    combined=true;
    normal = zeros(h, w, 3);
    
    
end
 disp(combined)
% % =========================================================================
% % YOUR CODE GOES HERE
% % for each point in the image array
for y= 1 : h
    
    for x = 1 : w
        
        %stack image values into a vector i
        i_r = reshape(image_stack(y, x ,1, :), [stck, 1]);
        i_g = reshape(image_stack(y, x ,2, :), [stck, 1]);
        i_b = reshape(image_stack(y, x ,3, :), [stck, 1]);
        
        if combined
            %solve without shadow trick scriptV * g = i
            [G(y, x, :, 1), R] = linsolve( scriptV, i_r); 
            [G(y, x, :, 2), R] = linsolve( scriptV, i_g);
            [G(y, x, :, 3), R] = linsolve( scriptV, i_b);

            g_r = reshape(G(y, x, :, 1), [3,1]);
            g_g = reshape(G(y, x, :, 2), [3,1]);
            g_b = reshape(G(y, x, :, 3), [3,1]);

            %albedo at this point is |g|
            albedo(y, x, 1) = norm(g_r);
            albedo(y, x, 2) = norm(g_g);
            albedo(y, x, 3) = norm(g_b);
            %normal at this point is g / |g|
            if norm(g_r)==0
                Normal(y, x, :, 1) = 0;
            else
                Normal(y, x, :, 1) = G(y, x, :, 1)./norm(g_r);
            end
    %         -------------------
            if norm(g_g)==0
                Normal(y, x, :, 2) = 0;
            else
                Normal(y, x, :, 2) = G(y, x, :, 2)./norm(g_g);
            end
    %         -----------------------------
            if norm(g_b)==0
                Normal(y, x, :, 3) = 0;
            else
                Normal(y, x, :, 3) = G(y, x, :, 3)./norm(g_b);
            end
            
             if strcmp(type_, 'max')
               
               normal(y,x, 1) = max(max(Normal(y,x,1,1), Normal(y,x,1,2)),Normal(y,x,1,3));
               normal(y,x, 2) = max(max(Normal(y,x,2,1), Normal(y,x,2,2)),Normal(y,x,2,3));
               normal(y,x, 3) = max(max(Normal(y,x,3,1), Normal(y,x,3,2)),Normal(y,x,3,3));

             
             end
             if strcmp(type_,'average')
                 
               normal(y,x, 1) = (Normal(y,x,1,1) + Normal(y,x,1,2) + Normal(y,x,1,3))./3;
               normal(y,x, 2) = (Normal(y,x,2,1) + Normal(y,x,2,2) + Normal(y,x,2,3))./3;
               normal(y,x, 3) = (Normal(y,x,3,1) + Normal(y,x,3,2) + Normal(y,x,3,3))./3;
             
             end
       
        
               

        end
        
    end
end

% =========================================================================
% end

