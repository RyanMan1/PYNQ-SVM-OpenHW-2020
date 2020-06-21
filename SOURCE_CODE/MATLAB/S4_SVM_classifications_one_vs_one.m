%% look into functional margin scaling with classification

%% get datasets in data matrix format for SVM
no_classes = 2;
training_dataset = training_all(1:no_classes,1);
testing_dataset = testing_all(1:no_classes,1);

[training_matrix_large, training_labels_large] = get_dataset(training_dataset);
[testing_matrix_large, testing_labels_large] = get_dataset(testing_dataset);
% LARGE DATASETS

%% reduce size of dataset

% for changing number of classes
no_vectors = floor(1000/no_classes);

[training_matrix, training_labels] = reduce_data_size(training_matrix_large, training_labels_large, no_vectors);
[testing_matrix, testing_labels] = reduce_data_size(testing_matrix_large, testing_labels_large, no_vectors);

% for changing number of variables
% no_variables = 2;
% training_matrix = training_matrix(:,1:1:no_variables);
% testing_matrix = testing_matrix(:,1:1:no_variables);

%% TESTING
training_matrix = training_matrix_old(:,10:1:13);
testing_matrix = testing_matrix_old(:,10:1:13);

%% smaller test dataset generate
training_matrix = [0.5,1;2,2;2.6,0.4;0.6,7;2,5;5,2.5;5,3;5,4;6,3];
% training_matrix = [0.5,1;2,2;2.6,0.4;0.6,7;2,5;5,2.5;5,3;5,4;6,3]/7;
training_labels = [1;1;1;2;2;3;3;3;3];

testing_matrix = [3,0;3,5;7,3;1,4;3.5,3];
% testing_matrix = [3,0;3,5;6.9,3;1,4;3.5,3]/7;
testing_labels = [1;2;3;2;3];

%% FOR REPORT GRAPHING PURPOSES
training_matrix = [2,1;3.5,0.5;3.5,1.5;3,2;5,1;1,3;1.5,4;2,3.5;4,4;4,2.1;3,0.5];
training_labels = [1;1;1;1;1;2;2;2;2;2;2];

% testing_matrix = [3,0;3,5;7,3;1,4;3.5,3];
% testing_matrix = [3,0;3,5;6.9,3;1,4;3.5,3]/7;
% testing_labels = [1;2;2;2;2];

%% get details for kernel and parameters
kernel_type = 0;
gamma = 0.5;
c = 1;
r = 0;
d = 3;

% for rbf
kernel_type = 2;
gamma = 0.5;

libsvm_training_argument_cell = strcat('-t ', {' '}, num2str(kernel_type),' -g', {' '}, num2str(gamma), ' -c', {' '}, num2str(c), ' -r', {' '}, num2str(r), ' -d', {' '}, num2str(d));
libsvm_training_argument = libsvm_training_argument_cell{1,1};

%% training and classify with LIBSVM
% test_svm_model = svmtrain(training_labels, training_matrix, '-t0 -g0.004 -c 1 -r 0 -d 3'); %#ok<SVMTRAIN>
test_svm_model = svmtrain(training_labels, training_matrix, libsvm_training_argument); %#ok<SVMTRAIN>

%%
t_start = tic;
[raw_predict_label, raw_accuracy, raw_dec_values] = svmpredict(testing_labels, testing_matrix, test_svm_model);
time_taken_libsvm = toc(t_start);

%% run LIBSVM to generate training models for pairs of classes
% svm_models = generate_training_models(training_matrix, training_labels);

% one-vs-one classification - returns k(k-1)/2 binary SVM training models
svm_models = generate_training_models_ovo(training_matrix, training_labels, libsvm_training_argument);

%% plot dataset and training results/testing vectors
figure(1);
hold on;

no_classes = 2;
colours = ["bd", "rd", "gd"];

hyperplane_parameters = cell(3,2);  % column 1 - weight vectors, column 2 - offsets

% plot the training data - blue diamonds for one class, red for other
for n1 = 1:1:no_classes*(no_classes-1)/2
    w = zeros(size(training_matrix, 2),1);
    support_vectors = full(svm_models{n1,1}.SVs);
    for n2 = 1:1:svm_models{n1,1}.totalSV
        w = w + svm_models{n1,1}.sv_coef(n2) * support_vectors(n2,:)';
    end
    b = -svm_models{n1,1}.rho;
    hyperplane_parameters{n1,1} = w;
    hyperplane_parameters{n1,2} = b;
%     for n2 = find(training_labels == n1)'
%         plot(training_matrix(n2,1), training_matrix(n2,2), colours(n1));
%     end
end

for n2 = find(training_labels == 1)'
    plot(training_matrix(n2,1), training_matrix(n2,2), colours(1));
end

