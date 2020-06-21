%% WRITE TRAINING MATRIX AND LABELS TO FILES
% TRAINING LABELS SHOULD BE A COLUMN VECTOR E.G. 1;1;1;...2;2;2;...3;3;...

C = 1;
tolerance = 0.0001;

data_width = 16;
data_integer = 1;
data_fractional = data_width - data_integer;

misc_width = 32;
misc_integer = 12;
misc_fractional = misc_width - misc_integer;

m = length(training_matrix(:,1));
n = length(training_matrix(1,:));

path_name = 'C:\Users\Ryan\Documents\University\Project\MATLAB\Test Project\DEMO_DATA_NEW\';

k = max(training_labels);

% NO CLASSES %%%%%%%%%%%%%%%%%%%%%%
no_classes_path = strcat(path_name, 'no_classes.dat');
no_classes_file = fopen(no_classes_path, 'w');

fprintf(no_classes_file, '%i \n', k);

fclose(no_classes_file);

% TRAINING MATRIX %%%%%%%%%%%%%%%%%%%%%%%
training_matrix_path = strcat(path_name, 'training_matrix.dat');
training_matrix_file = fopen(training_matrix_path, 'w');

training_matrix_fi_path = strcat(path_name, 'training_matrix_fi.dat');
training_matrix_fi_file = fopen(training_matrix_fi_path, 'w');

for n1 = 1:1:m
    for n2 = 1:1:n
        tm_elem_fi = fi(training_matrix(n1,n2),1,data_width,data_fractional);
        tm_elem_fi_dec = dec(tm_elem_fi);
        fprintf(training_matrix_fi_file, '%s ', tm_elem_fi_dec);
        fprintf(training_matrix_file, '%f ', training_matrix(n1,n2));
    end
    fprintf(training_matrix_fi_file, '\n');
    fprintf(training_matrix_file, '\n');
end

fclose(training_matrix_file);
fclose(training_matrix_fi_file);

% TRAINING LABELS, y %%%%%%%%%%%%%%%%%%%%%%%
training_labels_path = strcat(path_name, 'training_labels.dat');
training_labels_file = fopen(training_labels_path, 'w');

for n1 = 1:1:m
	fprintf(training_labels_file, '%i \n', training_labels(n1));
end

fclose(training_labels_file);

% TRAINING DETAILS %%%%%%%%%%%%%%%%%%%%%%%%%
training_details_path = strcat(path_name, 'training_details.dat');
training_details_file = fopen(training_details_path, 'w');

fprintf(training_details_file, '%f \n', m);   % training matrix for 
fprintf(training_details_file, '%f \n', n);
fprintf(training_details_file, '%f \n', C);             % change C here
fprintf(training_details_file, '%f \n', tolerance);        % change tolerance here

fclose(training_details_file);

% for fixed-point drivers
training_details_path = strcat(path_name, 'training_details_fi.dat');
training_details_file = fopen(training_details_path, 'w');

m_fi = fi(m,1,misc_width,misc_fractional);
m_fi_dec = dec(m_fi);
fprintf(training_details_file, '%s \n', m_fi_dec);   % training matrix for 

no_variables_fi = fi(n,1,misc_width,misc_fractional);
no_variables_fi_dec = dec(no_variables_fi);
fprintf(training_details_file, '%s \n', no_variables_fi_dec);

C_fi = fi(C,1,misc_width,misc_fractional);
C_fi_dec = dec(C_fi);
fprintf(training_details_file, '%s \n', C_fi_dec);

tol_fi = fi(tolerance,1,misc_width,misc_fractional);
tol_fi_dec = dec(tol_fi);
fprintf(training_details_file, '%s \n', tol_fi_dec);        % change tolerance here

fclose(training_details_file);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITE FILES FOR DEPLOYMENT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TESTING MATRIX AND LABELS TO FILE
test_matrix_file = fopen(strcat(path_name,'test_matrix.dat'),'w');
test_matrix_fi_file = fopen(strcat(path_name,'test_matrix_fi.dat'),'w');
test_labels_file = fopen(strcat(path_name,'test_labels.dat'),'w');
test_predictions_libsvm_file = fopen(strcat(path_name,'test_predictions_libsvm.dat'),'w');

testing_size = size(testing_matrix,1);
no_variables = n;

for n1 = 1:1:testing_size
    for n2 = 1:1:no_variables
        fprintf(test_matrix_file, '%f ', testing_matrix(n1,n2));
        % for fixed point:
        current_test_fi = fi(testing_matrix(n1,n2),1,data_width,data_fractional);
        % current_bin = bin(current_test_fi);
        current_fi_dec = dec(current_test_fi);
        % fprintf(test_matrix_fi_file, '%s ', current_bin);
        fprintf(test_matrix_fi_file, '%s ', current_fi_dec);
    end
    fprintf(test_matrix_file, '\n');
    fprintf(test_matrix_fi_file, '\n');
    fprintf(test_labels_file, '%i\n', testing_labels(n1));
    fprintf(test_predictions_libsvm_file, '%i\n', raw_predict_label(n1));
end
fclose(test_matrix_file);
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

% write kernel details to file

kernel_details = fopen(strcat(path_name,'kernel_details.dat'),'w');
fprintf(kernel_details, '%f\n', r);
fprintf(kernel_details, '%f\n', d);
fprintf(kernel_details, '%f\n', gamma);
fprintf(kernel_details, '%f\n', kernel_type);
fclose(kernel_details);