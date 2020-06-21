1   #include "SMO.h"
2   
3   #include <fstream>
4   #include <iostream>
5   
6   #include <string>
7   using namespace std;
8   
9   void get_training_details(input_details_AXIS training_details[7]){
10  	// read training details file and save to 8-length array
11  
12  	ifstream data_in;
13  	data_in.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/smo_test_stimuli/training_details.dat");
14  
15  	for(int i = 0; i < 4; i++){
16  		data_in >> training_details[i].data;
17  		training_details[i].last = 0;
18  		if(i == 6){
19  			training_details[i].last = 1;
20  		}
21  	}
22  
23  }
24  
25  void get_training_dataset(training_matrix_AXIS training_matrix[m][n], training_labels_stream &training_labels_in, int no_training_vectors, int no_variables){
26  	// read training matrix and labels and save labels to stream
27  	// training_matrix returned in memory so x_p can be extracted
28  
29  	ifstream data_matrix;
30  	data_matrix.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/smo_test_stimuli/training_matrix.dat");
31  	ifstream data_labels;
32  	data_labels.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/smo_test_stimuli/training_labels.dat");
33  
34  	for(int i = 0; i < no_training_vectors; i++){
35  		training_labels_AXIS training_label;
36  		float label_temp;
37  		data_labels >> label_temp;
38  		//data_labels >> training_label.data;
39  		training_label.data = class_labels(label_temp);
40  		training_label.last = 0;
41  		if(i == (no_training_vectors - 1)){
42  			training_label.last = 1;
43  		}
44  		training_labels_in.write(training_label);		// write to stream
45  		for(int j = 0; j < no_variables; j++){
46  			data_matrix >> training_matrix[i][j].data;
47  			training_matrix[i][j].last = 0;
48  		}
49  	}
50  
51  	//training_matrix[no_training_vectors - 1][no_variables - 1].last = 1;
52  
53  }
54  
55  void get_dot_product_matrix(dot_product_matrix_AXIS dp_matrix[m][m], int no_training_vectors){
56  	// read matrix of dot product values from file
57  	// could compute from training matrix but computationally intesive for the testbench
58  
59  	ifstream data_dp_matrix;
60  	data_dp_matrix.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/smo_test_stimuli/dot_product_matrix.dat");
61  
62  	for(int i = 0; i < no_training_vectors; i++){
63  		for(int j = 0; j < no_training_vectors; j++){
64  			dot_product_matrix_AXIS dp_matrix_val;
65  			data_dp_matrix >> dp_matrix_val.data;
66  			dp_matrix_val.last = 0;
67  			dp_matrix[i][j] = dp_matrix_val;
68  		}
69  	}
70  
71  }
72  
73  int main(){
74  	// SMO p loop - testbench
75  	float tolerance = 0.0001;				// <======= SPECIFY TOLERANCE HERE
76  	float max_itr = 2;						// <======= SPECIFY MAX_ITR HERE
77  	float C = 1;
78  
79  	// GET TRAINING DETAILS
80  	input_details_AXIS training_parameters[4];
81  	get_training_details(training_parameters);
82  
83  	int no_training_vectors = int(training_parameters[0].data);
84  	int no_variables = int(training_parameters[1].data);
85  
86  	float no_training_vectors_float = float(no_training_vectors);
87  	float no_variables_float = float(no_variables);
88  
89  	input_details_stream input_details;
90  
91  	// send data set details to stream
92  	/*for(int i = 0; i < 2; i++){
93  		input_details.write(training_parameters[i]);
94  	}*/
95  
96  	// send max_itr to stream
97  	input_details_AXIS id_AXIS;
98  	id_AXIS.data = no_training_vectors_float;
99  	id_AXIS.last = 0;
100 	input_details.write(id_AXIS);
101 	id_AXIS.data = no_variables_float;
102 	id_AXIS.last = 0;
103 	input_details.write(id_AXIS);
104 	id_AXIS.data = max_itr;
105 	id_AXIS.last = 0;
106 	input_details.write(id_AXIS);
107 	id_AXIS.data = tolerance;
108 	id_AXIS.last = 0;
109 	input_details.write(id_AXIS);
110 	id_AXIS.data = C;
111 	id_AXIS.last = 1;
112 	input_details.write(id_AXIS);
113 
114 	// GET DOT PRODUCT MATRIX
115 	dot_product_matrix_stream dot_product_matrix_inner;
116 	dot_product_matrix_stream dot_product_matrix_outer;
117 
118 	dot_product_matrix_AXIS dp_matrix[m][m];
119 	get_dot_product_matrix(dp_matrix, no_training_vectors);
120 
121 	// GET TRAINING LABELS AND MATRIX
122 	training_labels_stream training_labels_in;
123 	training_matrix_stream training_matrix_outer;
124 	training_matrix_stream training_matrix_inner;
125 
126 	static training_matrix_AXIS training_matrix[m][n] = {0};
127 	get_training_dataset(training_matrix, training_labels_in, no_training_vectors, no_variables);
128 
129 	// OUTER LOOP REQUIRED FOR MAX_ITR
130 	for(int g = 0; g < max_itr; g++){
131 		for(int i = 0; i < no_training_vectors; i++){
132 			for(int j = 0; j < no_training_vectors; j++){
133 				dp_matrix[i][j].last = 0;
134 				if(i == (no_training_vectors - 1) && (j == (no_training_vectors - 1))){
135 					dp_matrix[i][j].last = 1;
136 				}
137 				dot_product_matrix_outer.write(dp_matrix[i][j]);
138 			}
139 		}
140 
141 		// write inner loop dot_product_matrix to streams - NEED OUTER LOOP FOR CONTINOUS STREAMING...
142 		for(int h = 0; h < no_training_vectors; h++){
143 			for(int i = 0; i < no_training_vectors; i++){
144 				for(int j = 0; j < no_training_vectors; j++){
145 					dp_matrix[i][j].last = 0;
146 					if(i == (no_training_vectors - 1) && (j == (no_training_vectors - 1)) && (h == (no_training_vectors - 1))){
147 						dp_matrix[i][j].last = 1;
148 					}
149 					dot_product_matrix_inner.write(dp_matrix[i][j]);
150 				}
151 			}
152 		}
153 
154 
155 
156 		// write to streams - NEED OUTER LOOP FOR CONTINOUS STREAMING...
157 		for(int i = 0; i < no_training_vectors; i++){
158 			for(int j = 0; j < no_variables; j++){
159 				if(i == (no_training_vectors - 1) && (j == (no_variables - 1))){
160 					training_matrix[i][j].last = 1;
161 				}
162 				training_matrix_outer.write(training_matrix[i][j]);
163 			}
164 		}
165 
166 		for(int h = 0; h < no_training_vectors; h++){
167 			for(int i = 0; i < no_training_vectors; i++){
168 				for(int j = 0; j < no_variables; j++){
169 					if(i == (no_training_vectors - 1) && (j == (no_variables - 1)) && (h == (no_training_vectors - 1))){
170 						training_matrix[i][j].last = 1;
171 					}
172 					training_matrix_inner.write(training_matrix[i][j]);
173 				}
174 			}
175 		}
176 
177 	}
178 
179 	///////////////////////////
180 	// TEMPORARY - FOR TESTING
181 	/*int reqd_itr = 5;
182 	for(int h = 0; h < reqd_itr; h++){
183 		for(int i = 0; i < no_training_vectors; i++){
184 			for(int j = 0; j < no_training_vectors; j++){
185 				dp_matrix[i][j].last = 0;
186 				if(i == (no_training_vectors - 1) && (j == (no_training_vectors - 1)) && (h == (reqd_itr - 1))){
187 					dp_matrix[i][j].last = 1;
188 				}
189 				dot_product_matrix_inner.write(dp_matrix[i][j]);
190 			}
191 		}
192 	}
193 
194 	for(int h = 0; h < reqd_itr; h++){
195 		for(int i = 0; i < no_training_vectors; i++){
196 			for(int j = 0; j < no_variables; j++){
197 				if(i == (no_training_vectors - 1) && (j == (no_variables - 1)) && (h == (reqd_itr - 1))){
198 					training_matrix[i][j].last = 1;
199 				}
200 				training_matrix_inner.write(training_matrix[i][j]);
201 			}
202 		}
203 	}*/
204 	// TEMPORARY - FOR TESTING
205 	///////////////////////////
206 
207 	// DEFINE OUTPUT STREAMS TO BE WRITTEN TO BY DESIGN
208 	alphas_stream alpha_out;
209 	scalars_stream output_details;
210 	indicators_stream kkt_violations;
211 
212 	// CALL TOP LEVEL FUNCTION
213 	SMO_top(dot_product_matrix_outer,
214 			dot_product_matrix_inner,
215 			training_labels_in,
216 			training_matrix_outer,
217 			training_matrix_inner,
218 			input_details,
219 			alpha_out,
220 			kkt_violations,
221 			output_details);
222 
223 	// PRINT RESULT TO CONSOLE
224 	cout << "NEW ALPHA VALUES:\n";
225 	for(int i = 0; i < no_training_vectors; i++){
226 		cout << "alpha" << i+1 << " = " << alpha_out.read().data << "\n";
227 	}
228 
229 	cout << kkt_violations.read().data << "\n";
230 	cout << kkt_violations.read().data << "\n";
231 	cout << kkt_violations.read().data << "\n";
232 	cout << kkt_violations.read().data << "\n";
233 	cout << kkt_violations.read().data << "\n";
234 	cout << kkt_violations.read().data << "\n";
235 	cout << kkt_violations.read().data << "\n";
236 	cout << kkt_violations.read().data << "\n";
237 	cout << kkt_violations.read().data << "\n";
238 	cout << kkt_violations.read().data << "\n";
239 
240 
241 	for(int i = 0; i < max_itr; i++){
242 		output_details.read().data;
243 	}
244 
245 	cout << "OFFSET: " << output_details.read().data << "\n";
246 
247 
248 	//cout << "\nNUMBER OF ITERATIONS: " << output_details.read().data << "\n";
249 
250 	//cout << "\nOFFSET: " << output_details.read().data << "\n";
251 
252 	return 0;	// need to check result manually
253 }
254 