1  #include "get_dpm.h"
2  
3  dot_products get_dot_product(data_vectors row_vec[n], training_matrix_stream &col_vec, n_variables *no_variables){
4  	// compute dot product between row vector stored in memory and column vector streamed
5  	dot_products accumulator = 0;
6  
7  	dp_loop: for(loop_ind_n n1 = 0; n1 < n; n1++){
8  #pragma HLS PIPELINE
9  		if(n1 < *no_variables){
10 			accumulator = accumulator + row_vec[n1] * col_vec.read().data;
11 		}
12 		else{
13 			break;
14 		}
15 	}
16 
17 	return accumulator;
18 }
19 
20 void get_dpm_top(training_matrix_stream &training_matrix,
21 				 training_matrix_stream &training_matrix_transpose,
22 				 dot_product_matrix_stream &dot_product_matrix_out,
23 				 input_details_stream &input_details){
24 #pragma HLS INTERFACE ap_ctrl_none port=return
25 #pragma HLS INTERFACE axis port=input_details
26 #pragma HLS INTERFACE axis both port=dot_product_matrix_out
27 #pragma HLS INTERFACE axis port=training_matrix_transpose
28 #pragma HLS INTERFACE axis both port=training_matrix
29 	// returns the matrix multiplication between a data matrix and its transpose
30 	// note: this is NOT the covariance of the dataset: i.e. if training matrix A is
31 	// 100k x 256 (100k observations by 256 variables) then the result is A.A^T (100k by 100k)
32 
33 	// also note: the second data matrix is not transposed in terms of the order of the elements
34 	// in standard c multi-dimensional array ordering - this is to allow the matrix multiplication to
35 	// be computed in a streaming fashion
36 
37 	n_training_vectors no_training_vectors = ap_uint<16>(input_details.read().data);
38 	n_variables no_variables = ap_uint<9>(input_details.read().data);
39 
40 	data_vectors first_mat_row[n];
41 
42 	// loop over rows of first data matrix
43 	first_rows: for(loop_ind_m n1 = 0; n1 < m; n1++){
44 		if(n1 < no_training_vectors){
45 
46 			// get row of first matrix (length no_variables) and store in memory
47 			get_row: for(loop_ind_n n1_1 = 0; n1_1 < n; n1_1++){
48 				if(n1_1 < no_variables){
49 					first_mat_row[n1_1] = training_matrix.read().data;
50 				}
51 				else{
52 					break;
53 				}
54 			}
55 
56 			dot_product_matrix_AXIS result;
57 
58 			// loop over 'columns' of second matrix
59 			second_columns: for(loop_ind_m n2 = 0; n2 < m; n2++){
60 				if(n2 < no_training_vectors){
61 					if(n2 < (no_training_vectors-1)){		// up to second last iteration of second columns
62 						result.data = get_dot_product(first_mat_row, training_matrix_transpose, &no_variables);
63 						result.last = 0;
64 						dot_product_matrix_out.write(result);
65 					}
66 					else if(n1 == (no_training_vectors-1)){						// last iteration of second columns AND last iteration of first rows - i.e. end of operations
67 						result.data = get_dot_product(first_mat_row, training_matrix_transpose, &no_variables);
68 						result.last = 1;
69 						dot_product_matrix_out.write(result);
70 						break;
71 					}
72 					else{		// last iteration of second columns but NOT first rows - keep iterating outer loop
73 						result.data = get_dot_product(first_mat_row, training_matrix_transpose, &no_variables);
74 						result.last = 0;
75 						dot_product_matrix_out.write(result);
76 					}
77 				}
78 				else{
79 					break;
80 				}
81 			}
82 		}
83 		else{
84 			break;
85 		}
86 	}
87 
88 }
89 