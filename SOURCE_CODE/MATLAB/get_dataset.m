function [data_matrix, data_labels] = get_dataset(dataset)
% GET_DATASET Returns a data matrix and labels for use with SVM training
% rows are observations and columns are variables
% INPUTS %%%%
% dataset - cell array with 1 column and each row is a hyperspectral image
% formatted as I've described in logbook
% OUTPUTS %%%%
% data_matrix and data_labels - as described above
% this function may be used to obtain training and testing data

no_classes = length(dataset);       % number of images in dataset

no_obsv = zeros(no_classes,1);      % size of dataset for each set of observations
dataset_size = 0;                  % total number of observations in training set

% get dataset size and labels
for n1 = 1:1:no_classes
    non_zero_indices = find(dataset{n1,1}(:,:,100) ~= 0);
    no_obsv(n1,1) = length(non_zero_indices);
    dataset_size = dataset_size + no_obsv(n1,1);
end

data_matrix = zeros(dataset_size,256);
data_labels = zeros(dataset_size,1);

current_index = 0;      % keep track of where we are in dataset for filling data matrix

% outer loop - how many bacterias in the dataset - only want 3
% only look at the first well - column 1
for n1 = 1:1:no_classes
    % loop over non-zero pixels and get spectral signature (wavelengths) for each
    % this forms the dataset - rows are pixels (observations) and columns are wavelengths
    % (variables)
    non_zero_indices = find(dataset{n1,1}(:,:,100) ~= 0);     % get non-zero indices - the 1 in column index - looking at just 1 well
    % put in a 2 for column (well 2) etc...
    data_length = length(non_zero_indices);             % number of observations (non zeros)
    [row_indices,col_indices] = ind2sub(size(dataset{n1,1}(:,:,100)), non_zero_indices);  % subscripts corresponding to linear indices
    current_data_set = zeros(data_length, 256);         % dataset for this class will have this length - number of non-zero pixels
    for n2 = 1:1:data_length
        p = row_indices(n2);
        q = col_indices(n2);
        current_data_set(n2,:) = dataset{n1,1}(p,q,:);
    end
    if(n1 == 1)
        current_index = 1;  % start of where to populate data matrix
        data_matrix(current_index:1:no_obsv(n1,1),:) = current_data_set;
        data_labels(current_index:1:no_obsv(n1,1),1) = n1;
    else
        current_index = current_index + no_obsv(n1-1,1);
        data_matrix(current_index:1:(current_index+no_obsv(n1,1)-1),:) = current_data_set;
        data_labels(current_index:1:(current_index+no_obsv(n1,1)-1),1) = n1;
    end
end

end

