classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
labels = [1 2 3 4]
cls_lab = containers.Map(classes, labels);

% create mapping for train and test
splits = {'train', 'test'};
set = [1,2]
mapObj = containers.Map(splits,set);

% get path
unpack_dir = fullfile('data', 'Caltech','ImageData');

% --------------------------------------------

for fd =1:numel(splits)
    for clss =1:numel(classes)
 
        fld_name = [classes{clss} '_' splits{fd}];
        full_path = fullfile(unpack_dir, fld_name);
        imagefiles = dir([full_path, '/*.jpg']);
        n_files = length(imagefiles);
        %read images, resize it to 32x32          
        for i = 1: n_files
            I = imread(fullfile(full_path,imagefiles(i).name));
            if length(size(I))==2
                path = fullfile(full_path,imagefiles(i).name);
                delete(path);
            
            end
        end
        
    end
end