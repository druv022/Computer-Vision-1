function[] = fhtml(filename,test_examples,image_data,mAP,ap_list,vararg)

fid = fopen(filename,'w');
fprintf(fid, '<!DOCTYPE html>\n');
fprintf(fid, '<head><meta charset="utf-8"><title>Image list prediction</title><style type="text/css">img {width:200px;}</style></head>\n');
fprintf(fid, '<body>\n');

fprintf(fid, '<h2>Dhruba Pujary, Tarun Krishna</h2>\n');
fprintf(fid, '<h1>Settings</h1>\n');
fprintf(fid, '<table>');
fprintf(fid, ['<tr><th>SIFT step size</th><td>' vararg{1} 'px</td></tr>\n']);
fprintf(fid, ['<tr><th>SIFT block sizes</th><td>' vararg{2} ' pixels</td></tr>\n']);
fprintf(fid, ['<tr><th>SIFT method</th><td>' vararg{3} '-SIFT</td></tr>\n']);
fprintf(fid, ['<tr><th>Vocabulary size</th><td>' vararg{4} ' words</td></tr>\n']);
fprintf(fid, ['<tr><th>Vocabulary fraction</th><td>' vararg{5} '</td></tr>\n']);
fprintf(fid, ['<tr><th>SVM training data</th><td>' vararg{6} ' positive, ' vararg{7} ' negative per class</td></tr>\n']);
fprintf(fid, ['<tr><th>SVM kernel type</th><td>' vararg{8} '</td></tr>\n']);
fprintf(fid, ['</table>\n']);
fprintf(fid, ['<h1>Prediction lists (MAP: ' num2str(mAP) ')</h1>\n']);
%fprintf(fid, ['<h3><font color="red">Following are the ranking lists for the four categories. Please fill in your lists.</font></h3>\n']);
%fprintf(fid, ['<h3><font color="red">The length of each column should be 200 (containing all test images).</font></h3>\n']);
fprintf(fid, ['<table>\n']);
fprintf(fid, ['<thead>\n']);
fprintf(fid, ['<tr>\n']);
fprintf(fid, ['<th>Airplanes (AP: ' num2str(ap_list(1)) ')</th><th>Cars (AP:' num2str(ap_list(2)) ')</th><th>Faces (AP: ' num2str(ap_list(3)) ')</th><th>Motorbikes (AP: ' num2str(ap_list(4)) ')</th>\n']);
fprintf(fid, ['</tr>\n']);
fprintf(fid, ['</thead>\n']);
fprintf(fid, ['<tbody>\n']);

for i = 1:size(image_data,2)
    src1 = get_source((image_data(1,i)-1),test_examples);
    src2 = get_source((image_data(2,i)-1),test_examples);
    src3 = get_source((image_data(3,i)-1),test_examples);
    src4 = get_source((image_data(4,i)-1),test_examples);
    
    fprintf(fid, [strcat('<tr><td><img src="',src1, '" /></td><td><img src="', src2 ,'" /></td><td><img src="', src3 ,'" /></td><td><img src="', src4 ,'" /></td></tr>\n')]);
    
end
fprintf(fid, ['</tbody>\n']);
fprintf(fid, ['</table>\n']);

fprintf(fid, '</body>\n');
fprintf(fid, '</html>');
fclose(fid);
end

function[source] = get_source(index,examples)

var1 = floor(index/examples);

switch var1
    case 0
        source = "Caltech4/ImageData/airplanes_test/";
    case 1
        source = "Caltech4/ImageData/cars_test/";
    case 2
        source = "Caltech4/ImageData/faces_test/";
    case 3
        source = "Caltech4/ImageData/motorbikes_test/";
end

image_index = rem(index,examples)+1;
if image_index > 9
    image_name = strcat("img0",int2str(image_index),".jpg");
else
    image_name = strcat("img00",int2str(image_index),".jpg");
end

source = strcat(source,image_name);
end