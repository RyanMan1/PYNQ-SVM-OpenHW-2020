1   #ifndef GEOMETRIC_VALUES_H__
2   #define GEOMETRIC_VALUES_H__
3   
4   #include <fstream>
5   #include <iostream>
6   #include <cmath>
7   #include <ap_fixed.h>
8   #include <ap_int.h>
9   
10  #include "hls_stream.h"
11  #include <ap_axi_sdata.h>
12  
13  #define m 1000000	// (per training model) - maximum number of possible training vectors in the dataset (and hence max no of support vectors)
14  #define n 256		// maximum number of possible variables in the dataset
15  #define t_max 1000000				// maximum number of testing vectors in dataset
16  
17  // type definitions
18  //typedef float data_vectors;
19  //typedef ap_fixed<16,1> data_vectors;	// 1 bit for integer component - only work for hs datasets
20  typedef ap_fixed<16,1> data_vectors;	// 1 bit for integer component - only work for hs datasets
21  
22  //typedef float coeffs;
23  typedef ap_fixed<32,12> coeffs;			// 12 bits for integer			8 bits for integer component - max value for C is 127
24  //typedef int n_svs;
25  //typedef int n_variables;
26  typedef int n_classes;
27  //typedef int n_test_vectors;
28  typedef int data_labels;
29  
30  typedef ap_uint<20> n_svs;				// max 1 million support vectors
31  typedef ap_uint<9> n_variables;			// max 256 variables
32  typedef ap_uint<20> n_test_vectors;		// max 1 million testing vectors
33  
34  //typedef float offsets;
35  typedef ap_fixed<32,8> offsets;
36  
37  //typedef int loop_ind;
38  typedef ap_uint<20> loop_ind_m;			// loop over support vectors
39  typedef ap_uint<9> loop_ind_n;			// loop over variables - only increment from zero to 255
40  typedef ap_uint<20> loop_ind_t;			// loop over testing vectors
41  
42  //typedef int ds_details;
43  //typedef ap_ufixed<32,20> ds_details;	// maximum size of integer - 1 million
44  typedef ap_uint<32> ds_details;
45  
46  typedef ap_fixed<32,12> inter_values;	// 12 bits for integer component - in 256 dimensional feature-space, geometric values may not exceed 32
47  //typedef float inter_values;
48  //typedef int test_vec_indices;
49  //typedef int sv_indices;
50  typedef float kernel_param;
51  //typedef ap_fixed<48,24> kernel_param;
52  
53  // structs contain the sideband signal TLAST which must be set when the stream has completed
54  /*struct support_vectors_AXIS{
55  	data_vectors data;
56  	bool last;
57  };
58  
59  struct testing_matrix_AXIS{
60  	data_vectors data;
61  	bool last;
62  };*/
63  
64  struct data_matrices_AXIS{
65  	data_vectors data;
66  	bool last;
67  };
68  
69  struct sv_coeffs_AXIS{
70  	coeffs data;
71  	bool last;
72  };
73  
74  struct dataset_details_AXIS{
75  	ds_details data;
76  	bool last;
77  };
78  
79  // output AXI stream - geometric values
80  struct geometric_values_AXIS{
81  	inter_values data;
82  	bool last;
83  };
84  
85  // the following type is used for the axi streams - hls_stream facilitates correct use of the stream in the c++ code
86  //typedef hls::stream<support_vectors_AXIS> support_vectors_stream;
87  //typedef hls::stream<testing_matrix_AXIS> testing_matrix_stream;
88  typedef hls::stream<data_matrices_AXIS> data_matrix_stream;			// for support vectors and testing matrix
89  typedef hls::stream<sv_coeffs_AXIS> sv_coeffs_stream;
90  typedef hls::stream<dataset_details_AXIS> dataset_details_stream;
91  typedef hls::stream<geometric_values_AXIS> geometric_values_stream;
92  
93  inter_values kernel_rbf(data_matrix_stream &support_vectors, data_vectors vector_2[n], n_variables *no_variables, coeffs *gamma);
94  
95  void get_geometric_values_rbf(data_matrix_stream &support_vectors,
96  							  sv_coeffs_stream &sv_coeffs,
97  							  data_matrix_stream &testing_matrix,
98  							  coeffs *norm_w,
99  							  n_svs *no_svs,
100 							  n_variables *no_variables,
101 							  n_test_vectors *no_test_vectors,
102 							  coeffs *gamma,
103 							  geometric_values_stream &geometric_values_out);
104 
105 void geometric_values_rbf_top(data_matrix_stream &support_vectors,
106 						  	  sv_coeffs_stream &sv_coeffs,
107 							  data_matrix_stream &testing_matrix,
108 							  dataset_details_stream &classification_details,
109 							  geometric_values_stream &geometric_values_out);
110 
111 #endif
112 