for n2 = find(training_labels == 2)'
    plot(training_matrix(n2,1), training_matrix(n2,2), colours(2));
end

% plot the "hyperplanes" onto the training data
line_colours = ["b", "r", "g"];

for n1 = 1:1:no_classes*(no_classes-1)/2
    w = hyperplane_parameters{n1,1};
    b = hyperplane_parameters{n1,2};
    x_samples = 0:1:8;
    y_samples = -w(1)*x_samples / w(2) - b / w(2);
    plot(x_samples, y_samples, 'k');
end

% plot support vector lines... (4,2), (1,3)
x_samples = 0:1:8;
sv_1 = [2,1];
y_samples = -w(1)*x_samples / w(2) + w(1)/w(2)*sv_1(1) + sv_1(2);
plot(x_samples, y_samples, 'k--');

x_samples = 0:1:8;
sv_1 = [1,3];
y_samples = -w(1)*x_samples / w(2) + w(1)/w(2)*sv_1(1) + sv_1(2);
plot(x_samples, y_samples, 'k--');

title('SVM Training Results');
xlabel('Feature 1');
ylabel('Feature 2');

% title('SVM Training Results - One vs One');
% xlabel('Feature 1');
% ylabel('Feature 2');
% 
% colours_2 = ["bx", "rx", "gx"];
% 
% for n1 = 1:1:no_classes
%     for n2 = find(testing_labels == n1)'
%         plot(testing_matrix(n2,1), testing_matrix(n2,2), colours_2(n1));
%     end
% end

%% run my prediction - use geometric margins

tic();      % start timing

k = max(training_labels);       % k is the number of classes
no_models = nchoosek(k,2);      % this is the quantity of classifiers required for one-vs-one
no_variables = size(training_matrix,2);
% multi-class classification - kC2 = k(k-1)/2

testing_size = size(testing_matrix,1);
testing_predictions = zeros(testing_size,1);
% 1, 2 or 3

functional_margins = zeros(testing_size,no_models); % store kC2 functional margins for each testing point

% outer loop - check different binary SVM models - get functional margin
% value => f(xj) = SIGMA[alphai.yi.K(xi,xj)] + b
for n1 = 1:1:no_models
    % loop over every testing vector to obtain functional margin value
    no_support_vectors = svm_models{n1,1}.totalSV;  % number of support vectors
    offset = -svm_models{n1,1}.rho;
    
    % loop to get ||w|| %%%%%%%%%%%
    w = zeros(no_variables,1);
    sv_coeffs = svm_models{n1,1}.sv_coef;
    support_vectors = full(svm_models{n1,1}.SVs);
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
        
        functional_margins(n2,n1) = fm/norm_w + offset/norm_w;    % functional margin computed
%         functional_margins(n2,n1) = fm + offset;    % functional margin computed
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% altrernative method to determine test predictions from geometric values
% more parallel for testing vectors - less memory storage

testing_predictions = zeros(testing_size,1);    % actual class predictions

for n1 = 1:1:testing_size
    class_instances = zeros(1,k);   % count number of class instances => index indicates class
    
    % loop over classifiers
    current_classifier = 1;
    for n2 = 1:1:(k-1)
        for n3 = (n2+1):1:k
            % n2 is positive class, n3 is negative class
            if(functional_margins(n1,current_classifier) >= 0)
                class_instances(n2) = class_instances(n2) + 1;
            else
                class_instances(n3) = class_instances(n3) + 1;
            end
            current_classifier = current_classifier + 1;
        end
    end
    
    % check for maximum values in class_instances
    current_prediction = 1;
    current_max_instances = class_instances(1);
    for n2 = 2:1:k
        if(class_instances(n2) > current_max_instances)
            current_prediction = n2;
            current_max_instances = class_instances(n2);
        end
    end
    
    testing_predictions(n1) = current_prediction;
end

time_taken_my_impl = toc();

% accuracy of prediction:

error_count = 0;

for n1 = 1:1:testing_size
    if(testing_predictions(n1,1) ~= testing_labels(n1,1))
        error_count = error_count + 1;
    end
end

accuracy = 100 * (1 - error_count / testing_size);

%% old method
% do the predictions based on functional margins for different binary
% classifiers - ONE-VS-ONE approach

classifier_predictions = zeros(size(functional_margins));  % hold the predictions for each testing vector to eaach binary classifier
current_classifier = 0;     % keep track of which binary classifier we are looking at
testing_predictions = zeros(testing_size,1);    % actual class predictions

% loop over the pairs of classifiers - n1->n2 e.g. class 1 vs class 2,
% class 1 vs class 3 etc...
for n1 = 1:1:k
    for n2 = (n1+1):1:k
        current_classifier = current_classifier + 1;
        for n3 = 1:1:testing_size
            if(functional_margins(n3,current_classifier) >= 0)
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
