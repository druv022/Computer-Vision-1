function[im_histograms,images_training2] = get_histogram(vocabulary,vocabulary_size,class_length,C,subset_examples,examples_count,images_t)
% This methods returns the histogram of the visual words for all the images
% vocabulary: the descriptors of the images
% vocabulary_size: the size of the vocabulary 
% class_length: the number of classes
% C: the visual words after clustering
% subset_examples: The number of examples used for building visual words
% examples_counts: total number of examples; training or testing
% image_t: images stored for debugging purpuses
%
% im_histogram: the histogram of visual words of the images
% images_training2: stores the images for debugging purposes


im_histograms = zeros(class_length*(examples_count-subset_examples),vocabulary_size);
% used ofr debugging purpuses
images_training2 = [];%cell(1,class_length*(examples_count-subset_examples));

% assign the image desciptors to the closest visual word
for i = 1:class_length
    % update visual vocabulary for rest of the images to closest visual word
    for j = subset_examples + 1:examples_count
        y = double(vocabulary{(i - 1)*examples_count + j});
        % if color descriptors than concatinate the descriptors
        if size(y,3) > 1
            y = cat(1,y(:,:,1),y(:,:,2),y(:,:,3));
        end
        % get nearest vocabularu word of all the descriptors in an image
        nearest_idx = knnsearch(C,y'); 
        z = zeros(length(nearest_idx),128);
        
        % update the descriptor with closest visual word
        for k = 1:length(nearest_idx)
            z(k,:) = C(nearest_idx(k));
        end
        vocabulary{(i - 1)*examples_count + j} = z;

        % obtain the histogram of the visual words and store it
        [hgram,~] = histcounts(nearest_idx,vocabulary_size,'Normalization','count');
        im_histograms((i - 1)*(examples_count-subset_examples) + j - subset_examples,:)= hgram;
        % used for debugging purpuses
        %images_training2{(i - 1)*(examples_count-subset_examples) + j - subset_examples} = images_t{(i - 1)*examples_count + j};
    end

end
end