1   #ifndef SMO_H__
2   #define SMO_H__
3   
4   #include <cmath>
5   #include <math.h>
6   #include <ap_fixed.h>
7   #include <ap_int.h>
8   
9   #include "hls_stream.h"
10  #include <ap_axi_sdata.h>
11  
12  #define m 20000	// maximum number of possible training vectors in the dataset
13  #define n 256		// maximum number of possible variables in the dataset
14  #define max_itr_abs 100 // absolute maximum number of iterations
15  
16  //typedef float data_vectors;
17  typedef ap_fixed<16,1> data_vectors;	// 1 bit for integer component - only work for hs datasets
18  
19  //typedef float dot_products;
20  typedef ap_fixed<32,12> dot_products;
21  
22  //typedef int class_labels;
23  typedef ap_int<2> class_labels;			// only stores values of -1 and 1 - two bits signed integer required
24  
25  //typedef int training_data_indices;
26  typedef ap_uint<16> training_data_indices;	// maximum of 65535 training vectors
27  
28  //typedef int n_training_vectors;
29  typedef ap_uint<16> n_training_vectors;		// maximum of 65535 training vectors (per binary classifier)
30  
31  //typedef int n_variables;
32  //typedef int n_variables;
33  typedef ap_uint<9> n_variables;				// max 256 variables
34  
35  typedef ap_uint<8> n_max_itr;					// max 255 iteration
36  
37  //typedef float training_details;
38  typedef ap_fixed<32,12> training_details;	// 12 bits for integer component - max value of C and offset is 4095
39  
40  //typedef float inter_values;
41  typedef ap_fixed<32,12> inter_values;
42  
43  //typedef float alphas;
44  typedef ap_fixed<32,12> alphas;
45  
46  //typedef int loop_ind;
47  typedef ap_uint<16> loop_ind_m;			// loop over training vectors
48  typedef ap_uint<9> loop_ind_n;			// loop over variables - only increment from zero to 255
49  typedef ap_uint<8> loop_ind_itr;
50  
51  // structs contain the sideband signal TLAST which must be set when the stream has completed
52  struct dot_product_matrix_AXIS{
53  	dot_products data;
54  	bool last;
55  };
56  
57  struct training_labels_AXIS{
58  	ap_int<8> data;
59  	bool last;
60  };
61  
62  struct training_matrix_AXIS{
63  	data_vectors data;
64  	bool last;
65  };
66  
67  struct scalars_AXIS{
68  	training_details data;
69  	bool last;
70  };
71  
72  struct input_details_AXIS{
73  	float data;
74  	bool last;
75  };
76  // this needs to contain floats => no_training_vectors -> no_variables -> C -> tolerance -> offset -> Ep -> p
77  // this contains offset -> changed_alphas for output
78  
79  struct alphas_AXIS{
80  	alphas data;
81  	bool last;
82  };
83  
84  struct indicators_AXIS{
85  	ap_uint<8> data;
86  	bool last;
87  };
88  
89  // HLS stream types
90  typedef hls::stream<dot_product_matrix_AXIS> dot_product_matrix_stream;
91  typedef hls::stream<training_labels_AXIS> training_labels_stream;
92  typedef hls::stream<training_matrix_AXIS> training_matrix_stream;
93  typedef hls::stream<scalars_AXIS> scalars_stream;
94  typedef hls::stream<alphas_AXIS> alphas_stream;
95  typedef hls::stream<scalars_AXIS> offset_stream;
96  typedef hls::stream<indicators_AXIS> indicators_stream;
97  typedef hls::stream<input_details_AXIS> input_details_stream;
98  
99  
100 dot_products dot_product(data_vectors row_vec[n], data_vectors col_vec[n], n_variables *no_variables);
101 
102 void get_training_vector(training_matrix_stream &training_matrix,
103 						 data_vectors x_q,
104 						 n_variables *no_variables);
105 
106 inter_values get_u_k(dot_product_matrix_stream &dot_product_matrix,
107 		   	 	 	 class_labels y[m],
108 					 alphas_AXIS alpha[m],
109 					 n_training_vectors *no_training_vectors,
110 					 n_variables *no_variables,
111 					 training_details *offset);
112 
113 void SMO_p_loop_linear(dot_product_matrix_stream &dot_product_matrix,
114 					   training_matrix_stream &training_matrix,
115 					   data_vectors x_p[n],
116 					   class_labels y[m],
117 					   alphas_AXIS alpha[m],
118 					   n_training_vectors *no_training_vectors,
119 					   n_variables *no_variables,
120 					   training_details *C,
121 					   training_details *tolerance,
122 					   training_details *offset,
123 					   inter_values *E_p,
124 					   training_data_indices *p_in,
125 					   n_training_vectors *changed_alphas);
126 
127 void SMO_outer(dot_product_matrix_stream &dot_product_matrix_outer,
128 		 	   dot_product_matrix_stream &dot_product_matrices_inner,
129 			   class_labels y[m],
130 			   training_matrix_stream &training_matrix_outer,
131 			   training_matrix_stream &training_matrices_inner,
132 			   alphas_AXIS alpha[m],
133 			   n_training_vectors *no_training_vectors,
134 			   n_variables *no_variables,
135 			   training_details *C,
136 			   training_details *tolerance,
137 			   n_max_itr *max_itr_user,
138 			   indicators_stream &kkt_violations,
139 			   scalars_stream &output_details);
140 
141 void SMO_top(dot_product_matrix_stream &dot_product_matrix_outer,
142 			 dot_product_matrix_stream &dot_product_matrices_inner,
143 			 training_labels_stream &training_labels_in,
144 			 training_matrix_stream &training_matrix_outer,
145 			 training_matrix_stream &training_matrices_inner,
146 			 input_details_stream &input_details,
147 			 alphas_stream &alpha_out,
148 			 indicators_stream &kkt_violations,
149 			 scalars_stream &output_details);
150 
151 #endif
152 