1  #ifndef TEST_PREDICTIONS_H__
2  #define TEST_PREDICTIONS_H__
3  
4  #include "ap_axi_sdata.h"
5  #include "hls_stream.h"
6  
7  #include <fstream>
8  #include <iostream>
9  #include <string>
10 #include <cmath>
11 #include <ap_fixed.h>
12 #include <ap_int.h>
13 
14 #define t_max 1000000			// maximum number of testing vectors in dataset
15 #define k 255
16 #define max_classifiers k*(k-1)/2	// maximum number of binary classifiers allowed
17 
18 //typedef int data_labels;
19 typedef ap_uint<8> data_labels;			// only because k is 255 - data labels cannot exceed unsigned integer 255
20 //typedef int n_classes;
21 typedef ap_uint<8> n_classes;
22 typedef ap_uint<20> n_test_vectors;		// max 1 million test vectors
23 
24 //typedef int loop_ind;
25 typedef ap_uint<20> loop_ind_t;			// loop over testing vectors
26 typedef ap_uint<15> loop_ind_c;			// loop pver classes or classifiers
27 
28 //typedef int class_ref;
29 
30 typedef ap_fixed<32,12> inter_values;
31 
32 //typedef int ds_details;
33 typedef ap_uint<32> ds_details;
34 
35 // the struct is used for defining the data type for the input axi stream (geometric_values) and specifying the "TLAST"
36 // sideband signal should be used
37 struct geometric_values_AXIS{
38 	inter_values data;
39 	bool last;
40 };
41 
42 typedef hls::stream<geometric_values_AXIS> geometric_values_stream;
43 
44 // the struct is used for defining the data type for the output axi stream (test_predictions) and specifying the "TLAST"
45 // sideband signal should be used
46 struct test_predictions_AXIS{
47 	data_labels data;
48 	bool last;
49 };
50 
51 typedef hls::stream<test_predictions_AXIS> test_predictions_stream;
52 
53 struct dataset_details_AXIS{
54 	ds_details data;
55 	bool last;
56 };
57 
58 typedef hls::stream<dataset_details_AXIS> dataset_details_stream;
59 
60 void test_predictions(geometric_values_stream &geometric_values,
61 					  n_classes *no_classes,
62 					  n_test_vectors *no_test_vectors,
63 					  test_predictions_stream &test_predictions);
64 
65 void test_predictions_top(geometric_values_stream &geometric_values,
66 					  	  dataset_details_stream &dataset_details,
67 						  test_predictions_stream &test_predictions);
68 
69 #endif
70 