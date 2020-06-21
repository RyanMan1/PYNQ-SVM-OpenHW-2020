1   #include "geometric_values.h"
2   
3   using namespace std;
4   
5   inter_values kernel_rbf(data_matrix_stream &support_vectors, data_vectors vector_2[n], n_variables *no_variables, coeffs *gamma){
6   	// computes the result of the radial basis function kernel between two vectors with parameter gamma
7   	inter_values square_norm = 0;
8   
9   	// compute the square norm of the difference between the two vectors
10  	inter_values difference_element = 0;
11  	square_norm_loop: for(loop_ind_n n1 = 0; n1 < n; n1++){
12  #pragma HLS PIPELINE
13  		if(n1 < *no_variables){
14  			//difference_element = vector_1[n1] - vector_2[n1];
15  			difference_element = support_vectors.read().data - vector_2[n1];
16  			square_norm += difference_element * difference_element;
17  		}
18  	}
19  
20  	// compute the kernel function output
21  	inter_values exp_arg = -*gamma * square_norm;
22  	inter_values kernel_result = inter_values(exp(exp_arg.to_float()));
23  	return kernel_result;
24  }
25  
26  void get_geometric_values_rbf(data_matrix_stream &support_vectors,
27  		  	  	  	  	  	  sv_coeffs_stream &sv_coeffs,
28  							  data_matrix_stream &testing_matrix,
29  							  coeffs *norm_w,
30  							  n_svs *no_svs,
31  							  n_variables *no_variables,
32  							  n_test_vectors *no_test_vectors,
33  							  coeffs *gamma,
34  							  geometric_values_stream &geometric_values_out){
35  
36  	// this function computes the geometric value for the current testing vector using the radial basis function (RBF) kernel
37  
38  	coeffs one = 1;
39  	coeffs norm_w_recip = one / *norm_w;				// so we do not have to compute this division in every iteration of geometric values
40  
41  	// loop over testing vectors - size of testing matrix
42  	for(loop_ind_t n1 = 0; n1 < t_max; n1++){
43  		if(n1 < *no_test_vectors){
44  			coeffs f_value = 0;
45  
46  			// get testing vector
47  			data_vectors testing_vector[n];
48  			for(loop_ind_n n1_2 = 0; n1_2 < n; n1_2++){
49  				if(n1_2 < *no_variables){
50  					testing_vector[n1_2] = testing_matrix.read().data;
51  				}
52  			}
53  
54  			// loop over support vectors
55  			svs_loop: for(loop_ind_m n2 = 0; n2 < m; n2++){
56  				if(n2 < *no_svs){
57  					f_value += sv_coeffs.read().data * kernel_rbf(support_vectors, testing_vector, no_variables, gamma);
58  				}
59  				if(n2 == (*no_svs - 1)){
60  					break;
61  				}
62  			}
63  
64  			// compute the geometric value for this testing vector
65  			geometric_values_AXIS geometric_value;
66  			geometric_value.data = (f_value + sv_coeffs.read().data) * norm_w_recip;
67  			geometric_value.last = 0;
68  			if(n1 == (*no_test_vectors-1)){
69  				geometric_value.last = 1;
70  			}
71  			geometric_values_out.write(geometric_value);
72  		}
73  		if(n1 == (*no_test_vectors-1)){
74  			break;
75  		}
76  	}
77  }
78  
79  void geometric_values_rbf_top(data_matrix_stream &support_vectors,
80    	  	  	  	  	  	  	  sv_coeffs_stream &sv_coeffs,
81  							  data_matrix_stream &testing_matrix,
82  							  dataset_details_stream &classification_details,
83  							  geometric_values_stream &geometric_values_out){
84  #pragma HLS INTERFACE axis port=testing_matrix
85  #pragma HLS INTERFACE axis port=geometric_values_out
86  #pragma HLS INTERFACE axis port=classification_details
87  #pragma HLS INTERFACE axis port=support_vectors
88  #pragma HLS INTERFACE axis port=sv_coeffs
89  #pragma HLS INTERFACE ap_ctrl_none port=return
90  
91  	// Note, the offset is the last element in the sv coeffs stream
92  	// also, the first element is ||w_|| (norm of w)
93  
94  	// dataset_details stream => no_svs -> no_variables -> no_test_vectors -> gamma
95  	// sv_coeffs => norm_w -> all coefficients... -> offset
96  
97  	n_svs no_svs;
98  	n_variables no_variables;
99  	n_test_vectors no_test_vectors;
100 	coeffs gamma;
101 
102 	gamma = sv_coeffs.read().data;
103 
104 	no_svs = ap_uint<20>(classification_details.read().data);
105 	no_variables = ap_uint<9>(classification_details.read().data);
106 	no_test_vectors = ap_uint<20>(classification_details.read().data);
107 
108 	// get norm of weights vector - required to compute geometric value for the testing vector
109 	coeffs norm_w = sv_coeffs.read().data;
110 
111 	// call function to compute geometric values using the default linear kernel
112 	get_geometric_values_rbf(support_vectors,
113 			   	   	   	  	 sv_coeffs,
114 							 testing_matrix,
115 							 &norm_w,
116 						  	 &no_svs,
117 							 &no_variables,
118 							 &no_test_vectors,
119 						  	 &gamma,
120 							 geometric_values_out);
121 
122 }
123 