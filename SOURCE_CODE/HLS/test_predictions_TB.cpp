1   #include "test_predictions.h"
2   
3   using namespace std;
4   
5   void get_dataset_details(inter_values dataset_details[3]){
6   	// return the 3 values relating to the dataset
7   	// number of variables
8   	// number of classes
9   	// number of testing vectors
10  	ifstream data_in;
11  	data_in.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/ds_details.dat");
12  	for(int i = 0; i < 3; i++){
13  		data_in >> dataset_details[i];
14  	}
15  	data_in.close();
16  }
17  
18  void read_test_predictions(data_labels testing_predictions_libsvm[t_max], n_test_vectors no_test_vectors){
19  	// read from dat file and populate C++ variables
20  	ifstream predictions_data;
21  	predictions_data.open("C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/test_predictions_libsvm.dat");
22  
23  	for(int i = 0; i < no_test_vectors; i++){
24  		float test_prediction = 0.0;
25  		predictions_data >> test_prediction;
26  		testing_predictions_libsvm[i] = data_labels(test_prediction);
27  	}
28  	predictions_data.close();
29  }
30  
31  void read_geometric_values(geometric_values_stream &geometric_values_in, n_classes no_classes, n_test_vectors no_test_vectors){
32  	int no_classes_int = no_classes.to_int();
33  	int no_test_vectors_int = no_test_vectors.to_int();
34  
35  	int no_classifiers = no_classes * (no_classes - 1) / 2;
36  
37  	geometric_values_AXIS geometric_values[no_test_vectors_int][no_classifiers];
38  
39  	for(int i = 0; i < no_classifiers; i++){
40  		ifstream geo_values_data;
41  		std::string file_path = "C:/Users/Ryan/Documents/University/Project/MATLAB/Test Project/data_files_small/";
42  		std::string file_ext = ".dat";
43  		std::string filename = file_path + "geometric_values_" + to_string(i+1) + file_ext;
44  		geo_values_data.open(filename);
45  		for(int j = 0; j < no_test_vectors_int; j++){
46  			geo_values_data >> geometric_values[j][i].data;
47  			geometric_values[j][i].last = 0;
48  		}
49  	}
50  
51  	// indicate last elemtn in stream
52  	geometric_values[no_test_vectors_int - 1][no_classifiers - 1].last = 1;
53  
54  	for(int i = 0; i < no_test_vectors_int; i++){
55  		for(int j = 0; j < no_classifiers; j++){
56  			geometric_values_in.write(geometric_values[i][j]);
57  		}
58  	}
59  
60  }
61  
62  int main(){
63  	// READ IN DETAILS FOR THE DATASET
64  	inter_values dataset_details[3];
65  	get_dataset_details(dataset_details);
66  	n_classes no_test_vectors = dataset_details[1];
67  	n_test_vectors no_classes = dataset_details[2];
68  
69  	data_labels test_predictions_actual[t_max];
70  
71  	read_test_predictions(test_predictions_actual, no_test_vectors);
72  
73  	//geometric_values_AXIS geometric_values[t_max][max_classifiers];
74  	geometric_values_stream geometric_values_in;
75  
76  	read_geometric_values(geometric_values_in, no_classes, no_test_vectors);
77  
78  	test_predictions_stream test_predictions_out;
79  
80  	// generate stream for dataset details
81  	dataset_details_stream dataset_details_in;
82  
83  	dataset_details_AXIS ds_details_AXIS;
84  	ds_details_AXIS.data = no_classes;
85  	ds_details_AXIS.last = 0;
86  
87  	dataset_details_in.write(ds_details_AXIS);
88  
89  	ds_details_AXIS.data = no_test_vectors;
90  	ds_details_AXIS.last = 1;
91  
92  	dataset_details_in.write(ds_details_AXIS);
93  
94  	// call top-level funtcion
95  	test_predictions_top(geometric_values_in, dataset_details_in, test_predictions_out);
96  
97  	int error_count = 0;
98  
99  	data_labels test_prediction;
100 	// print test predictions to console
101 	for(int i = 0; i < no_test_vectors; i++){
102 		test_prediction = test_predictions_out.read().data;
103 		cout << test_prediction << "\n";
104 		if(test_prediction != test_predictions_actual[i]){
105 			error_count++;
106 		}
107 	}
108 
109 	if(error_count > 0){
110 		return 1;
111 	}
112 	else{
113 		return 0;			// pass cosim
114 	}
115 }
116 