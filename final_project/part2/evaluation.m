function[precision,recall,average_precision] = evaluation(im_list, predictions, test_labels)

list_length = length(im_list);
precision = zeros(list_length,1);
recall = zeros(list_length,1);
correct_labels = nnz(test_labels);

positive_counter = 0;
average_precision = 0;


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