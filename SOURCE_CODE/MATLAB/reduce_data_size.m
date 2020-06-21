function [data_matrix_out,data_labels_out] = reduce_data_size(data_matrix,data_labels,reqd_size)
% REDUCE_DATA_SIZE Reduce size of dataset to reqd_size which is how many
% data points per class - takes the first "reqd_size" data points in the
% input data matrix
% INPUTS %%%%
% data_matrix/data_labels - dataset to reduce size of
% reqd_size - how many data points per class
% OUTPUTS %%%%
% data_matrix_out/data_labels_out - reduced data set

data_size = max(data_labels);

class_location = 1;   % where is the first point of current class

for n1 = 1:1:data_size
    class_size = length(find(data_labels == n1));  % how many data points in class
    end_location = class_location + class_size - 1;     % where is end of class
    
    output_class_location = (n1-1)*reqd_size + 1;       % as above but for output class
    output_class_end = output_class_location + reqd_size - 1;
    
    % populate the output data matrix and labels
    data_matrix_out(output_class_location:1:output_class_end,:) = data_matrix(class_location:1:(class_location+reqd_size-1),:);
    data_labels_out(output_class_location:1:output_class_end,1) = n1;
    
    class_location = end_location + 1;
end

end

