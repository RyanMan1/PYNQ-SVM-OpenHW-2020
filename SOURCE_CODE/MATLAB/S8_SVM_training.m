%% THIS SCRIPT DEMOSTRATES TRAINING AND DEPLOYING A LINEAR CLASSIFIER
%% 1 -  REDUCE NUMBER OF CLASSES IF REQUIRED
% change no_classes
no_classes_dataset = 3;
%%%%%%%%%%%%%%%%%%

training_dataset = cell(no_classes_dataset,1);

for n1 = 1:1:no_classes_dataset
    training_dataset{n1,1} = training_all{n1,1};
end

testing_dataset = cell(no_classes_dataset,1);

for n1 = 1:1:no_classes_dataset
    testing_dataset{n1,1} = testing_all{n1,1};
end

%% 2 - GET DATASETS IN DATA MATRIX FORMAT FOR SVM
[training_matrix_large, training_labels_large] = get_dataset(training_dataset);
[testing_matrix_large, testing_labels_large] = get_dataset(testing_dataset);
% LARGE DATASETS

%% 3 REDUCE SIZE OF DATASET

[training_matrix, training_labels] = reduce_data_size(training_matrix_large, training_labels_large, 50);
[testing_matrix, testing_labels] = reduce_data_size(testing_matrix_large, testing_labels_large, 50);

% remove noise
% training_matrix = training_matrix(:,13:1:end-5);
% testing_matrix = testing_matrix(:,13:1:end-5);

%% 4 - REDUCE VARIABLES IF REQUIRED
req_variables = 150;
training_matrix = training_matrix(:,1:1:req_variables);
testing_matrix = testing_matrix(:,1:1:req_variables);

%% 5 - PCA, IF REQUIRED
[COEFF, training_matrix] = pca(training_matrix);
training_matrix = training_matrix(:,1:1:3);

[COEFF, testing_matrix] = pca(testing_matrix);
testing_matrix = testing_matrix(:,1:1:3);

max_train = max(training_matrix,[],'all');
max_test = max(testing_matrix,[],'all');
max_both = max([max_train, max_test]);

if max_both > 1
    training_matrix = training_matrix / max_both;
    testing_matrix = testing_matrix / max_both;
end

%% ADD NOISE TO TESTING MATRIX IF REQUIRED

for n1 = 1:1:150
    testing_matrix(n1,1) = testing_matrix(n1,1) + 1.3*(rand(1)-0.5);
end

%% practice dataset

training_matrix = [0.5,1;2,2;2.6,0.4;0.6,7;2,5;5,2.5;5,3;5,4;6,3];
training_labels = [1;1;1;2;2;3;3;3;3];

% training_matrix = training_matrix(1:5,:);
% training_labels = training_labels(1:5,1);

%% 6 - TRAIN AND DEPLOY WITH LIBSVM

% libsvm training here... (kernel type = 2 for RBF - do not use for training)
kernel_type = 0;
gamma = 0.5;
c = 1;
r = 0;
d = 3;

training_argument_cell = strcat('-t ', {' '}, num2str(kernel_type),' -g', {' '}, num2str(gamma), ' -c', {' '}, num2str(c), ' -r', {' '}, num2str(r), ' -d', {' '}, num2str(d));
training_argument = training_argument_cell{1,1};

% svm_model_actual = svmtrain(training_labels, training_matrix, training_argument); %#ok<SVMTRAIN>

svm_models_actual = generate_training_models_ovo(training_matrix, training_labels, training_argument);

% test with LIBSVM
t_start = tic;
test_svm_model = svmtrain(training_labels, training_matrix, training_argument); %#ok<SVMTRAIN>
LATENCY_libsvm = toc(t_start);

[raw_predict_label, raw_accuracy, raw_dec_values] = svmpredict(testing_labels, testing_matrix, test_svm_model);

%% 7 - TRAIN WITH MY SMO IMPLEMENTATION USING "TRAIN_OVO_SMO" FUNCTION
% sequential minimal optimisation (SMO)
% ref: http://fourier.eng.hmc.edu/e176/lectures/ch9/node8.html
% LINEAR SVM INITIALLY

% training_labels = [1;1;1;-1;-1];

% generate the training models for k(k-1)/2 classifiers based on one-vs-one
% approach

kernel_parameters = [kernel_type, r, d, gamma];
C = 1;

t_start = tic;
training_models = train_ovo_SMO(training_matrix, training_labels, C, kernel_parameters);
LATENCY_me = toc(t_start);

