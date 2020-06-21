function training_models = train_ovo_SMO(training_matrix, training_labels, C, kernel_parameters)
% TRAIN_OVO_SMO returns the k(k-1)/2 training models for one-vs-one
% classification - the training dataset is split into two classes at a time
% and SMO is used to compute the training model which consists of the sv
% coefficients (alpha_i * y_i), corresponding indices, offset and number of
% support vectors

% INPUTS %%%%
% training matrix - rows, observations or pixels - columns, variables or
% wavelengths
% training_labels - corresponding labels - label 1, 2, 3...
% C - this depends on dataset - usually select 1 - dont select zero...
% kernel_parameters - 4x1 array, with the following entries:
% enrty 1: 0, 1 or 2 - 0 linear, 1 polynomial, 2 radial basis function
% (rbf)
% entry 2: r - for polyomial
% entry 3: d - for polynomial
% enrty 4: gamma - for polynomial/rbf

% OUTPUTS %%%%
% cell array containing k(k-1)/2 training models from the svm

k = max(training_labels);                      % the value of k
no_models = nchoosek(k,2);

no_variables = size(training_matrix, 2);

training_models = cell(no_models,1);         % produce a cell array containing the k pairs of training models
% this is structured to contain training models for 
% 1->2, 1->3, 1->4 ..., 1->k
% 2->3, 2->4, ..., 2->k
% 3->4, ..., 3->k
% in that order

training_model_counter = 0;     % keeps track of which classifier I am currently training

for n1 = 1:1:k
    for n2 = (n1+1):1:k
        training_data_1_indices = (find(training_labels == n1))';   % positive class 
        training_data_2_indices = (find(training_labels == n2))';   % the other classes - negative
        
        length_class_1 = length(training_data_1_indices);
        length_class_2 = length(training_data_2_indices);
        
        % populate the new smaller dataset
        training_data_new = zeros((length_class_1 + length_class_2),no_variables);
        training_data_new(1:1:length_class_1,:) = training_matrix(training_data_1_indices,:);
        training_data_new(length_class_1+1:1:(length_class_1+length_class_2),:) = training_matrix(training_data_2_indices,:);
        
        % same as above with new labels for the binary classifier
        training_labels_new = zeros((length_class_1 + length_class_2),1);
        training_labels_new(1:1:length_class_1,1) = 1;           % +1 label for positive class
        training_labels_new(length_class_1+1:1:(length_class_1+length_class_2),1) = -1;          % -1 label for negative class
        
        training_model_counter = training_model_counter + 1;
                
        % linear:
        training_models{training_model_counter,1} = SMO_binary_linear(training_data_new, training_labels_new, C);
        
        % need to convert sv indices to be wrt to whole dataset rather than
        % small binary dataset
        sv_indices_old = training_models{training_model_counter,1}.sv_indices;
        
        first_classifier_indices = find(sv_indices_old <= length_class_1);
        second_classifier_indices = find(sv_indices_old > length_class_1);
        
        sv_indices_new = zeros(size(sv_indices_old));
        
        % these lines get the actual indices corresponding to the support
        % vectors identified from the binary training
        sv_indices_new(first_classifier_indices) = sv_indices_old(first_classifier_indices) + training_data_1_indices(1) - 1;
        sv_indices_new(second_classifier_indices) = sv_indices_old(second_classifier_indices) - length_class_1 + training_data_2_indices(1) - 1;
        
        training_models{training_model_counter,1}.sv_indices = sv_indices_new;
    end
end

end

