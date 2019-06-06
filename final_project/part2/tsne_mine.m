%% Perform feture visualization	
[net, info, expdir] = finetune_cnn();

%% extract features and train svm

% TODO: Replace the name with the name of your fine-tuned model
nets.fine_tuned = load(fullfile(expdir, 'net-epoch-40.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-caltech.mat'));

%% replace loss with the classification as we will extract features
nets.pre_trained.layers{end}.type = 'softmax';
nets.fine_tuned.layers{end}.type = 'softmax';



features.finetune = get_feat_data(data, nets.fine_tuned);
features.pretrained = get_feat_data(data, nets.pre_trained);
mapped_data = tsne(features.finetune.features,'Algorithm','barneshut','NumPCAComponents',50);
mapped_data_pre = tsne(features.pretrained.features,'Algorithm','barneshut','NumPCAComponents',50);
%[mapped_data, mapping] = compute_mapping(features.finetune.features, 'tSNE');
gscatter(mapped_data(:,1), mapped_data(:,2), features.finetune.labels)
% gscatter(mapped_data_pre(:,1), mapped_data_pre(:,2), features.finetune.labels)
function [testset] = get_feat_data(data, net)

% trainset.labels = [];
% trainset.features = [];

testset.labels = [];
testset.features = [];
for i = 1:size(data.images.data, 4)
    
    res = vl_simplenn(net, data.images.data(:, :,:, i));
    feat = res(end-3).x; feat = squeeze(feat);
    
    if(data.images.set(i) == 1)
        testset.features = [testset.features feat];
        testset.labels   = [testset.labels;  data.images.labels(i)];
               
    end
    
end

% trainset.labels = double(trainset.labels);
% trainset.features = sparse(double(trainset.features'));

testset.labels   = double(testset.labels);
testset.features = double(testset.features');

end