%% 8 - TEST DEPLOYING THIS TRAINING MODEL
k = max(training_labels);       % k is the number of classes
no_models = nchoosek(k,2);      % this is the quantity of classifiers required for one-vs-one
no_variables = size(training_matrix,2);
% multi-class classification - kC2 = k(k-1)/2

testing_size = size(testing_matrix,1);
testing_predictions = zeros(testing_size,1);
% 1, 2 or 3

geometric_values = zeros(testing_size,no_models); % store kC2 geometric values for each testing point

% outer loop - check different binary SVM models - get functional margin
% value => f(xj) = SIGMA[alphai.yi.K(xi,xj)] + b
for n1 = 1:1:no_models
    % loop over every testing vector to obtain functional margin value
    no_support_vectors = training_models{n1,1}.no_svs;  % number of support vectors
    offset = training_models{n1,1}.offset;
    
    % loop to get ||w|| %%%%%%%%%%%
    w = zeros(no_variables,1);
    sv_coeffs = training_models{n1,1}.sv_coeffs;
    % get support vectors using training model indices:
    sv_indices = training_models{n1,1}.sv_indices;
    support_vectors = training_matrix(sv_indices,:);
    for n2_1 = 1:1:no_support_vectors
        sv_coeff = sv_coeffs(n2_1);
        sv = support_vectors(n2_1,:)';
        w = w + sv_coeff * sv;
    end
    norm_w = norm(w);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    for n2 = 1:1:testing_size
        % loop over all support vectors to do summation - this will need to be
        % synthesised as full training set on hw - may not use all iterations
        % though
        testing_vector = testing_matrix(n2,:);
        fm = 0;

        for n3 = 1:1:no_support_vectors
%             sv_coeff = svm_models{n1,1}.sv_coef(n3);    % alphai.yi
            sv_coeff = sv_coeffs(n3);
%             sv = training_matrix(svm_models{n1,1}.sv_indices(n3),:);  % corresponding support vector
            sv = support_vectors(n3,:);
            % fm = fm + sv_coeff * kernel_functions(sv, testing_vector, "linear", 0, 3, 0.004);
            fm = fm + sv_coeff * kernel_functions(sv, testing_vector, kernel_type, r, d, gamma);
        end
        geometric_values(n2,n1) = fm/norm_w + offset/norm_w;    % functional margin computed
%         functional_margins(n2,n1) = fm + offset;    % functional margin computed
    end
end

% do the predictions based on functional margins for different binary
% classifiers - ONE-VS-ONE approach

classifier_predictions = zeros(size(geometric_values));  % hold the predictions for each testing vector to eaach binary classifier
current_classifier = 0;     % keep track of which binary classifier we are looking at
testing_predictions = zeros(testing_size,1);    % actual class predictions

% loop over the pairs of classifiers - n1->n2 e.g. class 1 vs class 2,
% class 1 vs class 3 etc...
for n1 = 1:1:k
    for n2 = (n1+1):1:k
        current_classifier = current_classifier + 1;
        for n3 = 1:1:testing_size
            if(geometric_values(n3,current_classifier) >= 0)
                classifier_predictions(n3,current_classifier) = n1;
            else
                classifier_predictions(n3,current_classifier) = n2;
            end            
        end
    end
end

% count how many times each class appears positive for each testing vector
% - the one with the most number of predictions will be the chosen class
% for that testing vector
classifier_instances = zeros(testing_size, k);
% keeps track of how many instances there are of each class

for n1 = 1:1:testing_size
    for n2 = 1:1:k
        for n3 = 1:1:no_models
            if(classifier_predictions(n1,n3) == n2)
                classifier_instances(n1,n2) = classifier_instances(n1,n2) + 1;              
            end
        end
    end
    testing_predictions(n1,1) = 1; % keep track of what classifier (class)has been chosen
    % for the testing vector - iterate through classifier_instances to choose
    % starts at 1 but if a testing vector has more than one class, it is
    % allocated to the class with the last index e.g. if a testing vector
    % is thought to belong to class 1 and class 3, it will be allocated to
    % class 3
    max_no_classifications = classifier_instances(n1,1);    % by default set to number of times vector was classified as class 1
    for n2 = 2:1:k
        if((classifier_instances(n1,n2) > classifier_instances(n1,n2-1)) && (classifier_instances(n1,n2) > max_no_classifications))
            testing_predictions(n1,1) = n2;
        end
    end
end

%% 9 - ACCURACY PREDICTION

error_count = 0;

for n1 = 1:1:testing_size
    if(testing_predictions(n1,1) ~= testing_labels(n1,1))
        error_count = error_count + 1;
    end
end

accuracy = 100 * (1 - error_count / testing_size);