1   #include "geometric_values.h"
2   
3   using namespace std;
4   
5   coeffs get_w(data_matrix_stream &data_matrices,
6   		 	 sv_coeffs_stream &sv_coeffs,
7   			 n_svs *no_svs,
8   			 n_variables *no_variables,
9   			 coeffs w[n]){
10  
11  	// returns the weights vector and its norm - weights vector w[n] in arguments list (pointer)
12  	coeffs norm_w = 0;
13  
14  	for(loop_ind_n n1 = 0; n1 < n; n1++){
15  		w[n1] = 0;							// array initialise to zero
16  	}
17  
18  	// compute the weights vector, w
19  	for(loop_ind_m n1 = 0; n1 < m; n1++){
20  		if(n1 < *no_svs){
21  			//data_vectors coeff_in = sv_coeffs.read().data;
22  			//coeffs current_coeff = coeff_in.to_float();	// get support vector coefficient
23  			coeffs current_coeff = sv_coeffs.read().data;
24  
25  			for(loop_ind_n n2 = 0; n2 < n; n2++){
26  #pragma HLS PIPELINE
27  				if(n2 < *no_variables){
28  					// only read the actual array sizes - in PS, pass the correct array size to stream:
29  					w[n2] = w[n2] + current_coeff * data_matrices.read().data;	// accessed sequentially - in C++, arrays arranged along columns then down rows in memory
30  				}
31  				//else{
32  				//	break;
33  				//}
34  			}
35  		}
36  		else{
37  			break;
38  		}
39  	}
40  
41  	// compute the norm of w, ||w|| - square norm is computed then square root it
42  	coeffs square_norm = 0;
43  	for(loop_ind_n n3 = 0; n3 < n; n3++){
44  #pragma HLS PIPELINE
45  		if(n3 < *no_variables){
46  			square_norm = square_norm + w[n3] * w[n3];
47  		}
48  	}
49  	norm_w = coeffs(sqrt(square_norm.to_float()));			// use to_float() to convert ap_fixed to float
50  
51  	return norm_w;
52  }
53  
54  void get_geometric_values_linear(data_matrix_stream &data_matrices,
55  								 sv_coeffs_stream &sv_coeffs,
56  								 n_svs *no_svs,
57  								 n_variables *no_variables,
58  								 n_test_vectors *no_test_vectors,
59  								 geometric_values_stream &geometric_values){
60  
61  	// this function performs the same operation as the kernelised version - by computing the matrix
62  	// of geometric values - it is optimised for the linear kernel in that w is explicitly calculated
63  
64  	// weights vector
65  	coeffs norm_w = 0;
66  
67  	// compute w and ||w||
68  	coeffs w[n];
69  	norm_w = get_w(data_matrices, sv_coeffs, no_svs, no_variables, w);
70  
71  	coeffs one = 1;
72  	coeffs norm_w_recip = one / norm_w;				// so we do not have to compute this division in every iteration of geometric values
73  
74  	//coeffs norm_w_recip = norm_w_reciprocal(norm_w);
75  
76  	coeffs offset = sv_coeffs.read().data;		// final element of sv coeffs stream is the offset
77  
78  	coeffs f_value = 0;
79  	geometric_values_AXIS geometric_value;
80  
81  	// iterate over all test vectors for this classifier to obtain geometric values
82  	geo_vals_outer_loop: for(loop_ind_t n1 = 0; n1 < t_max; n1++){
83  		if(n1 < *no_test_vectors){
84  
85  			f_value = 0;	// functional value for testing vector at n2 with classifier n1 - can be negative or positive
86  
87  			// compute the functional value using the dot product of the test vector with w for this binary classifier
88  			get_f_value_loop: for(loop_ind_n n2 = 0; n2 < n; n2++){
89  #pragma HLS PIPELINE
90  				if(n2 < *no_variables){
91  					//data_vectors tm_in = testing_matrix.read().data;
92  
93  					f_value = f_value + w[n2] * data_matrices.read().data;
94  
95  				}
96  			}
97  
98  			//f_value = f_value_mac(w, testing_matrix, no_variables);
99  
100 			// compute the geometric values by adding the offset and scaling the functional values by the norm of the weights vector
101 			coeffs temp_var = f_value + offset;
102 			geometric_value.data = temp_var * norm_w_recip;
103 
104 			// check if we are at the end of the stream:
105 			if(n1 == (*no_test_vectors - 1)){
106 				geometric_value.last = 1;
107 			}
108 			else{
109 				geometric_value.last = 0;
110 			}
111 
112 			// write geometric value to stream:
113 			geometric_values.write(geometric_value);
114 		}
115 		else{
116 			break;
117 		}
118 	}
119 }
120 
121 void geometric_values_top(data_matrix_stream &data_matrices,
122 		  	  	  	  	  sv_coeffs_stream &sv_coeffs,
123 						  dataset_details_stream &dataset_details,
124 						  geometric_values_stream &geometric_values){
125 #pragma HLS INTERFACE axis port=data_matrices
126 #pragma HLS INTERFACE axis port=dataset_details
127 #pragma HLS INTERFACE axis port=geometric_values
128 #pragma HLS INTERFACE axis port=sv_coeffs
129 #pragma HLS INTERFACE ap_ctrl_none port=return
130 
131 	// Note, the offset is the last element in the sv coeffs stream
132 	// Note, data_matrices contains the support vectors and testing matrix
133 
134 	// dataset_details stream => no_svs -> no_variables -> no_test_vectors
135 
136 	// PYNQ MMIO requires top-level scalar arguments to be pointers otherwise unexpected behaviour
137 
138 	//ds_details no_svs;
139 	//ds_details no_variables;
140 	//ds_details no_test_vectors;
141 
142 	n_svs no_svs;
143 	n_variables no_variables;
144 	n_test_vectors no_test_vectors;
145 
146 	// read dataset details stream and store as scalars
147 	no_svs = dataset_details.read().data;
148 	no_variables = ap_uint<9>(dataset_details.read().data);
149 	no_test_vectors = dataset_details.read().data;
150 
151 	// call function to compute geometric values using the default linear kernel
152 	get_geometric_values_linear(data_matrices,
153 			   	   	   	  sv_coeffs,
154 						  &no_svs,
155 						  &no_variables,
156 						  &no_test_vectors,
157 						  geometric_values);
158 
159 }
160 