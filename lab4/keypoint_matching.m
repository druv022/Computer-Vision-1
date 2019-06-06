function[points1, points2] = keypoint_matching(image1, image2)
% Find the matching keypoints in two image
%image1  : first image
%image2  : second image
%points1 : coordinates of matching points in image 1, [x;y] format
%points2 : coordinates of matching points in image 2, [x;y] format

% convert to single and/or rgb
if length(size(image1)) > 2
    image1 = single(rgb2gray(image1));
else
    image1 = single(image1);
end
    
if length(size(image2)) > 2
    image2 = single(rgb2gray(image2));
else
    image2 = single(image2);
end

% obtain the feature descriptors
[f1, d1] = vl_sift(image1);
[f2, d2] = vl_sift(image2);

% obtain the matching index
[matches, ~] = vl_ubcmatch(d1, d2);

% count number of matches
matching_p_count = length(matches);

% initialize the coordinates of matching points 
points1 = zeros(2,matching_p_count);
points2 = zeros(2,matching_p_count);

% find the matching points 
for i = 1:matching_p_count
    points1(:,i) = round(f1(1:2,matches(1,i)));
    points2(:,i) = round(f2(1:2,matches(2,i)));
end

end