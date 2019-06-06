function[] = tracking (folder_name)

if strcmp(folder_name, 'pingpong') 
    %create path for saving images   
    save_path = 'pingpong_track';
    if exist(save_path) ==0
        
        mkdir(save_path);
    end
    
    imagefiles = dir([folder_name '/*.jpeg']);
    nfiles = length(imagefiles);
    img1 = [folder_name '/' imagefiles(1).name];
    [H, r, c] = harris_corner_detector(imread(img1), 3, 5 ,18, 3);
    
elseif strcmp(folder_name, 'person_toy')
    save_path =   'person_toy_track';
    if exist(save_path) ==0
        mkdir(save_path);
    end
    imagefiles = dir([folder_name '/*.jpg']);
    nfiles = length(imagefiles);
    img1 = [folder_name '/' imagefiles(1).name];
    [H, r, c] = harris_corner_detector(imread(img1), 3, 7 ,2, 3);
else
    disp('Enter the correct name pingpong or person_toy')
    return;
    
end




win_sze = 15;
w = floor(win_sze/2);

k =0;
for ll = 2: nfiles
    close all
    img1 = [folder_name '/' imagefiles(k+1).name];
    img2 = [folder_name '/' imagefiles(ll).name];
    [r, c]=lucas_kanade_track(img2, img1,r, c,k, save_path);
    k = k+1;
end
 
% creat video
outputVideo = VideoWriter([folder_name '.avi']);
outputVideo.FrameRate = 10;

imageNames = dir([save_path,'/*.jpg']);

open(outputVideo)
for ii = 0:length(imageNames)-1
    
   read_path = [save_path '/' int2str(ii) '.jpg'] ;
   
   img = imread(read_path);
   writeVideo(outputVideo,img)
end
close(outputVideo)
end
