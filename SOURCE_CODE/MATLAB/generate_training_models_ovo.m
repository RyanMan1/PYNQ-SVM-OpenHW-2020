function [svm_models] = generate_training_models_ovo(training_data, training_labels, training_argument)
% GENERATE_TRAINING_MODELS_OVO returns the kC2 SVM training model files
% for one-vs-onse classification - uses LIBSVM
% (we need kC2 or k(k-1)/2 training models for k classes for one-vs-one approach
% INPUTS %%%%
% training_data => mxn matrix of training data with m obsservations and n
% variables
% training_labels => labels corresponding to the class of each training
% vector
% training argument => string for optional SVMTRAIN arguments
% OUTPUTS %%%%
% svm_models => cell array containing k training models from the svm

k = max(training_labels);                      % the value of k
no_models = nchoosek(k,2);

no_variables = size(training_data,2);

svm_models = cell(no_models,1);         % produce a cell array containing the k pairs of training models
% this is structured to contain training models for 
% 1-2, 1-3, 1-4 ..., 1-k
% 2-3, 2-4, ..., 2-k
% 3-4, ..., 3-k
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
        training_data_new(1:1:length_class_1,:) = training_data(training_data_1_indices,:);
        training_data_new(length_class_1+1:1:(length_class_1+length_class_2),:) = training_data(training_data_2_indices,:);
        
        % same as above with new labels for the binary classifier
        training_labels_new = zeros((length_class_1 + length_class_2),1);
        training_labels_new(1:1:length_class_1,1) = 1;           % +1 label for positive class
        training_labels_new(length_class_1+1:1:(length_class_1+length_class_2),1) = -1;          % -1 label for negative class
        
        training_model_counter = training_model_counter + 1;
        
        svm_models{training_model_counter,1} = svmtrain(training_labels_new, training_data_new, training_argument); %#ok<SVMTRAIN>
        % linear
        % svm_models{training_model_counter,1} = svmtrain(training_labels_new, training_data_new, '-t 0 -c 1'); %#ok<SVMTRAIN>
        % polynomial - defaults r = 0, d = 3
        % svm_models{training_model_counter,1} = svmtrain(training_labels_new, training_data_new, '-t 1 -g 0.004 -c 1 -r 0 -d 3'); %#ok<SVMTRAIN>
        % rbf - defaults g = 1/(no_features)
        % svm_models{training_model_counter,1} = svmtrain(training_labels_new, training_data_new, '-t 2 -g 0.004 -c 1'); %#ok<SVMTRAIN>
    end

end

end
