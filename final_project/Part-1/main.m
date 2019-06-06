clear all;
close all;
% run('F:\software\Matlab-extra\vlfeat-0.9.21\toolbox\vl_setup.m');

% Settings
%--------------------------------------------------------------------------
filename = 'Test-SIFT-d-400.html';

% Classes in the dataset
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
labels = [1 2 3 4];
cls_lab = containers.Map(classes, labels);
class_length = length(classes);

% Data Splits required
splits = {'train','test'};
set = [1,2];
mapObj = containers.Map(splits, set);

% SIFT descriptors options: {'keypoints', 'Dense', 'RGB-k_','RGB-d_', 'rgb-k','rgb-d', 'opponent-k','opponent-d'};
descriptor_type = 'keypoints';

% specify 
if strcmp(descriptor_type, 'Dense') || strcmp(descriptor_type, 'RGB-d_') || strcmp(descriptor_type, 'rgb-d') || strcmp(descriptor_type, 'opponent-d')
    % set step size to : 7,8,10,15 etc
    step = 10;
    % Binsize Hardcoded inside function and not passed as parameter
    binsize = '5';
else
    step = '-';
    binsize = '-';
end

% set the number of training examples per class
training_examples = 400;
% Vocabulary fraction
ratio = 1/8;
% Examples used for building the vocabulary
subset_examples = round(training_examples * ratio);
% Number of examples to test from test set of each class
test_examples = 50;

% data and labels are dictionary
disp("Loading images...");
[data, labels] = load_images(classes, splits, training_examples, test_examples);

% values are 400, 800, 1600, 2000, 4000
vocabulary_size = 400;

% update with the index of the kernel you want to test
svm_kernel_types = {'linear','polynomial','rbf'};
svm_k_index = 1;
%--------------------------------------------------------------------------

% Get the visual vocabulary; images training is used for debugging
disp("Finding vocabulary words...")
[visual_vocabulary,images_training] = get_vocabulary(data, class_length, training_examples,'train',descriptor_type,step);
[test_vocab,images_testing] = get_vocabulary(data, class_length, test_examples,'test',descriptor_type,step);

X = [];
counter = 0;

% use subset of training examples and build the input for clustering
for i = 1:class_length
    for j = 1:subset_examples
        % if color image, the concatinate the descriptors
        y = visual_vocabulary{(i - 1)*training_examples + j};
        if size(y,3) > 1
            y = [y(:,:,1);y(:,:,2);y(:,:,3)];
        end
        X = [X;y'];
    end
end

disp("Clustering...")
% obtain the cluster centroids/code-words 
[~, C] = kmeans(double(X),vocabulary_size,'MaxIter',500,'Display','iter');

% examples per class for training svm
exm_per_class = training_examples - subset_examples;

% get the histogram of visual words
disp("Histogram of words...");
[im_histograms,images_training2] = get_histogram(visual_vocabulary,vocabulary_size,class_length,C,subset_examples,training_examples,images_training);
[test_im_hist,images_testing2] = get_histogram(test_vocab,vocabulary_size,class_length,C,0,test_examples,images_testing);

% initialize average precision lsit
ap_list = zeros(4,1);
% initialize image result list
image_result_list = zeros(4,class_length*test_examples);

% used for debugging purpuses
images_training3 = cell(1,class_length);
images_negative = cell(1,class_length);

% Training and testing
for i = 1:class_length
%     %used for debugging purpuses
%     images_training4 = cell(1,exm_per_class);
%     for m = 1:exm_per_class
%         images_training4{m} = images_training2{(i-1)*exm_per_class + m};
%     end
%     images_training3{i} = images_training4;
    
    % get the positive set of examples
    positive_exmpl = im_histograms((i-1)*exm_per_class + 1:(i)*exm_per_class,:);

    negative_exmpl = [];
%     images_n = cell(1,(class_length-1)*exm_per_class);
    
    % get the negative set of examples
    if (i-1)*exm_per_class > 1
        negative_exmpl = im_histograms(1:(i-1)*exm_per_class,:);
        
%         for m = 1:(i-1)*exm_per_class
%             images_n{m} = images_training2{m};
%         end        
    end
    if (i-1)*exm_per_class + exm_per_class < class_length*exm_per_class
        if isempty(negative_exmpl)
            negative_exmpl = im_histograms((i)*exm_per_class + 1: class_length*exm_per_class,:);
            
%             for m = (i)*exm_per_class + 1:class_length*exm_per_class
%                 images_n{m} = images_training2{m};
%             end
        else
            negative_exmpl = [negative_exmpl; im_histograms((i)*exm_per_class + 1: class_length*exm_per_class,:)];
            
%             for m = (i)*exm_per_class + 1:class_length*exm_per_class
%                 images_n{m} = images_training2{m};
%             end            
        end
    end
%     images_negative{i} = images_n;

    [hp,~] = size(positive_exmpl);
    [hn,~] = size(negative_exmpl);
    
    % store the positive examples followed by negative examples
    training_examples = [positive_exmpl;negative_exmpl];
    training_labels = zeros(hp + hn,1);
    
    % true labels
    training_labels(1:hp) = 1;
    
    % train the model
    disp(["Training model for class " i])
    model = fitcsvm(training_examples,training_labels,'KernelFunction',svm_kernel_types{svm_k_index},'Standardize',true,'BoxConstraint',200,'Verbose',1);
    
    % testing 
    test_set = test_im_hist(1:class_length*test_examples,:);
    test_labels = zeros(class_length*test_examples,1);
    test_labels((i-1)*test_examples+1:i*test_examples) = 1;
    
    [predict_label, scores] = predict(model, test_set);
    
    % obtain the ranked list of images
    im_index = 1:length(test_labels);
    index_map = containers.Map(scores(:,2)',im_index);
    prediction_map = containers.Map(scores(:,2),predict_label);
    im_list = fliplr(cell2mat(index_map.values));
    predictions = fliplr(cell2mat(prediction_map.values));
    image_result_list(i,:) = im_list(1,:);
    
    % evaluate average precision
    [precision, recall, average_precision] = evaluation(im_list, predictions, test_labels);
    ap_list(i) = average_precision;
    
end

% evaluate the map
mAP = sum(ap_list(:))/4;

% var_argument = [SIFT_step_size, SIFT_block_size, SIFT_method, Vocabulary_size,
%                 Vocabulary_fraction, SVM_trainint_data_positive,SVM_trainint_data_negative, SVM_Kernel_type]
vararg = {int2str(step),binsize,descriptor_type,int2str(vocabulary_size),num2str(ratio),int2str(exm_per_class),int2str((class_length-1)*exm_per_class),svm_kernel_types{svm_k_index}};

% generate the html file
fhtml(filename,test_examples,image_result_list,mAP,ap_list,vararg);
