function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
[m,n,~] = size(normals);
p = zeros(m, n , 1);
q = zeros(m, n, 1);
SE = zeros(m, n, 1);


% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where

N1 = normals(:, :, 1);
N2 = normals(:, :, 2);
N3 = normals(:, :, 3);
% p measures value of df / dx
p = N1 ./ N3;
% q measures value of df / dy
q = N2 ./ N3;

% ========================================================================



p(isnan(p)) = 0;
q(isnan(q)) = 0;



% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE
[~,dp_dy] = gradient(p);
[dq_dx,~] = gradient(q);


SE = (dp_dy - dq_dx).^2;
% ========================================================================




end
