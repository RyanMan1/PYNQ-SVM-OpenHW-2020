1  #ifndef GET_NORM_W_H__
2  #define GET_NORM_W_H__
3  
4  #include <fstream>
5  #include <iostream>
6  #include <cmath>
7  #include <ap_fixed.h>
8  #include <ap_int.h>
9  
10 #include "hls_stream.h"
11 #include <ap_axi_sdata.h>
12 
13 #define m 1000000	// (per training model) - maximum number of possible training vectors in the dataset (and hence max no of support vectors)
14 #define n 256		// maximum number of possible variables in the dataset
15 
16 typedef ap_fixed<16,1> data_vectors;	// 1 bit for integer component - only work for hs datasets
17 typedef ap_fixed<32,12> coeffs;			// 8 bits for integer component - max value for C is 127
18 typedef ap_fixed<32,8> offsets;
19 
20 typedef ap_uint<20> n_svs;				// max 1 million support vectors
21 typedef ap_uint<9> n_variables;			// max 256 variables
22 
23 typedef ap_uint<20> loop_ind_m;			// loop over support vectors
24 typedef ap_uint<9> loop_ind_n;			// loop over variables - only increment from zero to 255
25 
26 typedef ap_uint<32> ds_details;			// any dataset detail cannot exceed integer 2^(32)-1
27 
28 struct data_matrices_AXIS{
29 	data_vectors data;
30 	bool last;
31 };
32 
33 struct sv_coeffs_AXIS{
34 	coeffs data;
35 	bool last;
36 };
37 
38 struct dataset_details_AXIS{
39 	ds_details data;
40 	bool last;
41 };
42 
43 typedef hls::stream<data_matrices_AXIS> data_matrix_stream;			// for support vectors and testing matrix
44 typedef hls::stream<sv_coeffs_AXIS> sv_coeffs_stream;
45 typedef hls::stream<dataset_details_AXIS> dataset_details_stream;
46 
47 void get_w(data_matrix_stream &data_matrices,
48 		   sv_coeffs_stream &sv_coeffs,
49 		   dataset_details_stream &ds_details_in,
50 		   sv_coeffs_stream &norm_w_out);
51 
52 #endif
53 