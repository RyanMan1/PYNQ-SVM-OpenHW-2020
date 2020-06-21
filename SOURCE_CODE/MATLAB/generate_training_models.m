function [svm_models] = generate_training_models(training_data, training_labels)
% GENERATE_TRAINING_MODELS returns the k SVM training model files
% for one-vs-all classification - uses LIBSVM
% (we need k training models for k classes for one-vs-all approach
% INPUTS %%%%
% training_data => mxn matrix of training data with m obsservations and n
% variables
% training_labels => labels corresponding to the class of each training
% vector
% OUTPUTS %%%%
% svm_models => cell array containing k training models from the svm

k = max(training_labels);                      % the value of k

training_labels_new = zeros(size(training_labels));     % we need new training labels as we're solving 2-class problems
% this will contain 1's and -1's

svm_models = cell(k,1);         % produce a cell array containing the k pairs of training models

for n1 = 1:1:k
    training_data_1_indices = (find(training_labels == n1))';   % positive class
    training_data_2_indices = (find(training_labels ~= n1))';   % all other classes - negative for one vs all
        
    training_labels_new(training_data_1_indices) = 1;           % +1 label for positive class
    training_labels_new(training_data_2_indices) = -1;          % -1 label for negative class
    
    % linear
%     svm_models{n1,1} = svmtrain(training_labels_new, training_data, '-t 0 -c 1'); %#ok<SVMTRAIN>
    % polynomial - defaults r = 0, d = 3
%     svm_models{n1,1} = svmtrain(training_labels_new, training_data, '-t 1 -g 0.004 -c 1 -r 0 -d 3'); %#ok<SVMTRAIN>
    % rbf - defaults g = 1/(no_features)
    svm_models{n1,1} = svmtrain(training_labels_new, training_data, '-t 2 -g 0.004 -c 1'); %#ok<SVMTRAIN>

end

end

