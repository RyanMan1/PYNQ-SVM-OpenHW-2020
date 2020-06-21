1   #include "geometric_values.h"
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
60  void read_test_matrix(data_matrices_AXIS testing_matrix[t_max][n], data_labels testing_labels[t_max], data_labels testing_predictions_libsvm[t_max], int no_test_vectors, int no_variables){
61  	// read from dat file and populate C++ variables
62  	ifstream data_matrix;
63  	data_matrix.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/test_matrix.dat");
64  	ifstream labels_data;
65  	labels_data.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/test_labels.dat");
66  	ifstream predictions_data;
67  	predictions_data.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/test_predictions_libsvm.dat");
68  
69  	float test = 0.0;
70  	for(int i = 0; i < no_test_vectors; i++){
71  		for(int j = 0; j < no_variables; j++){
72  			data_matrix >> testing_matrix[i][j].data;
73  			testing_matrix[i][j].last = 0;
74  		}
75  		float test_label = 0.0;
76  		labels_data >> test_label;
77  		testing_labels[i] = data_labels(test_label);
78  		float test_prediction = 0.0;
79  		predictions_data >> test_prediction;
80  		testing_predictions_libsvm[i] = data_labels(test_prediction);
81  	}
82  	testing_matrix[no_test_vectors-1][no_variables-1].last = 1;			// specofy the last elemtn in the data stream
83  	data_matrix.close();
84  	labels_data.close();
85  	predictions_data.close();
86  }
87  
88  void get_kernel_details(kernel_param kernel_parameters[4]){
89  	ifstream kernel_data;
90  	kernel_data.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/kernel_details.dat");
91  	kernel_data >> kernel_parameters[0];
92  	kernel_data >> kernel_parameters[1];
93  	kernel_data >> kernel_parameters[2];
94  	kernel_data >> kernel_parameters[3];
95  	kernel_data.close();
96  }
97  
98  void get_geometric_values(inter_values geometric_values_actual[t_max], int no_test_vectors, int current_classifier){
99  
100 	string ge_values_filename = "C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/geometric_values_" + to_string(current_classifier) + ".dat";
101 
102 	ifstream ge_values_data;
103 	//ge_values_data.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/geometric_values_1.dat");
104 	ge_values_data.open(ge_values_filename);
105 
106 	for(int i = 0; i < no_test_vectors; i++){
107 		ge_values_data >> geometric_values_actual[i];
108 	}
109 
110 	ge_values_data.close();
111 }
112 
113 void get_no_svs(n_svs *no_svs, int current_classifier, int no_classes){
114 	// get number of support vectors for this classifier
115 
116 	string file_path = "C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/";
117 	string n_svs_file_path = file_path + "n_svs.dat";
118 
119 	ifstream data_no_svs;
120 	//data_no_svs.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/n_svs.dat");	// number of support vectors
121 	data_no_svs.open(n_svs_file_path);	// number of support vectors
122 
123 	int no_classifiers = no_classes * (no_classes - 1) / 2;
124 	n_svs no_svs_all[no_classifiers];
125 	for(int i = 0; i < no_classifiers; i++){
126 		data_no_svs >> no_svs_all[i];
127 	}
128 	//*no_svs = int(no_svs_all[current_classifier - 1]);
129 	*no_svs = no_svs_all[current_classifier - 1];
130 
131 	data_no_svs.close();
132 }
133 
134 int main(void){
135 
136 	// CHOOSE THE CLASSIFIER
137 	int current_classifier = 1;
138 
139 	// READ IN DETAILS FOR THE DATASET
140 	ds_details dataset_details[3] = {0};
141 	get_dataset_details(dataset_details);
142 	n_variables no_variables = dataset_details[0];
143 	n_test_vectors no_test_vectors = dataset_details[1];
144 	n_classes no_classes = dataset_details[2];
145 
146 	int no_variables_int = no_variables.to_int();
147 	int no_test_vectors_int = no_test_vectors.to_int();
148 
149 	// READ IN DETAILS FOR THE TRAINING MODEL
150 	sv_coeffs_AXIS sv_coeffs[m] = {0};
151 	n_svs no_svs = 0;
152 	offsets offset = 0;
153 
154 	// GET NUMBER OF SUPPORT VECTORS FOR THIS CLASSIFIER
155 	get_no_svs(&no_svs, current_classifier, no_classes);
156 
157 	int no_svs_int = no_svs.to_int();
158 
159 	static data_matrices_AXIS support_vectors[m][n];
160 	get_training_model(support_vectors, sv_coeffs, &no_svs_int, &offset, &no_variables_int, current_classifier);
161 
162 	// READ IN TEST MATRIX AND ASSOCIATED LABELS
163 	data_matrices_AXIS testing_matrix[t_max][n] = {0};
164 	data_labels testing_labels[t_max] = {0};
165 	data_labels testing_predictions_libsvm[t_max] = {0};
166 	read_test_matrix(testing_matrix, testing_labels, testing_predictions_libsvm, no_test_vectors_int, no_variables_int);
167 
168 	// GET KERNEL DETAILS
169 	kernel_param kernel_parameters[4];
170 	get_kernel_details(kernel_parameters);
171 	// position 0 is r, 1 is d, 2 is gamma and 3 is the type of kernel (0 - linear, 1 - polynomial, 2 - rbf)
172 
173 	// GET ACTUAL GEOMETRIC VALUES FOR COMPARISON
174 	inter_values geometric_values_actual[no_test_vectors_int] = {0};
175 	get_geometric_values(geometric_values_actual, no_test_vectors_int, current_classifier);
176 
177 	// CREATE CONTIGUOS MEMORY TO PASS TO TOP LEVEL FUNCTION AS DATA STREAM
178 	//support_vectors_stream support_vectors_in;
179 	sv_coeffs_stream sv_coeffs_in;
180 	//testing_matrix_stream testing_matrix_in;
181 	geometric_values_stream geometric_values_out;
182 	data_matrix_stream data_matrices_in;
183 
184 	// fill support vectors stream buffer
185 	for(int i = 0; i < no_svs; i++){
186 		for(int j = 0; j < no_variables; j++){
187 			//support_vectors_in.write(support_vectors[i][j]);
188 			data_matrices_in.write(support_vectors[i][j]);
189 		}
190 	}
191 
192 	// fil support vector coefficients buffer
193 	for(int i = 0; i < no_svs; i++){
194 		sv_coeffs_in.write(sv_coeffs[i]);
195 	}
196 	// append the offset to end of sv coeffs stream
197 	sv_coeffs_AXIS offset_AXIS;
198 	offset_AXIS.data = offset;
199 	offset_AXIS.last = 1;
200 	sv_coeffs_in.write(offset_AXIS);
201 
202 	// fill testing matrix stream buffer
203 	for(int i = 0; i < no_test_vectors; i++){
204 		for(int j = 0; j < no_variables; j++){
205 			//testing_matrix_in.write(testing_matrix[i][j]);
206 			data_matrices_in.write(testing_matrix[i][j]);
207 		}
208 	}
209 
210 	// fill dataset details stream
211 	dataset_details_stream dataset_details_in;
212 	dataset_details_AXIS no_svs_AXIS;
213 	dataset_details_AXIS no_variables_AXIS;
214 	dataset_details_AXIS no_test_vectors_AXIS;
215 
216 	no_svs_AXIS.data = no_svs;
217 	no_svs_AXIS.last = 0;
218 	no_variables_AXIS.data = dataset_details[0];
219 	no_variables_AXIS.last = 0;
220 	no_test_vectors_AXIS.data = dataset_details[1];
221 	no_test_vectors_AXIS.last = 1;
222 
223 	dataset_details_in.write(no_svs_AXIS);
224 	dataset_details_in.write(no_variables_AXIS);
225 	dataset_details_in.write(no_test_vectors_AXIS);
226 
227 	// ^^ FOR HLS STREAM/AXIS ^^
228 
229 	// CALL TOP LEVEL FUNCTION - GET GEOMETRIC VALUES
230 	geometric_values_top(data_matrices_in, sv_coeffs_in, dataset_details_in, geometric_values_out);
231 
232 	// THIS VARIABLE WILL CONTAIN THE GEOMETRIC VALUES FOR THE CURRENT CLASS
233 	geometric_values_AXIS geometric_values[no_test_vectors_int];
234 	// for AXIS - copy output stream to above declared array
235 	for(int i = 0; i < no_test_vectors; i++){
236 		geometric_values[i] = geometric_values_out.read();
237 	}
238 
239 	// PRINT GEOMETRIC VALUES AND COMPUTE ACCURACY
240 	cout << "\nGEOMETRIC VALUES \t\tACTUAL GEOMETRIC VALUES\n";
241 	cout << "--------------------------\n";
242 	int error_count = 0;
243 	typedef ap_fixed<32,1> tb_tol;
244 	tb_tol tolerance = 0.001;
245 	//float tolerance = 0.001;
246 
247 	for(int i = 0; i < no_test_vectors; i++){
248 		cout << geometric_values[i].data << "\t\t" << geometric_values_actual[i] << "\n";
249 		if(((geometric_values[i].data < geometric_values_actual[i])
250 			&& (geometric_values[i].data + tolerance) < geometric_values_actual[i])
251 			|| ((geometric_values[i].data > geometric_values_actual[i])
252 			&& (geometric_values[i].data - tolerance) > geometric_values_actual[i])){
253 				error_count++;
254 			}
255 	}
256 
257 	cout << "\nNUMBER OF ERRORS: " << error_count << "\n";
258 
259 	// OUTPUT ZERO IF RESULT IS CORRECT - ONE OTHERWISE (WILL FAIL COSIM)
260 	if(error_count == 0){
261 		return 0;
262 	}
263 	else{
264 		return 1;
265 	}
266 }
267 