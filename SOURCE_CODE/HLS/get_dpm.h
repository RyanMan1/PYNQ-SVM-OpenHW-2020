1  #ifndef GET_DPM_H__
2  #define GET_DPM_H__
3  
4  #include <cmath>
5  #include <math.h>
6  #include <ap_fixed.h>
7  #include <ap_int.h>
8  
9  #include "hls_stream.h"
10 #include <ap_axi_sdata.h>
11 
12 #define m 200	// maximum number of possible training vectors in the dataset
13 #define n 256		// maximum number of possible variables in the dataset
14 
15 typedef ap_uint<16> n_training_vectors;		// maximum of 65535 training vectors (per binary classifier)
16 typedef ap_uint<9> n_variables;				// max 256 variables
17 typedef ap_uint<16> loop_ind_m;			// loop over training vectors
18 typedef ap_uint<9> loop_ind_n;			// loop over variables - only increment from zero to 255
19 
20 typedef ap_fixed<16,1> data_vectors;	// 1 bit for integer component - only work for hs datasets
21 typedef ap_fixed<32,12> dot_products;
22 
23 // structs contain the sideband signal TLAST which must be set when the stream has completed
24 struct dot_product_matrix_AXIS{
25 	dot_products data;
26 	bool last;
27 };
28 
29 struct training_matrix_AXIS{
30 	data_vectors data;
31 	bool last;
32 };
33 
34 struct input_details_AXIS{
35 	ap_uint<16> data;
36 	bool last;
37 };
38 
39 // HLS stream types
40 typedef hls::stream<dot_product_matrix_AXIS> dot_product_matrix_stream;
41 typedef hls::stream<training_matrix_AXIS> training_matrix_stream;
42 typedef hls::stream<input_details_AXIS> input_details_stream;
43 
44 dot_products get_dot_product(data_vectors row_vec[m], training_matrix_stream &col_vec, n_variables *no_variables);
45 
46 void get_dpm_top(training_matrix_stream &training_matrix,
47 				 training_matrix_stream &training_matrix_transpose,
48 				 dot_product_matrix_stream &dot_product_matrix_out,
49 				 input_details_stream &input_details);
50 
51 #endif
52 