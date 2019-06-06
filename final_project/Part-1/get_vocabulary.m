function[vocabulary,images_training] = get_vocabulary(data, class_length, examples_count,examples_type,descriptor_type,step)
% This method return the descriptors of the images
% data: image data
% class_length: number of elements in the class
% examples_per_class: number of examples per class to train or test
% examples_type: 'train' or 'test'
% descriptor_type: Type of SIFT descriptor for feature extraction
% step: step size for dense sampling
% 
% vocabulary: desciptors of the images
% images_training: stores the images for debugging purpuses

vocabulary = cell(1,class_length*examples_count);
% this is used for debugging purpose
images_training = [];%cell(1,class_length*examples_count);

for i = 1:class_length
    % read the correct data cell
    if strcmp(examples_type,'test')
        images = data{1,class_length + i};
    else
        images = data{1,i};
    end
    
    % visual vocabulary for a subset of training examples
    for j = 1:examples_count
        image = images{j};
        %image_ = image;
        %images_training{(i - 1)*examples_count + j} = uint8(image_);
        image = im2double(image);
        
        % convert of grayscale image
        I = single(rgb2gray(image));
        % SIFT descriptors
        [f,d] = vl_sift(I);
        
        switch descriptor_type
            case 'Dense'
                % Dense SIFT
                binSize = 5;
                [~,d] = vl_dsift(I,'step',step,'size',binSize);
            case 'RGB-k_'
                % RGB SIFT with key points sampling
                d = zeros(128,size(f,2),3);
                for k = 1:3
                    [~,d(:,:,k)] = vl_sift(single(image(:,:,k)),'Frames',f);
                end
            case 'RGB-d_'
                % RGB SIFT with dense sampling
                d = [];
                binSize = 5;
                for k = 1:3
                    [~,d_] = vl_dsift(single(image(:,:,k)),'step',step,'size',binSize);
                    d = [d;d_];
                end
            case 'rgb-k'
                % rgb SIFT with key points sampling
                image = rgb2normedrgb(image);
                d = zeros(128,size(f,2),3);
                for k = 1:3
                    [~,d(:,:,k)] = vl_sift(single(image(:,:,k)),'Frames',f);
                end
            case 'rgb-d'
                % rgb SIFT with dense sampling
                [~, d] = vl_phow(single(image),'step',step,'Color','rgb');
            case 'opponent-k'
                % opponent SIFT with key points sampling
                image = rgb2opponent(image);
                d = zeros(128,size(f,2),3);
                for k = 1:3
                    [~,d(:,:,k)] = vl_sift(single(image(:,:,k)),'Frames',f);
                end
            case 'opponent-d'
                % opponent SIFT with dense sampling
                [~, d] = vl_phow(single(image),'step',step,'Color','opponent');
        end
        
        % build vocabulary of descriptors
        vocabulary{(i - 1)*examples_count + j} = d;
    end
end
end

function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb

R = input_image(:,:,1);
G = input_image(:,:,2);
B = input_image(:,:,3);

sum_RGB = R + G + B;

r = R./sum_RGB;
g = G./sum_RGB;
b = B./sum_RGB;

output_image = cat(3,r,g,b);

end


function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space
R = input_image(:,:,1);
G = input_image(:,:,2);
B = input_image(:,:,3);

O_1 = (R - G)./sqrt(2);
O_2 = (R + G - 2*B)./sqrt(6);
O_3 = (R + G + B)./sqrt(3);

output_image = cat(3,O_1,O_2,O_3);

end