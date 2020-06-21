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
19  typedef ap_fixed<16,1> data_vectors;	// 1 bit for integer component - only work for hs datasets
20  //typedef float coeffs;
21  typedef ap_fixed<32,12> coeffs;			// 8 bits for integer component - max value for C is 127
22  //typedef int n_svs;
23  //typedef int n_variables;
24  typedef int n_classes;
25  //typedef int n_test_vectors;
26  typedef int data_labels;
27  
28  typedef ap_uint<20> n_svs;				// max 1 million support vectors
29  typedef ap_uint<9> n_variables;			// max 256 variables
30  typedef ap_uint<20> n_test_vectors;		// max 1 million testing vectors
31  
32  //typedef float offsets;
33  typedef ap_fixed<32,8> offsets;
34  
35  //typedef int loop_ind;
36  typedef ap_uint<20> loop_ind_m;			// loop over support vectors
37  typedef ap_uint<9> loop_ind_n;			// loop over variables - only increment from zero to 255
38  typedef ap_uint<20> loop_ind_t;			// loop over testing vectors
39  
40  //typedef int ds_details;
41  typedef ap_uint<32> ds_details;			// any dataset detail cannot exceed integer 2^(32)-1
42  
43  typedef ap_fixed<32,12> inter_values;	// 12 bits for integer component - in 256 dimensional feature-space, geometric values may not exceed 32
44  //typedef float inter_values;
45  //typedef int test_vec_indices;
46  //typedef int sv_indices;
47  typedef float kernel_param;
48  //typedef ap_fixed<48,24> kernel_param;
49  
50  // structs contain the sideband signal TLAST which must be set when the stream has completed
51  /*struct support_vectors_AXIS{
52  	data_vectors data;
53  	bool last;
54  };
55  
56  struct testing_matrix_AXIS{
57  	data_vectors data;
58  	bool last;
59  };*/
60  
61  struct data_matrices_AXIS{
62  	data_vectors data;
63  	bool last;
64  };
65  
66  struct sv_coeffs_AXIS{
67  	coeffs data;
68  	bool last;
69  };
70  
71  struct dataset_details_AXIS{
72  	ds_details data;
73  	bool last;
74  };
75  
76  // output AXI stream - geometric values
77  struct geometric_values_AXIS{
78  	inter_values data;
79  	bool last;
80  };
81  
82  // the following type is used for the axi streams - hls_stream facilitates correct use of the stream in the c++ code
83  //typedef hls::stream<support_vectors_AXIS> support_vectors_stream;
84  //typedef hls::stream<testing_matrix_AXIS> testing_matrix_stream;
85  typedef hls::stream<data_matrices_AXIS> data_matrix_stream;			// for support vectors and testing matrix
86  typedef hls::stream<sv_coeffs_AXIS> sv_coeffs_stream;
87  typedef hls::stream<dataset_details_AXIS> dataset_details_stream;
88  typedef hls::stream<geometric_values_AXIS> geometric_values_stream;
89  
90  coeffs get_w(data_matrix_stream &data_matrices,
91  			 sv_coeffs_stream &sv_coeffs,
92  			 n_svs *no_svs,
93  			 n_variables *no_variables,
94  			 coeffs w[n]);
95  
96  void get_geometric_values_linear(data_matrix_stream &data_matrices,
97  								 sv_coeffs_stream &sv_coeffs,
98  								 n_svs *no_svs,
99  								 n_variables *no_variables,
100 								 n_test_vectors *no_test_vectors,
101 								 geometric_values_stream &geometric_values);
102 
103 void geometric_values_top(data_matrix_stream &data_matrices,
104 						  sv_coeffs_stream &sv_coeffs,
105 						  dataset_details_stream &dataset_details,
106 						  geometric_values_stream &geometric_values);
107 
108 #endif
109 