function [net, info, expdir] = finetune_cnn(varargin)

%% Define options
run(fullfile(fileparts(mfilename('fullpath')), ...
  '..','matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;


opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

% 
opts.dataDir = 'data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;

opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;

if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

% opts.train.gpus = [1];


% 
% %% update model
% 
net = update_model();

%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB(opts) ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train,...
  'val', find(imdb.images.set == 2)) ;
% 'val', find(imdb.images.set == 2)
expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB(opts)
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};

%% TODO: Implement your loop here, to create the data structure described in the assignment
clss_labels = [1 2 3 4];
cls_lab = containers.Map(classes, clss_labels);

% create mapping for train and test
splits = {'train', 'test'};
set = [1,2];
mapObj = containers.Map(splits,set);

% get path
unpack_dir = fullfile(opts.dataDir, 'Caltech','ImageData');
data = cell(1, numel(classes)*numel(splits));
label = cell(1, numel(classes)*numel(splits));
sets = cell(1, numel(classes)*numel(splits));
% -----------------------------------------

for fd =1:numel(splits)
    for clss =1:numel(classes)
        
        fld_name = [classes{clss} '_' splits{fd}];
        full_path = fullfile(unpack_dir, fld_name);
        imagefiles = dir([full_path, '/*.jpg']);
        nfiles = length(imagefiles);
        temp_data = zeros(32,32,3,nfiles);
        temp_labels = zeros(1, nfiles);

        for i = 1: nfiles
           I = imread(fullfile(full_path,imagefiles(i).name));
           temp_data(:,:,:,i) = im2double(imresize(I,[32,32]));
           temp_labels(i) = clss;
        end
        data{4*(fd-1)+clss}  = temp_data;
        label{4*(fd-1)+clss} = temp_labels;
        sets{4*(fd-1)+clss}  = repmat(fd, size(temp_labels));
   end
end
sets = cat(2, sets{:});
data  = single(cat(4, data{:}));
label = single(cat(2, label{:}));

% %%
% % subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);
% 
imdb.images.data = data ;
imdb.images.labels = label ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'test'} ;
imdb.meta.classes = classes;
% 
perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
