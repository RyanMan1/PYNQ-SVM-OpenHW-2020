%% write a separate file for each classifier
% ---------------------------
% please specify fixed point bit widths (total and integer - fractional
% implied) from the IP core - see documentation
% for support vectors and testing vectors:
data_width = 16;
data_integer = 1;
data_fractional = data_width - data_integer;

coeffs_width = 32;
coeffs_integer = 12;
coeffs_fractional = coeffs_width - coeffs_integer;

gv_width = 32;
gv_integer = 12;
gv_fractional = gv_width - gv_integer;

ds_width = 32;
ds_integer = 12;
ds_fractional = ds_width - ds_integer;

path_name = 'C:\Users\Ryan\Documents\University\Project\MATLAB\Test Project\DEPLOYMENT_LATENCY_TESTS\';

% ds details is unsigned integer - specify with uint32
% ---------------------------

%% TRAINING MODEL WRITE
for classifier = 1:1:no_models
    % get file names for support vectors, support vectors fixed point,
    % coeffs, offsets and geometric values for a particular classifier,
    % "classifier"
    % support vectors, fixed point:
    sv_fi_filename = strcat('svs_fi_', num2str(classifier),'.dat');
    sv_fi_file_path = strcat(path_name, sv_fi_filename);
    % support vector coefficients, fixed point:
    coeffs_fi_filename = strcat('coeffs_fi_', num2str(classifier),'.dat');
    coeffs_fi_file_path = strcat(path_name, coeffs_fi_filename);   
    % current classifier offset, fixed point:
    offset_fi_filename = strcat('offset_fi_', num2str(classifier),'.dat');
    offset_fi_file_path = strcat(path_name, offset_fi_filename);
    
    % PRINT TRAINING MODEL DETAILS TO A FILE
    sv_fi_file = fopen(sv_fi_file_path,'w');
    coeff_fi_file = fopen(coeffs_fi_file_path,'w');
    offsets_fi_file = fopen(offset_fi_file_path,'w');

    support_vectors = full(svm_models{classifier,1}.SVs);
    coeffs = svm_models{classifier,1}.sv_coef;
    no_support_vectors = svm_models{classifier,1}.totalSV;

    for n1 = 1:1:no_support_vectors
        for n2 = 1:1:no_variables
            % for fixed point:
            current_sv_fi = fi(support_vectors(n1,n2),1,data_width,data_fractional);
            % current_fi_bin = bin(current_sv_fi);
            current_fi_dec = dec(current_sv_fi);        % unsigned integer representation
            % fprintf(sv_fi_file, '%s ', current_fi_bin);
            fprintf(sv_fi_file, '%s ', current_fi_dec);
        end
        fprintf(sv_fi_file,'\n');
        current_coeff_fi = fi(coeffs(n1),1,coeffs_width,coeffs_fractional);
        coeff_fi_dec = dec(current_coeff_fi);
        fprintf(coeff_fi_file, '%s \n', coeff_fi_dec);
    end

    offset = -svm_models{classifier,1}.rho;
    offset_fi = fi(offset,1,coeffs_width,coeffs_fractional);
    offset_fi_dec = dec(offset_fi);
    fprintf(offsets_fi_file, '%s \n', offset_fi_dec);

    fclose(sv_fi_file);
    fclose(coeff_fi_file);
    fclose(offsets_fi_file);
end

% get numbers of support vectors for each class - needed to compute testing
% predictions
n_svs_file = fopen(strcat(path_name,'n_svs.dat'),'w');
n_svs_fi_file = fopen(strcat(path_name,'n_svs_fi.dat'),'w');

for n1 = 1:1:no_models
    no_support_vectors = svm_models{n1,1}.totalSV;
    fprintf(n_svs_file, '%d \n', no_support_vectors);
    
    no_support_vectors_fi = fi(no_support_vectors,1,ds_width,ds_fractional);
    no_support_vectors_fi_dec = dec(no_support_vectors_fi);
    fprintf(n_svs_fi_file, '%s \n', no_support_vectors_fi_dec);
