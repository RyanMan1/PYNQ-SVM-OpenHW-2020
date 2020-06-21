1   # coding: utf-8
2   
3   # In[1]:
4   
5   
6   ### SETUP load the overlay
7   from pynq import Overlay
8   
9   overlay = Overlay("/home/xilinx/pynq/overlays/deployment_rbf_ultra_1/deployment_rbf_ultra_1.bit")
10  
11  
12  # In[2]:
13  
14  
15  # ref: https://pynq.readthedocs.io/en/v2.5/overlay_design_methodology/overlay_tutorial.html
16  # ref: http://www.fpgadeveloper.com/2018/03/how-to-accelerate-a-python-function-with-pynq.html
17  
18  print("loading...")
19  
20  from pynq import DefaultIP
21  import numpy as np
22  import time
23  
24  # the PARSE_FILES class is instantiated once and the all files required for computing the geometric values and test predictions
25  # may be loaded, stored and (saved - if required)
26  class parse_files():
27      def __init__(self):
28          #super().__init__()
29          self.no_variables = None
30          self.no_variables_int = None
31          self.no_variables_fi = None
32          self.no_test_vectors = None
33          self.no_test_vectors_int= None
34          self.no_test_vectors_fi = None
35          self.no_classes_int = None
36          self.gamma_fi = None
37          
38          # other variables and arrays containing details on the training model and testing set
39          self.n_svs_data_int = None
40          self.n_svs_data_fi = None
41          self.testing_mat_fi_data_uint16 = None
42          self.testing_labels_data_int = None
43          self.test_predictions_libsvm = None
44          
45          # these are for each classifier and will need updated several times (for each training model)
46          self.svs_fi_data_uint16 = None
47          self.coeff_fi_data_uint32 = None
48          self.offset_fi_data_uint32 = None
49          
50          
51      def get_ds_details(self):
52          # read in the dataset details
53          f = open("ds_details_RBF.dat","r")
54  
55          contents = f.read()
56          ds_details_data = contents.split()
57          x = np.array(ds_details_data)
58          ds_details_data_float = np.asfarray(x, dtype='float')
59  
60          # no_variables
61          self.no_variables = ds_details_data_float[0]
62          self.no_variables_int = int(self.no_variables)
63          # (single-precision floating point 32 bit representation as an integer)
64          
65          # no_test_vectors
66          self.no_test_vectors = ds_details_data_float[1]
67          self.no_test_vectors_int = int(self.no_test_vectors)
68  
69          # number of classes
70          no_classes = ds_details_data_float[2]
71          self.no_classes_int = int(no_classes)
72          
73          f.close()
74          
75          # get fixed point details
76          f = open("ds_details_RBF_fi.dat","r")
77          contents = f.read()
78          ds_details_data = contents.split()
79          x = np.array(ds_details_data)
80          ds_details_data_uint32 = np.asarray(x,np.uint32)
81          
82          self.no_variables_fi = ds_details_data_uint32[0]
83          self.no_test_vectors_fi = ds_details_data_uint32[1]
84          self.gamma_fi = ds_details_data_uint32[3]
85          
86          f.close()
87          
88          # dont need no_classes as fixed point
89      
90      def get_no_svs(self):
91          # read file containing the number of support vectors for each classifier
92          f = open("n_svs.dat","r")
93  
94          contents = f.read()
95          n_svs_data = contents.split()
96          x = np.array(n_svs_data)
97          self.n_svs_data_int = np.asarray(x,np.uint32)
98  
99          f.close()
100         
101         # as above for fixed point
102         f = open("n_svs_fi.dat","r")
103 
104         contents = f.read()
105         n_svs_data = contents.split()
106         x = np.array(n_svs_data)
107         self.n_svs_data_fi = np.asarray(x,np.uint32)
108 
109         f.close()
110         
111     def get_testing_matrix(self):
112         f = open("test_matrix_fi.dat","r")
113 
114         contents = f.read()
115         testing_mat_fi_data = contents.split()
116         x = np.array(testing_mat_fi_data)
117         self.testing_mat_fi_data_uint16 = np.asarray(x, np.uint16)
118         
119         f.close()
120         
121     #def get_kernel_parameters(self):
122         
123     def get_testing_labels(self):
124         # for self checking Python tests
125         f = open("test_labels.dat","r")
126 
127         contents = f.read()
128         testing_labels_data = contents.split()
129         x = np.array(testing_labels_data)
130         self.testing_labels_data_int = np.asarray(x, np.uint8)
131 
132         f.close()
133         
134         f = open("test_predictions_libsvm.dat","r")
135         
136         contents = f.read()
137         testing_labels_data = contents.split()
138         x = np.array(testing_labels_data)
139         self.test_predictions_libsvm = np.asarray(x, np.uint8)
140         
141         f.close()
142         
143     def get_support_vectors(self, current_classifier):
144         # return support vectors for a particular classifier
145         file_ext = ".dat"
146         svs_file_name = "svs_fi_"
147         svs_file_name_new = svs_file_name + str(current_classifier) + file_ext
148         
149         f = open(svs_file_name_new,"r")
150 
151         contents = f.read()
152         svs_fi_data = contents.split()
153         x = np.array(svs_fi_data)
154         self.svs_fi_data_uint16 = np.asarray(x,np.uint16)
155     
156         f.close()
157         
158     def get_sv_coeffs(self, current_classifier):
159         # store the support vector coefficients for a classifier
160         file_ext = ".dat"
161         coeffs_file_name = "coeffs_fi_"
162         coeffs_file_name_new = coeffs_file_name + str(current_classifier) + file_ext
163 
164         f = open(coeffs_file_name_new,"r")
165 
166         contents = f.read()
167         coeffs_fi_data = contents.split()
168         x = np.array(coeffs_fi_data)
169         self.coeffs_fi_data_uint32 = np.asarray(x,np.uint32)
170     
171         f.close()
172         
173     def get_offset(self, current_classifier):
174         # store the offset for a classifier
175         file_ext = ".dat"        
176         offset_file_name  = "offset_fi_"
177         offset_file_name_new = offset_file_name + str(current_classifier) + file_ext
178         
179         f = open(offset_file_name_new,"r")
180 
181         offset_fi_data = f.read()
182         self.offset_fi_data_uint32 = np.asarray(offset_fi_data,np.uint32)
183     
184         f.close()
185     
186 # the GEOMETRIC_VALUES_DRIVER class is instantiated once for each "geometric_values" IP core
187 # member functions include loading data to IP core AXI-lite slave interfaces for general design
188 # parameters and generating the contigous buffers to transfer through DMA to the AXI stream (AXIS) 
189 # ports on the IP
190 # INHERITS FROM PARSE_FILES
191 from pynq import MMIO
192 
193 import pynq.lib.dma
194 
195 from pynq import allocate
196 
197 class deployment_driver(parse_files):
198     def __init__(self):
199         #super().__init__()
200              
201         # current classifier we are calculating the geometric values for
202         self.current_classifier = None
203                 
204         # get parameters from dat files which are general to all classifiers - i.e. not the support vectors, coefficient or offset
205         self.get_ds_details()
206         self.get_no_svs()
207         self.get_testing_matrix()
208         
209         # used for parallel processing of geometric values
210         self.classifier_indices = []
211         self.no_classifiers = None
212         
213         # LISTS
214         self.dma_sv_instances = []
215         self.dma_cf_instances = []
216         self.dma_ds_instances = []
217         self.dma_tm_instances = []
218         self.dma_gv_instances = []
219         
220         geometric_values_1 = overlay.geometric_values_1
221         geometric_values_2 = overlay.geometric_values_2
222         geometric_values_3 = overlay.geometric_values_3
223         geometric_values_4 = overlay.geometric_values_4
224         geometric_values_5 = overlay.geometric_values_5
225         geometric_values_6 = overlay.geometric_values_6
226         geometric_values_7 = overlay.geometric_values_7
227         geometric_values_8 = overlay.geometric_values_8
228         geometric_values_9 = overlay.geometric_values_9
229         geometric_values_10 = overlay.geometric_values_10
230         geometric_values_11 = overlay.geometric_values_11
231 
232         self.g_v_dispatcher = {
233             1: geometric_values_1,
234             2: geometric_values_2,
235             3: geometric_values_3,
236             4: geometric_values_4,
237             5: geometric_values_5,
238             6: geometric_values_6,
239             7: geometric_values_7,
240             8: geometric_values_8,
241             9: geometric_values_9,
242             10: geometric_values_10,
243             11: geometric_values_11,
244         }
245         
246         self.geometric_values_all = None
247         self.test_predictions = np.zeros(shape=(self.no_test_vectors_int,1), dtype=np.uint8)
248         
249         
250         self.geometric_values_time = 0
251         self.test_predictions_time = 0
252         
253     def dma_init(self, no_classifiers):
254         # initialise buffers not required to change on each iteration
255         self.test_matrix_buffer = allocate(shape=(self.no_test_vectors_int*self.no_variables_int,), dtype=np.uint16)
256         np.copyto(self.test_matrix_buffer,self.testing_mat_fi_data_uint16)
257         
258         self.geometric_values_all = np.zeros(shape=(self.no_test_vectors_int,int(no_classifiers)), dtype=np.uint32)
259                 
260     def dma_delete(self):
261         self.test_matrix_buffer.close()    
262         
263     def dma_transfer_parallel(self):
264         # instantiate all DMAs - parallel design
265         # tv_index is the index of the testing vector we wish to classify with the RBF kernelised SVM
266         for n1 in range(11):
267             self.dma_sv_instances.append(self.g_v_dispatcher[n1+1].dma_sv)
268             self.dma_cf_instances.append(self.g_v_dispatcher[n1+1].dma_cf)
269             self.dma_ds_instances.append(self.g_v_dispatcher[n1+1].dma_ds)
270             self.dma_tm_instances.append(self.g_v_dispatcher[n1+1].dma_tm)
271             self.dma_gv_instances.append(self.g_v_dispatcher[n1+1].dma_gv)
272             
273         geometric_values_buffer_1 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)
274         geometric_values_buffer_2 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)
275         geometric_values_buffer_3 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)
276         geometric_values_buffer_4 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
277         geometric_values_buffer_5 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
278         geometric_values_buffer_6 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
279         geometric_values_buffer_7 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
280         geometric_values_buffer_8 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
281         geometric_values_buffer_9 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
282         geometric_values_buffer_10 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
283         geometric_values_buffer_11 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)  
284     
285         geo_values_dispatcher = {
286             1: geometric_values_buffer_1,
287             2: geometric_values_buffer_2,
288             3: geometric_values_buffer_3,
289             4: geometric_values_buffer_4,
290             5: geometric_values_buffer_5,
291             6: geometric_values_buffer_6,
292             7: geometric_values_buffer_7,
293             8: geometric_values_buffer_8,
294             9: geometric_values_buffer_9,
295             10: geometric_values_buffer_10,
296             11: geometric_values_buffer_11,
297         }
298         
299         # accumulate with time taken to transfer data to DMA in each classifier
300         dma_transfer_time = 0
301                         
302         # iterate over only required classifiers
303         for n1 in range(11):
304             if(n1 < len(self.classifier_indices)):
305                 
306                 print("Current classifier: ", self.classifier_indices[n1])
307                 current_classifier = self.classifier_indices[n1]
308 
309                 # get training model for current classifier to compute geometric values for this classifier
310                 # support vectors:
311                 self.get_support_vectors(current_classifier)
312                 # offset:
313                 self.get_offset(self.classifier_indices[n1])
314                 # support vector coefficients:
315                 self.get_sv_coeffs(self.classifier_indices[n1])
316                 
317                 print(current_classifier)                
318             
319                 # no_svs is obtained at start from one file
320                 svs_length = self.n_svs_data_int[self.classifier_indices[n1]-1] * self.no_variables_int
321                 testing_matrix_length = self.no_test_vectors * self.no_variables_int
322                 # length of coeffs plus ONE (for the offset)
323                 coeffs_stream_length = self.n_svs_data_int[self.classifier_indices[n1]-1] + 1
324         
325                 coeffs_buffer = allocate(shape=(coeffs_stream_length,), dtype=np.uint32)
326                 ds_buffer = allocate(shape=(3,), dtype=np.uint32)
327                 svs_buffer = allocate(shape=(svs_length,), dtype=np.uint16)
328     
329                 np.copyto(svs_buffer,self.svs_fi_data_uint16)
330         
331                 # send gamma_fi - first elemtn of coeffs
332                 gamma_buffer = allocate(shape=(1,), dtype=np.uint32)
333                 gamma_buffer[0] = self.gamma_fi
334                                         
335                 np.copyto(coeffs_buffer[0:coeffs_stream_length-1], self.coeffs_fi_data_uint32)
336                 coeffs_buffer[coeffs_stream_length-1] = self.offset_fi_data_uint32
337                 
338                 ds_buffer[0] = self.n_svs_data_int[self.classifier_indices[n1]-1]
339                 ds_buffer[1] = self.no_variables_int
340                 ds_buffer[2] = self.no_test_vectors_int
341                                 
342                 # GET NORM_W IN FIXED POINT UNSIGNED INTEGER FORMAT
343                 dma_ds_nw = overlay.get_norm_w_1.dma_ds
344                 dma_sv_nw = overlay.get_norm_w_1.dma_sv
345                 dma_cf_nw = overlay.get_norm_w_1.dma_cf
346                 dma_nw_nw = overlay.get_norm_w_1.dma_nw
347                 
348                 coeffs_buffer_norm_w = coeffs_buffer[0:coeffs_stream_length-1]
349                 ds_buffer_norm_w = ds_buffer[0:2]
350                 norm_w_buffer = allocate(shape=(1,), dtype=np.uint32)
351                 
352                 # transfer to DMA
353                 start_time = time.time()
354                 
355                 dma_ds_nw.sendchannel.transfer(ds_buffer_norm_w)
356                 dma_sv_nw.sendchannel.transfer(svs_buffer)
357                 dma_cf_nw.sendchannel.transfer(coeffs_buffer_norm_w)
358                 dma_nw_nw.recvchannel.transfer(norm_w_buffer)
359                 
360                 dma_ds_nw.sendchannel.wait()
361                 dma_sv_nw.sendchannel.wait()
362                 dma_cf_nw.sendchannel.wait()
363                 dma_nw_nw.recvchannel.wait()
364                 
365                 # norm_w buffer is now populated and can be transferred to second element of coeffs strean as below
366                 
367                 # GET GEOMETRIC VALUES FOR THIS CLASSIFIER:
368                 self.dma_ds_instances[n1].sendchannel.transfer(ds_buffer)
369                 
370                 self.dma_cf_instances[n1].sendchannel.transfer(gamma_buffer)
371                 self.dma_cf_instances[n1].sendchannel.transfer(norm_w_buffer)
372                 #print(norm_w_buffer)
373                 
374                 # these need to be transferred "no_test_vectors" times - we require all support vectors and coefficients
375                 # to compute the geometric value of each testing vector
376                 
377                 self.dma_tm_instances[n1].sendchannel.transfer(self.test_matrix_buffer)
378                 
379                 self.dma_gv_instances[n1].recvchannel.transfer(geo_values_dispatcher[n1+1])
380                 
381                 for n2 in range(self.no_test_vectors_int):
382                     self.dma_sv_instances[n1].sendchannel.transfer(svs_buffer)
383                     self.dma_cf_instances[n1].sendchannel.transfer(coeffs_buffer)
384                 
385                     self.dma_sv_instances[n1].sendchannel.wait()
386                     self.dma_cf_instances[n1].sendchannel.wait()
387                 
388                 dma_transfer_time = dma_transfer_time + time.time() - start_time
389                 
390                 svs_buffer.close()
391                 coeffs_buffer.close()
392                 ds_buffer.close()
393                 
394         start_time = time.time()
395                        
396         for n1 in range(11):
397             if(n1 < len(self.classifier_indices)):
398                 self.dma_cf_instances[n1].sendchannel.wait()
399                 self.dma_ds_instances[n1].sendchannel.wait()
400                 self.dma_sv_instances[n1].sendchannel.wait()
401                 self.dma_tm_instances[n1].sendchannel.wait()
402                 self.dma_gv_instances[n1].recvchannel.wait()
403                 
404         self.geometric_values_time = self.geometric_values_time + time.time() - start_time + dma_transfer_time
405                                                 
406         for n1 in range(11):
407             if(n1 < len(self.classifier_indices)):        
408                 self.geometric_values_all[:,self.classifier_indices[n1]-1] = geo_values_dispatcher[n1+1][:]
409                 geo_values_dispatcher[n1+1].close()
410         
411     def geometric_values_driver(self):
412         # get training model for current classifier to compute geometric values for this classifier
413         
414         # generate require classifier indices in an 8-length array - there are currently 8 instances of geometric values
415         # e.g. [1,2,3,4,5,6,7,8] then [9,10] if more than 8 classifiers or just [1,2,3,4,5,6]
416 
417         # get no_classifiers
418         no_classifiers = self.no_classes_int * (self.no_classes_int - 1) / 2
419         self.no_classifiers = no_classifiers
420         
421         self.dma_init(no_classifiers)
422 
423         current_classifier = 1
424         done = 0
425         
426         while(done == 0):
427             # generate indices - reset to length zero
428             init_classifier = current_classifier
429             # (init is the first classifier for the next batch of parallel processing)
430             self.classifier_indices = []
431             for n1 in range(11):
432                 if(current_classifier < (no_classifiers + 1)):
433                     self.classifier_indices.append(init_classifier + n1)                        
434                     current_classifier = current_classifier + 1
435             
436             #print("current (next): ", current_classifier)
437             if((current_classifier-1) == int(no_classifiers)):
438                 done = 1
439             
440             # call dma transfer - parallel calculate geometric values
441             self.dma_transfer_parallel()
442         
443         self.dma_delete()
444         
445     def test_predictions_driver(self):     
446         no_classes = self.no_classes_int
447 
448         dma_gv = overlay.test_predictions_1.dma_gv
449         dma_ds = overlay.test_predictions_1.dma_ds
450         dma_tp = overlay.test_predictions_1.dma_tp
451 
452         ge_values_buffer = allocate(shape=(self.no_test_vectors_int,int(self.no_classifiers)), dtype=np.uint32)
453         dataset_buffer = allocate(shape=(2,1), dtype=np.uint32)
454 
455         np.copyto(ge_values_buffer,self.geometric_values_all)
456 
457         dataset_buffer[0] = self.no_classes_int
458         dataset_buffer[1] = self.no_test_vectors_int
459 
460         test_predictions_out_buffer = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint8)
461 
462         start_time = time.time()
463             
464         # transfer to DMA
465         dma_gv.sendchannel.transfer(ge_values_buffer)
466         dma_ds.sendchannel.transfer(dataset_buffer)
467         dma_tp.recvchannel.transfer(test_predictions_out_buffer)
468 
469         dma_gv.sendchannel.wait()
470         dma_ds.sendchannel.wait()
471         dma_tp.recvchannel.wait()
472         
473         elapsed_time = time.time() - start_time
474         self.test_predictions_time = elapsed_time
475 
476         self.test_predictions = test_predictions_out_buffer
477 
478         # delete memory on heap to avoid memory leakage
479         ge_values_buffer.close()
480         dataset_buffer.close()
481         test_predictions_out_buffer.close()
482         
483     def get_test_predictions(self):
484         # get geometric values
485         start_time = time.time()  
486         
487         self.geometric_values_driver()
488         self.test_predictions_driver()
489         
490         elapsed_time = time.time() - start_time
491         print("\nTIME TOTAL (WITH FILE READS): ", elapsed_time)
492         
493         print("TIME TO RECORD (NOT INCLUDING FILE READS): ", self.geometric_values_time + self.test_predictions_time)
494 
495 print("\ndone")
496 
497 
498 # In[3]:
499 
500 
501 deployment_driver_inst = deployment_driver()
502 deployment_driver_inst.get_test_predictions()
503 
504 
505 
506 # In[7]:
507 
508 
509 deployment_driver_inst.test_predictions
510 