1   # coding: utf-8
2   
3   # In[1]:
4   
5   
6   ### SETUP load the overlay
7   from pynq import Overlay
8   
9   overlay = Overlay("/home/xilinx/pynq/overlays/deployment_ultra_2 - LINEAR/deployment_ultra_2.bit")
10  
11  # In[2]:
12  
13  
14  # ref: https://pynq.readthedocs.io/en/v2.5/overlay_design_methodology/overlay_tutorial.html
15  # ref: http://www.fpgadeveloper.com/2018/03/how-to-accelerate-a-python-function-with-pynq.html
16  
17  print("loading...")
18  
19  from pynq import DefaultIP
20  import numpy as np
21  import time
22  
23  # the PARSE_FILES class is instantiated once and the all files required for computing the geometric values and test predictions
24  # may be loaded, stored and (saved - if required)
25  class parse_files():
26      def __init__(self):
27          #super().__init__()
28          self.no_variables = None
29          self.no_variables_int = None
30          self.no_test_vectors = None
31          self.no_test_vectors_int= None
32          self.no_classes_int = None
33          
34          # other variables and arrays containing details on the training model and testing set
35          self.n_svs_data_int = None
36          self.testing_mat_fi_data_uint16 = None
37          self.testing_labels_data_int = None
38          
39          # these are for each classifier and will need updated several times (for each training model)
40          self.svs_fi_data_uint16 = None
41          self.coeff_fi_data_uint32 = None
42          self.offset_fi_data_uint32 = None
43          
44          
45      def get_ds_details(self):
46          # read in the dataset details
47          f = open("ds_details.dat","r")
48  
49          contents = f.read()
50          ds_details_data = contents.split()
51          x = np.array(ds_details_data)
52          ds_details_data_uint32 = np.asarray(x,np.uint32)
53          #print(type(ds_details_data_uint32[0]))
54  
55          # no_variables
56          self.no_variables = ds_details_data_uint32[0]
57          self.no_variables_int = self.no_variables
58          # (single-precision floating point 32 bit representation as an integer)
59          
60          # no_test_vectors
61          self.no_test_vectors = ds_details_data_uint32[1]
62          self.no_test_vectors_int = self.no_test_vectors
63  
64          # number of classes
65          self.no_classes_int = ds_details_data_uint32[2]
66      
67      def get_no_svs(self):
68          # read file containing the number of support vectors for each classifier
69          f = open("n_svs.dat","r")
70  
71          contents = f.read()
72          n_svs_data = contents.split()
73          x = np.array(n_svs_data)
74          self.n_svs_data_int = np.asarray(x,np.uint32)
75  
76          f.close()
77          
78      def get_testing_matrix(self):
79          f = open("test_matrix_fi.dat","r")
80  
81          contents = f.read()
82          testing_mat_fi_data = contents.split()
83          x = np.array(testing_mat_fi_data)
84          #self.testing_mat_data_uint16 = x.astype(uint16)
85          self.testing_mat_fi_data_uint16 = np.asarray(x, np.uint16)
86          
87          f.close()
88          
89      #def get_kernel_parameters(self):
90          
91      def get_testing_labels(self):
92          # for self checking Python tests
93          f = open("test_labels.dat","r")
94  
95          contents = f.read()
96          testing_labels_data = contents.split()
97          x = np.array(testing_labels_data)
98          #testing_labels_data_float = np.asfarray(x,np.float32)
99          #self.testing_labels_data_int = testing_labels_data_float.astype(int)
100         self.testing_labels_data_int = np.asarray(x, np.uint8)
101 
102         f.close()
103         
104         f = open("test_predictions_libsvm.dat","r")
105         
106         contents = f.read()
107         testing_labels_data = contents.split()
108         x = np.array(testing_labels_data)
109         #testing_labels_data_float = np.asfarray(x,np.float32)
110         #self.testing_labels_data_int = testing_labels_data_float.astype(int)
111         self.test_predictions_libsvm = np.asarray(x, np.uint8)
112         
113         f.close()
114         
115     def get_support_vectors(self, current_classifier):
116         # return support vectors for a particular classifier
117         file_ext = ".dat"
118         svs_file_name = "svs_fi_"
119         svs_file_name_new = svs_file_name + str(current_classifier) + file_ext
120         
121         f = open(svs_file_name_new,"r")
122 
123         contents = f.read()
124         svs_fi_data = contents.split()
125         x = np.array(svs_fi_data)
126         self.svs_fi_data_uint16 = np.asarray(x,np.uint16)
127     
128         f.close()
129         
130     def get_sv_coeffs(self, current_classifier):
131         # store the support vector coefficients for a classifier
132         file_ext = ".dat"
133         coeffs_file_name = "coeffs_fi_"
134         coeffs_file_name_new = coeffs_file_name + str(current_classifier) + file_ext
135 
136         f = open(coeffs_file_name_new,"r")
137 
138         contents = f.read()
139         coeffs_fi_data = contents.split()
140         x = np.array(coeffs_fi_data)
141         self.coeffs_fi_data_uint32 = np.asarray(x,np.uint32)
142     
143         f.close()
144         
145     def get_offset(self, current_classifier):
146         # store the offset for a classifier
147         file_ext = ".dat"        
148         offset_file_name  = "offset_fi_"
149         offset_file_name_new = offset_file_name + str(current_classifier) + file_ext
150         
151         f = open(offset_file_name_new,"r")
152 
153         offset_fi_data = f.read()
154         self.offset_fi_data_uint32 = np.asarray(offset_fi_data,np.uint32)
155     
156         f.close()
157     
158 # the GEOMETRIC_VALUES_DRIVER class is instantiated once for each "geometric_values" IP core
159 # member functions include loading data to IP core AXI-lite slave interfaces for general design
160 # parameters and generating the contigous buffers to transfer through DMA to the AXI stream (AXIS) 
161 # ports on the IP
162 # INHERITS FROM PARSE_FILES
163 from pynq import MMIO
164 
165 import pynq.lib.dma
166 
167 from pynq import allocate
168 
169 class deployment_driver(parse_files):
170     def __init__(self):
171         #super().__init__()
172              
173         # current classifier we are calculating the geometric values for
174         self.current_classifier = None
175         
176         self.geometric_values_out = None
177         
178         # get parameters from dat files which are general to all classifiers - i.e. not the support vectors, coefficient or offset
179         self.get_ds_details()
180         self.get_no_svs()
181         self.get_testing_matrix()
182         
183         # used for parallel processing of geometric values
184         self.classifier_indices = []
185         self.no_classifiers = None
186         
187         # LISTS
188         self.dma_data_instances = []#contains the support vectors followed immediately by testing matrix in C standard type contigous memory
189         self.dma_cf_instances = []
190         self.dma_ds_instances = []
191         self.dma_gv_instances = []
192         
193         geometric_values_1 = overlay.geometric_values_1
194         geometric_values_2 = overlay.geometric_values_2
195         geometric_values_3 = overlay.geometric_values_3
196         geometric_values_4 = overlay.geometric_values_4
197         geometric_values_5 = overlay.geometric_values_5
198         geometric_values_6 = overlay.geometric_values_6
199         geometric_values_7 = overlay.geometric_values_7
200         geometric_values_8 = overlay.geometric_values_8
201         geometric_values_9 = overlay.geometric_values_9
202         geometric_values_10 = overlay.geometric_values_10
203         geometric_values_11 = overlay.geometric_values_11
204         geometric_values_12 = overlay.geometric_values_12
205         geometric_values_13 = overlay.geometric_values_13
206         geometric_values_14 = overlay.geometric_values_14
207         geometric_values_15 = overlay.geometric_values_15
208         
209         self.g_v_dispatcher = {
210             1: geometric_values_1,
211             2: geometric_values_2,
212             3: geometric_values_3,
213             4: geometric_values_4,
214             5: geometric_values_5,
215             6: geometric_values_6,
216             7: geometric_values_7,
217             8: geometric_values_8,
218             9: geometric_values_9,
219             10: geometric_values_10,
220             11: geometric_values_11,
221             12: geometric_values_12,
222             13: geometric_values_13,
223             14: geometric_values_14,
224             15: geometric_values_15,
225         }
226         
227         self.geometric_values_all = None
228         self.test_predictions = None
229         
230         self.geometric_values_time = 0
231         self.test_predictions_time = 0
232         
233         self.tm_buffer = None
234         
235     def dma_init(self, no_classifiers):
236         # initialise buffers not required to change on each iteration
237         
238         # store all geometric values here
239         self.geometric_values_all = np.zeros(shape=(self.no_test_vectors_int,int(no_classifiers)), dtype=np.uint32)
240         self.test_predictions = np.zeros(shape=(self.no_test_vectors_int,), dtype=np.uint8)
241         
242         self.tm_buffer = allocate(shape=(self.no_test_vectors_int*self.no_variables_int,), dtype=np.uint16)
243         np.copyto(self.tm_buffer,self.testing_mat_fi_data_uint16)
244         
245     def dma_delete(self):
246         self.tm_buffer.close()    
247         
248     def dma_transfer_parallel(self, no_classifiers):
249         # instantiate all DMAs - parallel design
250         for n1 in range(15):
251             self.dma_data_instances.append(self.g_v_dispatcher[n1+1].dma_data)
252             self.dma_cf_instances.append(self.g_v_dispatcher[n1+1].dma_cf)
253             self.dma_ds_instances.append(self.g_v_dispatcher[n1+1].dma_ds)
254             self.dma_gv_instances.append(self.g_v_dispatcher[n1+1].dma_gv)
255             
256         geometric_values_buffer_1 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)
257         geometric_values_buffer_2 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)
258         geometric_values_buffer_3 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)
259         geometric_values_buffer_4 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
260         geometric_values_buffer_5 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
261         geometric_values_buffer_6 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
262         geometric_values_buffer_7 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
263         geometric_values_buffer_8 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
264         geometric_values_buffer_9 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
265         geometric_values_buffer_10 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
266         geometric_values_buffer_11 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
267         geometric_values_buffer_12 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
268         geometric_values_buffer_13 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
269         geometric_values_buffer_14 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
270         geometric_values_buffer_15 = allocate(shape=(self.no_test_vectors_int,1), dtype=np.uint32)    
271 
272         
273         geo_values_dispatcher = {
274             1: geometric_values_buffer_1,
275             2: geometric_values_buffer_2,
276             3: geometric_values_buffer_3,
277             4: geometric_values_buffer_4,
278             5: geometric_values_buffer_5,
279             6: geometric_values_buffer_6,
280             7: geometric_values_buffer_7,
281             8: geometric_values_buffer_8,
282             9: geometric_values_buffer_9,
283             10: geometric_values_buffer_10,
284             11: geometric_values_buffer_11,
285             12: geometric_values_buffer_12,
286             13: geometric_values_buffer_13,
287             14: geometric_values_buffer_14,
288             15: geometric_values_buffer_15,
289         }
290         
291         # accumulate with time taken to transfer data to DMA in each classifier
292         dma_transfer_time = 0
293                 
294         # iterate over only required classifiers
295         for n1 in range(15):
296             if(n1 < len(self.classifier_indices)):
297                 current_classifier = self.classifier_indices[n1]
298                 print("current_classifier: ", current_classifier)
299 
300                 # get training model for current classifier to compute geometric values for this classifier
301                 # support vectors:
302                 self.get_support_vectors(current_classifier)
303                 # offset:
304                 self.get_offset(self.classifier_indices[n1])
305                 # support vector coefficients:
306                 self.get_sv_coeffs(self.classifier_indices[n1])
307 
308                 # no_svs is obtained at start from one file
309                 # length of support vectors plus length of testing matrix by 256 variables
310                 svs_length = self.n_svs_data_int[self.classifier_indices[n1]-1] * self.no_variables_int
311                 testing_matrix_length = self.no_test_vectors_int * self.no_variables_int
312                 data_stream_length = svs_length + testing_matrix_length
313                 # length of coeffs plus one (for the offset)
314                 coeffs_stream_length = self.n_svs_data_int[self.classifier_indices[n1]-1] + 1
315         
316             
317                 svs_buffer = allocate(shape=(svs_length,), dtype=np.uint16)
318                 coeffs_buffer = allocate(shape=(coeffs_stream_length,), dtype=np.uint32)
319                 ds_buffer = allocate(shape=(3,), dtype=np.uint32)
320                 
321                 np.copyto(svs_buffer,self.svs_fi_data_uint16)
322                 np.copyto(coeffs_buffer[0:coeffs_stream_length-1], self.coeffs_fi_data_uint32)
323                 coeffs_buffer[coeffs_stream_length-1] = self.offset_fi_data_uint32
324 
325                 ds_buffer[0] = self.n_svs_data_int[self.classifier_indices[n1]-1]
326                 ds_buffer[1] = self.no_variables_int
327                 ds_buffer[2] = self.no_test_vectors_int      
328                 
329                 # transfer to DMA
330                 start_time = time.time()
331                 #self.dma_data_instances[n1].sendchannel.transfer(self.data_buffer)
332                 self.dma_cf_instances[n1].sendchannel.transfer(coeffs_buffer)
333                 self.dma_ds_instances[n1].sendchannel.transfer(ds_buffer)
334                 self.dma_gv_instances[n1].recvchannel.transfer(geo_values_dispatcher[n1+1])
335                 
336                 self.dma_data_instances[n1].sendchannel.transfer(svs_buffer)
337                 self.dma_data_instances[n1].sendchannel.wait()
338                 self.dma_data_instances[n1].sendchannel.transfer(self.tm_buffer)
339                 
340                 dma_transfer_time = dma_transfer_time + time.time() - start_time
341                 
342                 coeffs_buffer.close()
343                 ds_buffer.close()
344                 
345         start_time = time.time()
346                 
347         for n1 in range(15):
348             if(n1 < len(self.classifier_indices)):
349                 self.dma_data_instances[n1].sendchannel.wait()
350                 self.dma_cf_instances[n1].sendchannel.wait()
351                 self.dma_ds_instances[n1].sendchannel.wait()
352                 self.dma_gv_instances[n1].recvchannel.wait()
353         
354         elapsed_time = time.time() - start_time + dma_transfer_time
355         self.geometric_values_time = self.geometric_values_time + elapsed_time
356                 
357         for n1 in range(15):
358             if(n1 < len(self.classifier_indices)):        
359                 self.geometric_values_all[:,self.classifier_indices[n1]-1] = geo_values_dispatcher[n1+1][:,0]
360                 geo_values_dispatcher[n1+1].close()        
361     
362     def geometric_values_driver(self):
363         # get training model for current classifier to compute geometric values for this classifier
364         # generate require classifier indices in an 8-length array - there are currently 8 instances of geometric values
365         # e.g. [1,2,3,4,5,6,7,8] then [9,10] if more than 8 classifiers or just [1,2,3,4,5,6]
366 
367         # get no_classifiers
368         no_classifiers = self.no_classes_int * (self.no_classes_int - 1) / 2
369         self.no_classifiers = no_classifiers
370         
371         self.dma_init(no_classifiers)
372 
373         current_classifier = 1
374         done = 0
375         
376         while(done == 0):
377             # generate indices - reset to length zero
378             init_classifier = current_classifier
379             # (init is the first classifier for the next batch of parallel processing)
380             self.classifier_indices = []
381             for n1 in range(15):
382                 if(current_classifier < (no_classifiers + 1)):
383                     self.classifier_indices.append(init_classifier + n1)
384                     current_classifier = current_classifier + 1
385             
386             if((current_classifier-1) == int(no_classifiers)):
387                 done = 1
388             
389             # call dma transfer - parallel calculate geometric values
390             self.dma_transfer_parallel(no_classifiers)
391         
392         self.dma_delete()
393         
394     def test_predictions_driver(self):     
395         no_classes = self.no_classes_int
396         no_test_vectors = self
397 
398         dma_gv = overlay.test_predictions_1.dma_gv
399         dma_ds = overlay.test_predictions_1.dma_ds
400         dma_tp = overlay.test_predictions_1.dma_tp
401 
402         ge_values_buffer = allocate(shape=(self.no_test_vectors,int(self.no_classifiers)), dtype=np.uint32)
403         dataset_buffer = allocate(shape=(2,1), dtype=np.uint32)
404 
405         np.copyto(ge_values_buffer,self.geometric_values_all)
406 
407         dataset_buffer[0] = self.no_classes_int
408         dataset_buffer[1] = self.no_test_vectors
409 
410         test_predictions_out_buffer = allocate(shape=(self.no_test_vectors,1), dtype=np.uint8)
411 
412         start_time = time.time()
413             
414         # transfer to DMA
415         dma_gv.sendchannel.transfer(ge_values_buffer)
416         dma_ds.sendchannel.transfer(dataset_buffer)
417         dma_tp.recvchannel.transfer(test_predictions_out_buffer)
418 
419         dma_gv.sendchannel.wait()
420         dma_ds.sendchannel.wait()
421         dma_tp.recvchannel.wait()
422         
423         elapsed_time = time.time() - start_time
424         self.test_predictions_time = elapsed_time
425 
426         self.test_predictions = test_predictions_out_buffer
427 
428         # delete memory on heap to avoid memory leakage
429         ge_values_buffer.close()
430         dataset_buffer.close()
431         test_predictions_out_buffer.close()
432         
433     def get_test_predictions(self):
434         # get geometric values
435         start_time = time.time()  
436         
437         self.geometric_values_driver()
438         
439         self.test_predictions_driver()
440         
441         elapsed_time = time.time() - start_time
442         print("\nTIME TOTAL (WITH FILE READS): ", elapsed_time)
443         
444         print("TIME TO RECORD (NOT INCLUDING FILE READS): ", self.geometric_values_time + self.test_predictions_time)
445 
446 print("\ndone")
447 
448 
449 # In[ ]:
450 
451 # instantiate driver class
452 deployment_driver_inst = deployment_driver()
453 
454 
455 # In[16]:
456 
457 # call top level function to get predictions
458 deployment_driver_inst.get_test_predictions()
459 
460 
461 # In[17]:
462 
463 
464 # check the accuracy of the prediction and simlarity to libsvm result
465 deployment_driver_inst.get_testing_labels()
466 
467 # track errors to compute accuracy of precdiction
468 err_count = 0
469 # track differences to libsvm - this indicates issues with the numerical precision of the algorithm
470 disimilarity_count = 0
471 
472 for i in range(deployment_driver_inst.no_test_vectors_int):
473     if(deployment_driver_inst.test_predictions[i] != deployment_driver_inst.testing_labels_data_int[i]):
474         err_count = err_count + 1
475     if(deployment_driver_inst.test_predictions[i] != deployment_driver_inst.test_predictions_libsvm[i]):
476         disimilarity_count = disimilarity_count + 1
477         
478 print("accuracy = ", (deployment_driver_inst.no_test_vectors_int - err_count) / deployment_driver_inst.no_test_vectors_int * 100, "%")
479 print("similarity = ", (deployment_driver_inst.no_test_vectors_int - disimilarity_count) / deployment_driver_inst.no_test_vectors_int * 100, "%")
480 
481 