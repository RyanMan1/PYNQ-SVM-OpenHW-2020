1  #include "get_norm_w.h"
2  
3  void get_w(data_matrix_stream &data_matrices,
4  		   sv_coeffs_stream &sv_coeffs,
5  		   dataset_details_stream &ds_details_in,
6  		   sv_coeffs_stream &norm_w_out){
7  #pragma HLS INTERFACE ap_ctrl_none port=return
8  #pragma HLS INTERFACE axis port=norm_w_out
9  #pragma HLS INTERFACE axis port=ds_details_in
10 #pragma HLS INTERFACE axis port=sv_coeffs
11 #pragma HLS INTERFACE axis port=data_matrices
12 
13 	// get the no_svs and no_variables from stream
14 	n_svs no_svs;
15 	n_variables no_variables;
16 
17 	// read dataset details stream and store as scalars
18 	no_svs = ap_uint<20>(ds_details_in.read().data);
19 	no_variables = ap_uint<9>(ds_details_in.read().data);
20 
21 	// returns the weights vector and its norm - weights vector w[n] in arguments list (pointer)
22 	coeffs norm_w = 0;
23 
24 	coeffs w[n];
25 
26 	for(loop_ind_n n1 = 0; n1 < n; n1++){
27 		w[n1] = 0;							// array initialise to zero
28 	}
29 
30 	// compute the weights vector, w
31 	for(loop_ind_m n1 = 0; n1 < m; n1++){
32 		if(n1 < no_svs){
33 			//data_vectors coeff_in = sv_coeffs.read().data;
34 			//coeffs current_coeff = coeff_in.to_float();	// get support vector coefficient
35 			coeffs current_coeff = sv_coeffs.read().data;
36 
37 			for(loop_ind_n n2 = 0; n2 < n; n2++){
38 #pragma HLS PIPELINE
39 				if(n2 < no_variables){
40 					// only read the actual array sizes - in PS, pass the correct array size to stream:
41 					w[n2] = w[n2] + current_coeff * data_matrices.read().data;	// accessed sequentially - in C++, arrays arranged along columns then down rows in memory
42 				}
43 				else{
44 					break;
45 				}
46 			}
47 		}
48 		else{
49 			break;
50 		}
51 	}
52 
53 	// compute the norm of w, ||w|| - square norm is computed then square root it
54 	coeffs square_norm = 0;
55 	for(loop_ind_n n3 = 0; n3 < n; n3++){
56 #pragma HLS PIPELINE
57 		if(n3 < no_variables){
58 			square_norm = square_norm + w[n3] * w[n3];
59 		}
60 		else{
61 			break;
62 		}
63 	}
64 	norm_w = coeffs(sqrt(square_norm.to_float()));			// use to_float() to convert ap_fixed to float
65 
66 	sv_coeffs_AXIS norm_w_AXIS;
67 	norm_w_AXIS.data = norm_w;
68 	norm_w_AXIS.last = 1;
69 	norm_w_out.write(norm_w_AXIS);
70 
71 }
72 