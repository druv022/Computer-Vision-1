function[data, label] = load_images(classes, splits, training_examples, test_examples)
% This methods loads the images and labels
% classes: List of classes in the data; related to name of the folders
% splits: Splits required in the data; related to name of the folders
% training_examples: number of training examples to load per class
% test_examples: NUmber of test examples to load per class
%
% data: images data
% Label: data label

% Dataset directory
data_directory = '.\Caltech4\ImageData';
data = cell(1, numel(classes)*numel(splits));
label = cell(1, numel(splits)*numel(splits));

classes_length = length(classes);

% read data and labels, and store it in dictionary
for fd = 1:numel(splits)
    % set the number of examples to read based on training or test data
    if fd == 1
        examples = training_examples;
    else
        examples = test_examples;
    end
    
    for clss = 1:numel(classes)
        fld_name = [classes{clss} '_' splits{fd}];
        full_path = fullfile(data_directory, fld_name);
        imagefiles = dir([full_path,'/*.jpg']);
        nfiles = length(imagefiles);
        
        % read only the number of required examples
        if nfiles > examples
            nfiles = examples;
        end

        temp_data = cell(1,nfiles);
        temp_labels = zeros(nfiles,1);
        
        % read the image 
        for i = 1:nfiles
            I = imread(fullfile(full_path,imagefiles(i).name));
            
            % convert a gray scale image to RGB
            if size(I,3) < 2
                I = cat(3, I, I, I);
            end
            
            temp_data{i} = I;
            temp_labels(i,:) = clss;
        end
        
        % store it in dictionary
        data{(fd - 1)*classes_length + clss} = temp_data;
        label{(fd - 1)*classes_length + clss} = temp_labels;
    end
    
end
end