end
fclose(n_svs_file);
fclose(n_svs_fi_file);

%% REPEAT THIS FOR DIFFERET NUMBER OF TESTING VECTORS
path_name = 'C:\Users\Ryan\Documents\University\Project\MATLAB\Test Project\DEPLOYMENT_LATENCY_TESTS\TEMP_DATA\';

for classifier = 1:1:no_models
    % geometric values, fixed point:
    ge_fi_filename = strcat('geometric_values_fi_', num2str(classifier),'.dat');
    ge_fi_file_path = strcat(path_name, ge_fi_filename);
    
    % PRINT GEOMETRIC VALUES TO A FILE
    ge_values_fi_file = fopen(ge_fi_file_path,'w');
    for n1 = 1:1:testing_size
%         ge_val_fi = fi(functional_margins(n1,classifier),1,gv_width,gv_fractional);
%         ge_val_fi_dec = dec(ge_val_fi);
%         fprintf(ge_values_fi_file, '%s\n', ge_val_fi_dec);
    end
    fclose(ge_values_fi_file);
end

% TESTING MATRIX AND LABELS TO FILE
test_matrix_fi_file = fopen(strcat(path_name,'test_matrix_fi.dat'),'w');
test_labels_file = fopen(strcat(path_name,'test_labels.dat'),'w');
test_predictions_libsvm_file = fopen(strcat(path_name,'test_predictions_libsvm.dat'),'w');
for n1 = 1:1:testing_size
    for n2 = 1:1:no_variables
        % for fixed point:
%         current_test_fi = fi(testing_matrix(n1,n2),1,data_width,data_fractional);
%         current_fi_dec = dec(current_test_fi);
%         fprintf(test_matrix_fi_file, '%s ', current_fi_dec);
    end
%     fprintf(test_matrix_fi_file, '\n');
    fprintf(test_labels_file, '%d\n', testing_labels(n1));
    fprintf(test_predictions_libsvm_file, '%d\n', raw_predict_label(n1));
end
fclose(test_matrix_fi_file);
fclose(test_labels_file);
fclose(test_predictions_libsvm_file);

% WRITE OTHER DATASET DETAILS TO A FILE
% - number of variables
% - number of classes
% - number of test vectors

ds_details_file = fopen(strcat(path_name,'ds_details.dat'),'w');
fprintf(ds_details_file, '%d\n', no_variables);
fprintf(ds_details_file, '%d\n', testing_size);
fprintf(ds_details_file, '%d\n', k);
fclose(ds_details_file);

ds_details_RBF_file = fopen(strcat(path_name,'ds_details_RBF.dat'),'w');
fprintf(ds_details_RBF_file, '%d\n', no_variables);
fprintf(ds_details_RBF_file, '%d\n', testing_size);
fprintf(ds_details_RBF_file, '%d\n', k);
fprintf(ds_details_RBF_file, '%f\n', gamma);
fclose(ds_details_RBF_file);

% above but for fixed point
ds_details_RBF_fi_file = fopen(strcat(path_name,'ds_details_RBF_fi.dat'),'w');

no_variables_fi = fi(no_variables,1,ds_width,ds_fractional);
no_variables_fi_dec = dec(no_variables_fi);
fprintf(ds_details_RBF_fi_file, '%s\n', no_variables_fi_dec);

testing_size_fi = fi(testing_size,1,ds_width,ds_fractional);
testing_size_fi_dec = dec(testing_size_fi);
fprintf(ds_details_RBF_fi_file, '%s\n', testing_size_fi_dec);

k_fi = fi(k,1,ds_width,ds_fractional);
k_fi_dec = dec(k_fi);
fprintf(ds_details_RBF_fi_file, '%s\n', k_fi_dec);

gamma_fi = fi(gamma,1,ds_width,ds_fractional);
gamma_fi_dec = dec(gamma_fi);
fprintf(ds_details_RBF_fi_file, '%s\n', gamma_fi_dec);

fclose(ds_details_RBF_fi_file);