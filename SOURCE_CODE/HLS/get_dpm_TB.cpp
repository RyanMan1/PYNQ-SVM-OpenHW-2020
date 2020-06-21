1  #include "get_dpm.h"
2  
3  #include <fstream>
4  #include <iostream>
5  
6  #include <string>
7  using namespace std;
8  
9  void get_training_details(input_details_AXIS training_details[7]){
10 	// read training details file and save to 8-length array
11 
12 	ifstream data_in;
13 	data_in.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/smo_test_stimuli/training_details.dat");
14 
15 	for(int i = 0; i < 4; i++){
16 		data_in >> training_details[i].data;
17 		training_details[i].last = 0;
18 		if(i == 6){
19 			training_details[i].last = 1;
20 		}
21 	}
22 
23 }
24 
25 void get_training_dataset(training_matrix_AXIS training_matrix[m][n], int no_training_vectors, int no_variables){
26 	// read training matrix and labels and save labels to stream
27 	// training_matrix returned in memory so x_p can be extracted
28 
29 	ifstream data_matrix;
30 	data_matrix.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/smo_test_stimuli/training_matrix.dat");
31 
32 	for(int i = 0; i < no_training_vectors; i++){
33 		for(int j = 0; j < no_variables; j++){
34 			data_matrix >> training_matrix[i][j].data;
35 			training_matrix[i][j].last = 0;
36 		}
37 	}
38 	training_matrix[no_training_vectors - 1][no_variables - 1].last = 1;
39 }
40 
41 /*dot_products matrix_multiply(training_matrix_AXIS mat_1[m][n], training_matrix_AXIS mat_2[m][n], dot_product_matrix_AXIS res[m][m]){
42 	// multiply matrices to compare result
43 
44 }*/
45 
46 int main(){
47 	input_details_AXIS training_parameters[4];
48 	get_training_details(training_parameters);
49 
50 	n_training_vectors no_training_vectors = training_parameters[0].data;
51 	n_variables no_variables = training_parameters[1].data;
52 
53 	int no_training_vectors_int = int(no_training_vectors);
54 	int no_variables_int = int(no_variables);
55 
56 	training_matrix_AXIS training_matrix[m][n];
57 	get_training_dataset(training_matrix, no_training_vectors_int, no_variables_int);
58 
59 	input_details_stream in_details;
60 	in_details.write(training_parameters[0]);
61 	in_details.write(training_parameters[1]);
62 
63 	// fill training matrix streams
64 	training_matrix_stream training_mat_stream_1;
65 	for(int i = 0; i < no_training_vectors_int; i++){
66 		for(int j = 0; j < no_variables_int; j++){
67 			training_mat_stream_1.write(training_matrix[i][j]);
68 		}
69 	}
70 
71 	// second stream needs streamed no_training_vectors times
72 	training_matrix_stream training_mat_stream_2;
73 	for(int h = 0; h < no_training_vectors_int; h++){
74 		for(int i = 0; i < no_training_vectors_int; i++){
75 			for(int j = 0; j < no_variables_int; j++){
76 				training_mat_stream_2.write(training_matrix[i][j]);
77 			}
78 		}
79 	}
80 
81 	dot_product_matrix_stream dp_out;
82 
83 	get_dpm_top(training_mat_stream_1, training_mat_stream_2, dp_out, in_details);
84 
85 	// print result
86 	cout << "DOT PRODUCT MATRIX:\n";
87 	for(int i = 0; i < no_training_vectors_int; i++){
88 		for(int j = 0; j < no_training_vectors_int; j++){
89 			dot_product_matrix_AXIS dp_val;
90 			dp_val = dp_out.read();
91 			cout << dp_val.data << ", last = " << dp_val.last << "\t";
92 		}
93 		cout << "\n";
94 	}
95 
96 	return 0;
97 }
98 