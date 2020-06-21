1  #ifndef MIXER_H__
2  #define MIXER_H__
3  
4  #include <ap_fixed.h>
5  #include <ap_int.h>
6  
7  #include "hls_stream.h"
8  
9  typedef ap_fixed<32,12> inter_values;
10 
11 struct geometric_values_AXIS{
12 	inter_values data;
13 	bool last;
14 };
15 
16 typedef hls::stream<geometric_values_AXIS> geometric_values_stream;
17 
18 void mixer_top(geometric_values_stream &stream_in_1,
19 			   geometric_values_stream &stream_in_2,
20 			   geometric_values_stream &stream_in_3,
21 			   geometric_values_stream &stream_in_4,
22 			   geometric_values_stream &stream_in_5,
23 			   geometric_values_stream &stream_in_6,
24 			   geometric_values_stream &stream_out);
25 
26 #endif
27 