1   #include "geometric_values.h"
2   #include <string>
3   
4   using namespace std;
5   
6   void get_dataset_details(float dataset_details[4]){
7   	// return the 3 values relating to the dataset
8   	// number of variables
9   	// number of testing vectors
10  	ifstream data_in;
11  	data_in.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/deployment_files_RBF/ds_details_RBF.dat");
12  	for(int i = 0; i < 4; i++){
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
24  	string file_path = "C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/deployment_files_RBF/";
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
63  	data_matrix.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/deployment_files_RBF/test_matrix.dat");
64  	ifstream labels_data;
65  	labels_data.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/deployment_files_RBF/test_labels.dat");
66  	ifstream predictions_data;
67  	predictions_data.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/deployment_files_RBF/test_predictions_libsvm.dat");
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
88  void get_geometric_values(inter_values geometric_values_actual[t_max], int no_test_vectors, int current_classifier){
89  
90  	string ge_values_filename = "C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/deployment_files_RBF/geometric_values_" + to_string(current_classifier) + ".dat";
91  
92  	ifstream ge_values_data;
93  	//ge_values_data.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/geometric_values_1.dat");
94  	ge_values_data.open(ge_values_filename);
95  
96  	for(int i = 0; i < no_test_vectors; i++){
97  		ge_values_data >> geometric_values_actual[i];
98  	}
99  
100 	ge_values_data.close();
101 }
102 
103 void get_no_svs(n_svs *no_svs, int current_classifier, int no_classes){
104 	// get number of support vectors for this classifier
105 
106 	string file_path = "C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/deployment_files_RBF/";
107 	string n_svs_file_path = file_path + "n_svs.dat";
108 
109 	ifstream data_no_svs;
110 	//data_no_svs.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/n_svs.dat");	// number of support vectors
111 	data_no_svs.open(n_svs_file_path);	// number of support vectors
112 
113 	int no_classifiers = no_classes * (no_classes - 1) / 2;
114 	n_svs no_svs_all[no_classifiers];
115 	for(int i = 0; i < no_classifiers; i++){
116 		data_no_svs >> no_svs_all[i];
117 	}
118 	//*no_svs = int(no_svs_all[current_classifier - 1]);
119 	*no_svs = no_svs_all[current_classifier - 1];
120 
121 	data_no_svs.close();
122 }
123 
124 coeffs get_norm_w(data_matrices_AXIS support_vectors[m][n],
125 				  sv_coeffs_AXIS sv_coeffs[m],
126 				  n_svs current_no_svs,
127 				  n_variables no_variables){
128 			 	  // returns the weights vector and its norm
129 
130 	coeffs norm_w = 0;
131 
132 	coeffs w[n];
133 
134 	for(int i = 0; i < n; i++){
135 		w[i] = 0;
136 	}
137 
138 	// compute the weights vector, w
139 	for(int n1 = 0; n1 < current_no_svs; n1++){
140 		for(int n2 = 0; n2 < no_variables; n2++){
141 			w[n2] = w[n2] + sv_coeffs[n1].data * support_vectors[n1][n2].data;
142 		}
143 	}
144 
145 	// compute the norm of w, ||w|| - square norm is computed then square root it
146 	coeffs square_norm = 0;
147 	for(int n3 = 0; n3 < no_variables; n3++){
148 		square_norm = square_norm + w[n3] * w[n3];
149 	}
150 
151 	norm_w = coeffs(sqrt(square_norm.to_float()));
152 
153 	return norm_w;
154 
155 }
156 
157 int main(void){
158 
159 	// CHOOSE THE CLASSIFIER
160 	int current_classifier = 6;
161 
162 	// READ IN DETAILS FOR THE DATASET
163 	float dataset_details[4] = {0};
164 	get_dataset_details(dataset_details);
165 	n_variables no_variables = n_variables(dataset_details[0]);
166 	n_test_vectors no_test_vectors = n_test_vectors(dataset_details[1]);
167 	n_classes no_classes = n_classes(dataset_details[2]);
168 	coeffs gamma = dataset_details[3];
169 
170 	int no_variables_int = no_variables.to_int();
171 	int no_test_vectors_int = no_test_vectors.to_int();
172 
173 	// READ IN DETAILS FOR THE TRAINING MODEL
174 	sv_coeffs_AXIS sv_coeffs[m] = {0};
175 	n_svs no_svs = 0;
176 	offsets offset = 0;
177 
178 	// GET NUMBER OF SUPPORT VECTORS FOR THIS CLASSIFIER
179 	get_no_svs(&no_svs, current_classifier, no_classes);
180 
181 	int no_svs_int = no_svs.to_int();
182 
183 	static data_matrices_AXIS support_vectors[m][n];
184 	get_training_model(support_vectors, sv_coeffs, &no_svs_int, &offset, &no_variables_int, current_classifier);
185 
186 	// READ IN TEST MATRIX AND ASSOCIATED LABELS
187 	data_matrices_AXIS testing_matrix[t_max][n] = {0};
188 	data_labels testing_labels[t_max] = {0};
189 	data_labels testing_predictions_libsvm[t_max] = {0};
190 	read_test_matrix(testing_matrix, testing_labels, testing_predictions_libsvm, no_test_vectors_int, no_variables_int);
191 
192 	// GET ACTUAL GEOMETRIC VALUES FOR COMPARISON
193 	inter_values geometric_values_actual[no_test_vectors_int] = {0};
194 	get_geometric_values(geometric_values_actual, no_test_vectors_int, current_classifier);
195 
196 	// CREATE CONTIGUOS MEMORY TO PASS TO TOP LEVEL FUNCTION AS DATA STREAM
197 	//support_vectors_stream support_vectors_in;
198 	sv_coeffs_stream sv_coeffs_in;
199 	//testing_matrix_stream testing_matrix_in;
200 	geometric_values_stream geometric_values_out;
201 	data_matrix_stream support_vectors_in;
202 
203 	// make "no_test_vectors" copies of support vectors in stream
204 	for(int h = 0; h < no_test_vectors_int; h++){
205 		// fill support vectors stream buffer
206 		for(int i = 0; i < no_svs; i++){
207 			for(int j = 0; j < no_variables; j++){
208 				//support_vectors_in.write(support_vectors[i][j]);
209 				support_vectors_in.write(support_vectors[i][j]);
210 			}
211 		}
212 	}
213 
214 	// fil support vector coefficients buffer
215 	// gamma is first element, norm_w seconf
216 	sv_coeffs_AXIS gamma_AXIS;
217 	gamma_AXIS.data = gamma;
218 	gamma_AXIS.last = 0;
219 	sv_coeffs_in.write(gamma_AXIS);
220 
221 	sv_coeffs_AXIS norm_w_AXIS;
222 	coeffs norm_w;
223 	norm_w = get_norm_w(support_vectors, sv_coeffs, no_svs, no_variables);
224 	norm_w_AXIS.data = norm_w;
225 	norm_w_AXIS.last = 0;
226 	sv_coeffs_in.write(norm_w_AXIS);
227 
228 	cout << "\n\nnorm_w: " << norm_w << "\n\n";
229 
230 	// as with support vectors - need to extend the stream by no_test_vectors - include offset at end of each!
231 	for(int h = 0; h < no_test_vectors_int; h++){
232 		for(int i = 0; i < no_svs; i++){
233 			sv_coeffs_in.write(sv_coeffs[i]);
234 		}
235 		// append the offset to end of sv coeffs stream
236 		sv_coeffs_AXIS offset_AXIS;
237 		offset_AXIS.data = offset;
238 		offset_AXIS.last = 1;
239 		sv_coeffs_in.write(offset_AXIS);
240 	}
241 
242 	data_matrix_stream testing_matrix_in;
243 	// stream testing matrix - ********ONLY FIRST TESTING VECTOR USED FOR THIS SIMULATION********
244 	for(int i = 0; i < no_test_vectors_int; i++){
245 		for(int j = 0; j < no_variables_int; j++){
246 			//testing_matrix_in.write(testing_matrix[i][j]);
247 			testing_matrix_in.write(testing_matrix[i][j]);
248 		}
249 	}
250 
251 
252 	// fill dataset details stream
253 	dataset_details_stream dataset_details_in;
254 	dataset_details_AXIS no_svs_AXIS;
255 	dataset_details_AXIS no_variables_AXIS;
256 	dataset_details_AXIS no_test_vectors_AXIS;
257 
258 	no_svs_AXIS.data = no_svs;
259 	no_svs_AXIS.last = 0;
260 	no_variables_AXIS.data = dataset_details[0];
261 	no_variables_AXIS.last = 0;
262 	no_test_vectors_AXIS.data = no_test_vectors;
263 	no_test_vectors_AXIS.last = 1;
264 
265 	dataset_details_in.write(no_svs_AXIS);
266 	dataset_details_in.write(no_variables_AXIS);
267 	dataset_details_in.write(no_test_vectors_AXIS);
268 
269 	// ^^ FOR HLS STREAM/AXIS ^^
270 
271 	// CALL TOP LEVEL FUNCTION - GET GEOMETRIC VALUES
272 	geometric_values_rbf_top(support_vectors_in, sv_coeffs_in, testing_matrix_in, dataset_details_in, geometric_values_out);
273 
274 	// PRINT GEOMETRIC VALUES AND COMPUTE ACCURACY
275 	cout << "\nGEOMETRIC VALUES \t\tACTUAL GEOMETRIC VALUES\n";
276 	cout << "--------------------------\n";
277 	int error_count = 0;
278 	typedef ap_fixed<32,1> tb_tol;
279 	tb_tol tolerance = 0.001;
280 	//float tolerance = 0.001;
281 
282 	for(int i = 0; i < no_test_vectors; i++){
283 		inter_values geometric_value = geometric_values_out.read().data;
284 
285 		cout << geometric_value << "\t\t" << geometric_values_actual[i] << "\n";
286 		if(((geometric_value < geometric_values_actual[i])
287 			&& (geometric_value + tolerance) < geometric_values_actual[i])
288 			|| ((geometric_value > geometric_values_actual[i])
289 			&& (geometric_value - tolerance) > geometric_values_actual[i])){
290 				error_count++;
291 		}
292 	}
293 
294 	cout << "\nNUMBER OF ERRORS: " << error_count << "\n";
295 
296 	// OUTPUT ZERO IF RESULT IS CORRECT - ONE OTHERWISE (WILL FAIL COSIM)
297 	if(error_count == 0){
298 		return 0;
299 	}
300 	else{
301 		return 1;
302 	}
303 }
304 