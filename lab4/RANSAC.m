function[best_transform] = RANSAC(points1, points2, N, P)
%points1 : matching points of image 1
%points2 : matching points of image to w.r.t which the transformation will
%          be done, i.e. image 1 will tranform nearly to image 2
%N       : Number of iterations
%P       : number of points to be evaluated upon

best_transform = [];
best_inliers = 0; 

% iterate for N times
for i = 1:N
    perm = randperm(size(points1,2));
    A = zeros(2*P,6);
    b = zeros(2*P,1);
    
    % Obtain the A and b matrix for P points
    for j = 1:P
        index = perm(j);
        A(((2*j)-1),:) = [points1(1,index), points1(2,index), 0, 0, 1, 0];
        A((2*j),:) = [0, 0,points1(1,index), points1(2,index), 0, 1];
        
        b(((2*j)-1),1) = points2(1,index);
        b((2*j),1) = points2(2,index);
    end
    
    % evaluate x, trasformation matrix
    x = pinv(A)*b;
        
    temp_inliers = 0;
    
    % evaluate inliers for all the other points
    for j = P+1:length(perm)
        index = perm(j);
        
        A_(1,:) = [points1(1,index), points1(2,index), 0, 0, 1, 0];
        A_(2,:) = [0, 0,points1(1,index), points1(2,index), 0, 1];
        
        
        b_(1,1) = points2(1,index);
        b_(2,1) = points2(2,index);
        
        b_new = A_ * x;
              
        scr = (b_ - b_new).^2;
        sum_scr = sum(scr(:));
        
        if sum_scr <= 100
            temp_inliers = temp_inliers + 1;
        end
    end

    % update the best transform 
    if best_inliers < temp_inliers
        best_transform = x;
        best_inliers = temp_inliers;
    end
end
%disp(best_inliers);
end