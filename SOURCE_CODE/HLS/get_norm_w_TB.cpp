1   #include "get_norm_w.h"
2   #include <string>
3   
4   using namespace std;
5   
6   void get_dataset_details(ds_details dataset_details[3]){
7   	// return the 3 values relating to the dataset
8   	// number of variables
9   	// number of testing vectors
10  	ifstream data_in;
11  	data_in.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/ds_details.dat");
12  	for(int i = 0; i < 3; i++){
13  		data_in >> dataset_details[i];
14  	}
15  	data_in.close();
16  }
17  
18  void get_training_model(data_matrices_AXIS support_vectors[m][n], sv_coeffs_AXIS sv_coeffs[m], int *no_svs, offsets *offsets, int *no_variables, int current_classifier){
19  // read the support vectors, support vector coefficients, number of support vectors and offset values
20  	//n_variables no_variables = ds_details[0];
21  	//n_test_vectors no_test_vectors = ds_details[1];
22  	//n_classes no_classes = ds_details[2];
23  
24  	string file_path = "C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/";
25  	string svs_file_path = file_path + "svs_" + to_string(current_classifier) + ".dat";
26  	string coeffs_file_path = file_path + "coeffs_" + to_string(current_classifier) + ".dat";
27  	string offset_file_path = file_path + "offset_" + to_string(current_classifier) + ".dat";
28  
29  	ifstream data_svs;
30  	//data_svs.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/svs_1.dat");	// support vectors
31  	data_svs.open(svs_file_path);	// support vectors
32  	ifstream data_coeffs;
33  	//data_coeffs.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/coeffs_1.dat");	// support vector coefficients
34  	data_coeffs.open(coeffs_file_path);	// support vector coefficients
35  	ifstream data_offsets;
36  	//data_offsets.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/offset_1.dat");	// offsets for each training model
37  	data_offsets.open(offset_file_path);	// offsets for each training model
38  
39  	// iterate over the number of support vectors in this class
40  	for(int j = 0; j < *no_svs; j++){
41  		// iterate over variables for each support vector
42  		for(int k1 = 0; k1 < *no_variables; k1++){
43  			data_svs >> support_vectors[j][k1].data;
44  			support_vectors[j][k1].last = 0;
45  		}
46  		data_coeffs >> sv_coeffs[j].data;
47  		sv_coeffs[j].last = 0;
48  	}
49  	support_vectors[(*no_svs)-1][*no_variables-1].last = 1;	// specify the last element in the data stream
50  	//sv_coeffs[(*no_svs)-1].last = 1;
51  
52  	data_offsets >> *offsets;
53  
54  	data_svs.close();
55  	data_coeffs.close();
56  	data_offsets.close();
57  
58  }
59  
60  void get_no_svs(n_svs *no_svs, int current_classifier, int no_classes){
61  	// get number of support vectors for this classifier
62  
63  	string file_path = "C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/";
64  	string n_svs_file_path = file_path + "n_svs.dat";
65  
66  	ifstream data_no_svs;
67  	//data_no_svs.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/n_svs.dat");	// number of support vectors
68  	data_no_svs.open(n_svs_file_path);	// number of support vectors
69  
70  	int no_classifiers = no_classes * (no_classes - 1) / 2;
71  	n_svs no_svs_all[no_classifiers];
72  	for(int i = 0; i < no_classifiers; i++){
73  		data_no_svs >> no_svs_all[i];
74  	}
75  	//*no_svs = int(no_svs_all[current_classifier - 1]);
76  	*no_svs = no_svs_all[current_classifier - 1];
77  
78  	data_no_svs.close();
79  }
80  
81  int main(void){
82  
83  	// CHOOSE THE CLASSIFIER
84  	int current_classifier = 5;
85  
86  	// READ IN DETAILS FOR THE DATASET
87  	ds_details dataset_details[3] = {0};
88  	get_dataset_details(dataset_details);
89  	n_variables no_variables = dataset_details[0];
90  	int no_test_vectors = dataset_details[1];
91  	int no_classes = dataset_details[2];
92  
93  	int no_variables_int = no_variables.to_int();
94  	int no_test_vectors_int = no_test_vectors;
95  
96  	// READ IN DETAILS FOR THE TRAINING MODEL
97  	sv_coeffs_AXIS sv_coeffs[m] = {0};
98  	n_svs no_svs = 0;
99  	offsets offset = 0;
100 
101 	// GET NUMBER OF SUPPORT VECTORS FOR THIS CLASSIFIER
102 	get_no_svs(&no_svs, current_classifier, no_classes);
103 
104 	int no_svs_int = no_svs.to_int();
105 
106 	static data_matrices_AXIS support_vectors[m][n];
107 	get_training_model(support_vectors, sv_coeffs, &no_svs_int, &offset, &no_variables_int, current_classifier);
108 
109 	// INPUT STREAMS
110 	sv_coeffs_stream sv_coeffs_in;
111 	data_matrix_stream data_matrices_in;
112 
113 	// fill support vectors stream buffer
114 	for(int i = 0; i < no_svs; i++){
115 		for(int j = 0; j < no_variables; j++){
116 			//support_vectors_in.write(support_vectors[i][j]);
117 			data_matrices_in.write(support_vectors[i][j]);
118 		}
119 	}
120 
121 	// fil support vector coefficients buffer
122 	for(int i = 0; i < no_svs; i++){
123 		sv_coeffs_in.write(sv_coeffs[i]);
124 	}
125 
126 	// fill dataset details stream
127 	dataset_details_stream dataset_details_in;
128 	dataset_details_AXIS no_svs_AXIS;
129 	dataset_details_AXIS no_variables_AXIS;
130 
131 	no_svs_AXIS.data = no_svs;
132 	no_svs_AXIS.last = 0;
133 	no_variables_AXIS.data = dataset_details[0];
134 	no_variables_AXIS.last = 1;
135 
136 	dataset_details_in.write(no_svs_AXIS);
137 	dataset_details_in.write(no_variables_AXIS);
138 
139 	// output stream
140 	sv_coeffs_stream norm_w_stream;
141 
142 	get_w(data_matrices_in, sv_coeffs_in, dataset_details_in, norm_w_stream);
143 
144 	cout << "||w|| = " << norm_w_stream.read().data << "\n";
145 	return 0;	// not self-checking
146 }
147 