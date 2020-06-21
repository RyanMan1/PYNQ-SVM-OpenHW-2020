1  #include "test_predictions.h"
2  
3  void test_predictions(geometric_values_stream &geometric_values,
4  					  n_classes *no_classes,
5  					  n_test_vectors *no_test_vectors,
6  					  test_predictions_stream &test_predictions_out){
7  
8  	// loop over the testing vectors
9  	test_predict_outer_loop: for(loop_ind_t n1 = 0; n1 < t_max; n1++){
10 		if(n1 < *no_test_vectors){
11 
12 			// initialise class instances:
13 			data_labels class_instances[k];
14 			for(loop_ind_c n2_1 = 0; n2_1 < k; n2_1++){
15 				class_instances[n2_1] = 0;
16 			}
17 			//data_labels class_instances[k] = {0};	// maximum number of classes is 255
18 			ap_uint<15> current_classifier = 1;	// keep track of classifier
19 
20 			// loop over the classifiers - n2 is positive class, n3 is negative class
21 			for(loop_ind_c n2 = 0; n2 < (k-1); n2++){
22 				if(n2 < *no_classes){
23 					test_predict_inner_loop: for(loop_ind_c n3 = 0; n3 < k; n3++){
24 #pragma HLS PIPELINE
25 						if((n3 < *no_classes) && (n3 > n2)){
26 							// if geometric value positive for that classifier, positive class chosen - else negative class chosen
27 							if(geometric_values.read().data >= 0.0){
28 								class_instances[n2] = class_instances[n2] + 1;
29 							}
30 							else{
31 								class_instances[n3] = class_instances[n3] + 1;
32 							}
33 							current_classifier++;
34 						}
35 					}
36 				}
37 				else{
38 					break;
39 				}
40 			}
41 
42 			// check for maximum value in class_instances - this location corresponds to chosen class for the testing vector
43 			data_labels current_prediction = 1;
44 			data_labels current_max_instances = class_instances[0];
45 			prediction_loop: for(loop_ind_c n2 = 1; n2 < (k+1); n2++){
46 #pragma HLS PIPELINE
47 				if(class_instances[n2] > current_max_instances){
48 					current_prediction = n2 + 1;
49 					current_max_instances = class_instances[n2];
50 				}
51 			}
52 
53 			// declare struct instance for axi stream with TLAST sideband signal
54 			test_predictions_AXIS test_prediction;
55 			test_prediction.data = current_prediction;
56 
57 			// check are we at end of stream
58 			if(n1 < (*no_test_vectors - 1)){
59 				test_prediction.last = 0;
60 			}
61 			else{
62 				test_prediction.last = 1;
63 			}
64 
65 			// send output to stream
66 			test_predictions_out.write(test_prediction);
67 		}
68 	}
69 
70 }
71 
72 void test_predictions_top(geometric_values_stream &geometric_values,
73 		  	  	  	  	  dataset_details_stream &dataset_details,
74 						  test_predictions_stream &test_predictions_out){
75 #pragma HLS INTERFACE axis port=dataset_details
76 #pragma HLS INTERFACE axis port=test_predictions_out
77 #pragma HLS INTERFACE axis port=geometric_values
78 #pragma HLS INTERFACE ap_ctrl_none port=return
79 
80 	// dataset details is no_classes -> no_test_vectors
81 
82 	n_classes no_classes;
83 	n_test_vectors no_test_vectors;
84 
85 	no_classes = ap_uint<8>(dataset_details.read().data);
86 	no_test_vectors = ap_uint<20>(dataset_details.read().data);
87 
88 	// this function uses the computed geometric values and returns a 2D array of predictions
89 	// the class label is for each testing vector from [1,k(k-1)/2]
90 	test_predictions(geometric_values, &no_classes, &no_test_vectors, test_predictions_out);
91 
92 }
93 