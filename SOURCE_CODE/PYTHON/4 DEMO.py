1   import numpy as np
2   
3   training_mat_data = get_training_matrix()
4   training_plot_data = np.transpose(np.reshape(training_mat_data,(150,3)))
5   training_plot_data_new = training_plot_data.tolist()
6   
7   #%matplotlib inline
8   %matplotlib notebook
9   
10  from mpl_toolkits import mplot3d
11  
12  import math
13  
14  import matplotlib.pyplot as plt
15  
16  fig = plt.figure()
17  #ax = plt.axes(projection='3d')
18  #ax = fig.add_subplot(111, projection='3d')
19  ax = fig.gca(projection='3d')
20  
21  training_plot_data_x_1 = [float(i) for i in training_plot_data_new[0][0:50]]
22  training_plot_data_y_1 = [float(i) for i in training_plot_data_new[0][50:100]]
23  training_plot_data_z_1 = [float(i) for i in training_plot_data_new[0][100:150]]
24  
25  training_plot_data_x_2 = [float(i) for i in training_plot_data_new[1][0:50]]
26  training_plot_data_y_2 = [float(i) for i in training_plot_data_new[1][50:100]]
27  training_plot_data_z_2 = [float(i) for i in training_plot_data_new[1][100:150]]
28  
29  training_plot_data_x_3 = [float(i) for i in training_plot_data_new[2][0:50]]
30  training_plot_data_y_3 = [float(i) for i in training_plot_data_new[2][50:100]]
31  training_plot_data_z_3 = [float(i) for i in training_plot_data_new[2][100:150]]
32  
33  ax.scatter(training_plot_data_x_1, training_plot_data_y_1, training_plot_data_z_1, c='red', s=1, alpha=1)
34  ax.scatter(training_plot_data_x_2, training_plot_data_y_2, training_plot_data_z_2, c='blue', s=1, alpha=1)
35  ax.scatter(training_plot_data_x_3, training_plot_data_y_3, training_plot_data_z_3, c='green', s=1, alpha=1)
36  
37  
38  ax.set_xlabel('1st principle component')
39  ax.set_ylabel('2nd principle component')
40  ax.set_zlabel('3rd principle component')
41  
42  plt.show()
43  
44  # GET HYPERPLANE WEIGHTS
45  
46  # 1)
47  
48  classifier_select = 1
49  coeffs_1 = []
50  indices_1 = []
51  
52  offset_1 = SMO_driver_inst.fixed_point_to_float(int(SMO_driver_inst.offsets[classifier_select-1]),32,12)
53  
54  for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
55      coeffs_1.append(SMO_driver_inst.fixed_point_to_float(int(SMO_driver_inst.sv_coeffs[classifier_select-1][loop]),32,12))
56  
57  for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
58      indices_1.append(SMO_driver_inst.sv_indices[classifier_select-1][loop])
59      
60  svs_write = np.reshape(SMO_driver_inst.training_mat_data_fi_uint16,((int(len(SMO_driver_inst.training_mat_data_fi_uint16)/SMO_driver_inst.no_variables_int),SMO_driver_inst.no_variables_int)))
61  svs_write = svs_write[indices_1]
62  
63  svs_1 = np.zeros(shape=(50,3),dtype=np.float32)
64  
65  for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])): 
66      for loop_2 in range(SMO_driver_inst.no_variables_int):
67          svs_1[loop][loop_2] = SMO_driver_inst.fixed_point_to_float(int(svs_write[loop][loop_2]),16,1)
68      
69  # 2)
70  
71  classifier_select = 2
72  coeffs_2 = []
73  indices_2 = []
74  
75  offset_2 = SMO_driver_inst.fixed_point_to_float(int(SMO_driver_inst.offsets[classifier_select-1]),32,12)
76  
77  for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
78      coeffs_2.append(SMO_driver_inst.fixed_point_to_float(int(SMO_driver_inst.sv_coeffs[classifier_select-1][loop]),32,12))
79  
80  for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
81      indices_2.append(SMO_driver_inst.sv_indices[classifier_select-1][loop])
82  
83  svs_write = np.reshape(SMO_driver_inst.training_mat_data_fi_uint16,((int(len(SMO_driver_inst.training_mat_data_fi_uint16)/SMO_driver_inst.no_variables_int),SMO_driver_inst.no_variables_int)))
84  svs_write = svs_write[indices_2]
85  
86  svs_2 = np.zeros(shape=(50,3),dtype=np.float32)
87  
88  for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])): 
89      for loop_2 in range(SMO_driver_inst.no_variables_int):
90          svs_2[loop][loop_2] = SMO_driver_inst.fixed_point_to_float(int(svs_write[loop][loop_2]),16,1)
91  
92  # 3)
93  
94  classifier_select = 3
95  coeffs_3 = []
96  indices_3 = []
97  
98  offset_3 = SMO_driver_inst.fixed_point_to_float(int(SMO_driver_inst.offsets[classifier_select-1]),32,12)
99  
100 for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
101     coeffs_3.append(SMO_driver_inst.fixed_point_to_float(int(SMO_driver_inst.sv_coeffs[classifier_select-1][loop]),32,12))
102 
103 for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
104     indices_3.append(SMO_driver_inst.sv_indices[classifier_select-1][loop])
105     
106 svs_write = np.reshape(SMO_driver_inst.training_mat_data_fi_uint16,((int(len(SMO_driver_inst.training_mat_data_fi_uint16)/SMO_driver_inst.no_variables_int),SMO_driver_inst.no_variables_int)))
107 svs_write = svs_write[indices_3]
108 
109 svs_3 = np.zeros(shape=(50,3),dtype=np.float32)
110 
111 for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])): 
112     for loop_2 in range(SMO_driver_inst.no_variables_int):
113         svs_3[loop][loop_2] = SMO_driver_inst.fixed_point_to_float(int(svs_write[loop][loop_2]),16,1)
114 
115 classifier_select = 1
116 weights_1 = [0,0,0]
117 
118 for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
119     weights_1 = weights_1 + coeffs_1[loop] * svs_1[loop]
120     
121 classifier_select = 2
122 weights_2 = [0,0,0]
123 
124 for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
125     weights_2 = weights_2 + coeffs_2[loop] * svs_2[loop]
126     
127 classifier_select = 3
128 weights_3 = [0,0,0]
129 
130 for loop in range(len(SMO_driver_inst.sv_coeffs[classifier_select-1])):
131     weights_3 = weights_3 + coeffs_3[loop] * svs_3[loop]
132 	
133 x = np.arange(-1, 1, 0.5)
134 y = np.arange(-1, 1, 0.5)
135 
136 #XX, YY = np.meshgrid(range(-1), range(1))
137 XX, YY = np.meshgrid(x,y)
138 
139 fig = plt.figure()
140 #ax = plt.axes(projection='3d')
141 #ax = fig.add_subplot(111, projection='3d')
142 ax = fig.gca(projection='3d')
143 
144 training_plot_data_x_1 = [float(i) for i in training_plot_data_new[0][0:50]]
145 training_plot_data_y_1 = [float(i) for i in training_plot_data_new[0][50:100]]
146 training_plot_data_z_1 = [float(i) for i in training_plot_data_new[0][100:150]]
147 
148 training_plot_data_x_2 = [float(i) for i in training_plot_data_new[1][0:50]]
149 training_plot_data_y_2 = [float(i) for i in training_plot_data_new[1][50:100]]
150 training_plot_data_z_2 = [float(i) for i in training_plot_data_new[1][100:150]]
151 
152 training_plot_data_x_3 = [float(i) for i in training_plot_data_new[2][0:50]]
153 training_plot_data_y_3 = [float(i) for i in training_plot_data_new[2][50:100]]
154 training_plot_data_z_3 = [float(i) for i in training_plot_data_new[2][100:150]]
155 
156 ax.scatter(training_plot_data_x_1, training_plot_data_y_1, training_plot_data_z_1, c='red', s=1, alpha=1)
157 ax.scatter(training_plot_data_x_2, training_plot_data_y_2, training_plot_data_z_2, c='green', s=1, alpha=1)
158 ax.scatter(training_plot_data_x_3, training_plot_data_y_3, training_plot_data_z_3, c='blue', s=1, alpha=1)
159 
160 Z = (-weights_1[0] * XX - weights_1[1] * YY - offset_1) / weights_1[2]
161 ax.plot_surface(XX,YY,Z,rstride=1,cstride=1,alpha=0.5,color='yellow')
162 Z = (-weights_2[0] * XX - weights_2[1] * YY - offset_2) / weights_2[2]
163 ax.plot_surface(XX,YY,Z,rstride=1,cstride=1,alpha=0.5,color='magenta')
164 Z = (-weights_3[0] * XX - weights_3[1] * YY - offset_3) / weights_3[2]
165 ax.plot_surface(XX,YY,Z,rstride=1,cstride=1,alpha=0.5,color='cyan')
166 
167 ax.set_xlabel('1st principle component')
168 ax.set_ylabel('2nd principle component')
169 ax.set_zlabel('3rd principle component')
170 
171 plt.show()