1  #include "mixer.h"
2  
3  void mixer_top(geometric_values_stream &stream_in_1,
4  			   geometric_values_stream &stream_in_2,
5  			   geometric_values_stream &stream_in_3,
6  			   geometric_values_stream &stream_in_4,
7  			   geometric_values_stream &stream_in_5,
8  			   geometric_values_stream &stream_in_6,
9  			   geometric_values_stream &stream_out){
10 #pragma HLS INTERFACE ap_ctrl_none port=return
11 #pragma HLS INTERFACE axis port=stream_in_1
12 #pragma HLS INTERFACE axis port=stream_in_2
13 #pragma HLS INTERFACE axis port=stream_in_3
14 #pragma HLS INTERFACE axis port=stream_in_4
15 #pragma HLS INTERFACE axis port=stream_in_5
16 #pragma HLS INTERFACE axis port=stream_in_6
17 #pragma HLS INTERFACE axis port=stream_out
18 
19 	// the output stream is created by combining the elements of the input streams
20 	// in sequence
21 	stream_out.write(stream_in_1.read());
22 	stream_out.write(stream_in_2.read());
23 	stream_out.write(stream_in_3.read());
24 	stream_out.write(stream_in_4.read());
25 	stream_out.write(stream_in_5.read());
26 	stream_out.write(stream_in_6.read());
27 
28 }
29 