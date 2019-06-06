function[precision,recall,average_precision] = evaluation(im_list, predictions, test_labels)
% This function is used ot evaluate average precision, precision, recall
% im_list: indexes of ranked images in the training examples
% predictions: predicted labes
% test_labes: true labels
%
% precision: precision at every index of the list
% recall: recall at every index of the list
% average precision: average precision

list_length = length(im_list);
precision = zeros(list_length,1);
recall = zeros(list_length,1);
correct_labels = nnz(test_labels);

positive_counter = 0;
average_precision = 0;

% evaluate average precision
for i=1:list_length
    flag = false;
    if (predictions(i) == 1) && (predictions(i) == (test_labels(im_list(i))))
        positive_counter = positive_counter + 1;
        flag = true;
    end
    precision(i) = positive_counter/i;
    if positive_counter <= correct_labels
        recall(i) = positive_counter/correct_labels;
    else
        recall(i) = 1;
    end
    
    if flag
        average_precision = average_precision + precision(i);
    end
end

average_precision = average_precision/correct_labels;

end