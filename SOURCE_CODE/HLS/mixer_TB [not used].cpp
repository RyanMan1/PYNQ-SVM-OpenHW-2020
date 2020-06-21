1  #include "mixer.h"
2  #include <iostream>
3  
4  using namespace std;
5  
6  int main(){
7  
8  	geometric_values_stream stream_in_1;
9  	geometric_values_stream stream_in_2;
10 	geometric_values_stream stream_in_3;
11 	geometric_values_stream stream_in_4;
12 	geometric_values_stream stream_in_5;
13 	geometric_values_stream stream_in_6;
14 
15 	geometric_values_AXIS data_in;
16 
17 	data_in.last = 1;
18 
19 	data_in.data = 1;
20 	stream_in_1.write(data_in);
21 
22 	data_in.data = 2;
23 	stream_in_2.write(data_in);
24 
25 	data_in.data = 3;
26 	stream_in_3.write(data_in);
27 
28 	data_in.data = 4;
29 	stream_in_4.write(data_in);
30 
31 	data_in.data = 5;
32 	stream_in_5.write(data_in);
33 
34 	data_in.data = 6;
35 	stream_in_6.write(data_in);
36 
37 	geometric_values_stream stream_out;
38 
39 	mixer_top(stream_in_1, stream_in_2, stream_in_3, stream_in_4, stream_in_5, stream_in_6, stream_out);
40 
41 	for(int i = 0; i < 6; i++){
42 		cout << stream_out.read().data << ", ";
43 	}
44 	cout << "\n";
45 
46 
47 	return 0;
48 }
49 