1    # coding: utf-8
2    
3    # In[1]:
4    
5    
6    ### SETUP load the overlay
7    # Set FPD and LPD interface widths
8    from pynq import MMIO
9    
10   fpd_cfg = MMIO(0xfd615000, 4)
11   fpd_cfg.write(0, 0x00000A00)
12   lpd_cfg = MMIO(0xff419000, 4)
13   lpd_cfg.write(0, 0x00000000)
14   
15   from pynq import Overlay
16   
17   overlay = Overlay("/home/xilinx/pynq/overlays/SMO_FULL_ULTRA_1/SMO_FULL_ULTRA_1.bit")
18   
19   
20   # In[2]:
21   
22   
23   from pynq import DefaultIP
24   import numpy as np
25   
26   class parse_files():
27       def __init__(self):
28           #super().__init__()
29           # dot product matrix will be computed from two training matrix streams 
30           self.training_labels_data_fi_uint8 = None
31           self.training_mat_data_fi_uint16 = None
32           self.input_details_data_fi_uint32 = None
33           
34           # miscellaneous variables
35           self.no_training_vectors_fi_uint32 = None
36           self.no_training_vectors_int = None
37           self.no_variables_fi_uint32 = None
38           self.no_variables_int = None
39           self.C_fi_uint32 = None
40           self.tolerance_fi_uint32 = None
41           # number of classifiers:
42           self.no_classes = None
43           
44       def get_training_labels(self):
45           # for self checking Python tests
46           f = open("training_labels.dat","r")
47   
48           contents = f.read()
49           training_labels_data = contents.split()
50           x = np.array(training_labels_data)
51           self.training_labels_data_fi_uint8 = np.asarray(x,np.uint8)
52   
53           f.close()    
54           
55       def get_training_matrix(self):
56           f = open("training_matrix_fi.dat","r")
57   
58           contents = f.read()
59           training_mat_data = contents.split()
60           x = np.array(training_mat_data)
61           self.training_mat_data_fi_uint16 = np.asarray(x,np.uint16)
62   
63           f.close()
64           
65       def get_input_details(self):
66           f = open("training_details.dat","r")
67           
68           contents = f.read()
69           input_details_data = contents.split()
70           x = np.array(input_details_data)
71           self.input_details_data_float = np.asfarray(x,np.float32)
72           
73           self.no_training_vectors_float = self.input_details_data_float[0]
74           self.no_training_vectors_int = int(self.no_training_vectors_float)
75           self.no_variables_float = self.input_details_data_float[1]
76           self.no_variables_int = int(self.no_variables_float)
77           self.C = self.input_details_data_float[2]
78           self.tolerance = self.input_details_data_float[3]
79           
80           f.close()
81           
82           f = open("training_details_fi.dat","r")
83           
84           contents = f.read()
85           input_details_data = contents.split()
86           x = np.array(input_details_data)
87           self.input_details_data_fi_uint32 = np.asarray(x,np.uint32)
88           
89           f.close()
90           
91       def get_no_classes(self):
92           f = open("no_classes.dat")
93           
94           contents = f.read()
95           self.no_classes = contents.split()
96           self.no_classes = int(self.no_classes[0])
97           
98           f.close()
99   
100  import pynq.lib.dma
101  import struct
102  import time
103  
104  from pynq import allocate
105  
106  class SMO_driver(parse_files):
107      def __init__(self):
108          #super().__init__()
109          
110          self.get_no_classes()
111          self.no_classifiers = int(0.5 * self.no_classes * (self.no_classes - 1))
112          
113          # DECLARE MEMORY FOR STACK
114          self.training_labels_buffer = None
115          self.training_matrix_buffer = None
116          self.input_details_buffer = None
117          self.alpha_out_buffer = None
118          self.output_details_buffer = None
119  
120          # these lists contain the DMA instances for the different cores used in the overlay
121          self.dma_dp_o_1 = []
122          self.dma_dp_i_1 = []
123          self.dma_dp_o_2 = []
124          self.dma_dp_i_2 = []
125          self.dma_dp_id_o = []
126          self.dma_dp_id_i = []
127          self.dma_tl = []
128          self.dma_tm_o = []
129          self.dma_tm_i = []
130          self.dma_id = []
131  
132          self.dma_ao = []
133          self.dma_kkt = []
134          self.dma_od = []
135          
136          self.no_cores = 4
137          self.classifier_indices = []
138          self.no_training_vectors_all = np.zeros(shape=(self.no_cores), dtype=np.uint32)
139          
140          # create a dispatcher to allow streamlined access to the different cores in the design
141          SMO_1 = overlay.SMO_1
142          SMO_2 = overlay.SMO_2
143          SMO_3 = overlay.SMO_3
144          SMO_4 = overlay.SMO_4
145          
146          self.SMO_dispatcher = {
147              1: SMO_1,
148              2: SMO_2,
149              3: SMO_3,
150              4: SMO_4,
151          }
152          
153          # store training models
154          self.sv_coeffs = []
155          self.sv_indices = []
156          self.no_svs = []
157          self.offsets = []
158          self.no_itrs = []
159          
160          self.training_latency = 0
161          
162      def fixed_point_to_float(self, input_, word_length, integer_length):
163          # returns floating point representation of fixed point SIGNED integer input
164          # specify the word length and integer length
165          
166          fractional_length = word_length - integer_length
167          output = 0
168  
169          input_bin_string = "{0:b}".format(input_)
170  
171          for n1 in range(word_length - len(input_bin_string)):
172              input_bin_string = '0' + input_bin_string
173      
174          no_positive = 1
175  
176          # number is negative
177          if(input_bin_string[0] == '1'):
178              no_positive = 0
179              input_bin_tc = input_ - (1 << word_length)
180              # input is now negative
181              input_ = -input_bin_tc
182      
183          input_bin_string = "{0:b}".format(input_)
184  
185          for n1 in range(word_length - len(input_bin_string)):
186              input_bin_string = '0' + input_bin_string
187      
188          for i, c in enumerate(input_bin_string):
189              if(c == '1'):
190                  output = output + 2 ** (integer_length - 1 - i)
191  
192          if(no_positive == 1):
193              return output
194          else:
195              return -output
196  
197          # https://stackoverflow.com/questions/699866/python-int-to-binary-string
198          # https://stackoverflow.com/questions/538346/iterating-each-character-in-a-string-using-python
199          # https://stackoverflow.com/questions/1604464/twos-complement-in-python
200          
201      def int_bits_IEEE754_to_float(self, to_convert):
202          # credit - https://stackoverflow.com/questions/30124608/convert-unsigned-integer-to-float-in-python
203          # convert integer bits (unsigned long 'L') (IEEE754 single-precision) to float 'f'
204          s = struct.pack('>L', to_convert)
205          return struct.unpack('>f', s)[0]
206          
207      def write_training_model_to_files(self, current_classifier):  
208          # SV COEFFS TO FILE #
209          # create new numpy array to copy to file - copt pynq buffer into
210          coeffs_write = np.zeros(shape=(len(self.sv_coeffs[current_classifier-1]),1), dtype=np.uint32)
211          np.copyto(coeffs_write, self.sv_coeffs[current_classifier-1])
212          np.savetxt("coeffs_fi_"+str(current_classifier)+".dat",coeffs_write,'%d')
213          
214          # SUPPORT VECTORS TO FILE #
215          svs_write = np.reshape(self.training_mat_data_fi_uint16,((int(len(self.training_mat_data_fi_uint16)/self.no_variables_int),self.no_variables_int)))
216          svs_write = svs_write[self.sv_indices[current_classifier-1]]
217          np.savetxt("svs_fi_"+str(current_classifier)+".dat",svs_write,'%d')
218          
219          # OFFSET TO FILE #
220          np.savetxt("offset_fi_"+str(current_classifier)+".dat",self.offsets[current_classifier-1],'%d')
221          
222      def write_n_svs_to_file(self):
223          # populate number of support vectors to array and write to file
224          no_classifiers = int(0.5 * self.no_classes * (self.no_classes - 1))
225          n_svs = np.zeros(shape=(no_classifiers), dtype=np.uint32)
226          
227          for n1 in range(no_classifiers):
228              n_svs[n1] = len(self.sv_coeffs[n1])
229              
230          np.savetxt("n_svs.dat",n_svs,'%d')
231              
232      def pynq_buffer_init(self):
233          # DECLARE MEMORY FOR HEAP - need to use lists as there are multiple buffers needing to be transferred simultaneously 
234          # containing different training sets
235          
236          self.training_matrix_buffers = []
237          self.alpha_out_buffers = []
238          self.output_details_buffers = []
239          self.kkt_violation_buffers = []
240          
241          self.input_details_dpm_buffers = []
242          
243          self.input_details_buffer = allocate(shape=(5,), dtype=np.int32)
244          
245          for n1 in range(self.no_cores):
246              self.output_details_buffer = allocate(shape=(1,), dtype=np.uint32)
247              # declare buffers to receive indication signals to send new copies of training and dot product matrices
248              # kkt_violation_buffer checks if there is a kkt violation and we need to execute the p loop
249              self.kkt_violation_buffer = allocate(shape=(1,), dtype=np.uint8)
250              self.input_details_dpm_buffer = allocate(shape=(2,), dtype=np.uint16)
251              
252              self.output_details_buffers.append(self.output_details_buffer)
253              self.kkt_violation_buffers.append(self.kkt_violation_buffer)
254              self.input_details_dpm_buffers.append(self.input_details_dpm_buffer)
255          
256      def pynq_buffer_delete(self):
257          # close buffers - clean up heap memory
258          
259          for n1 in range(self.no_cores):
260              if(n1 == len(self.classifier_indices)):
261                  break
262              self.training_matrix_buffers[n1].close()
263              self.input_details_buffer.close()
264              
265              self.alpha_out_buffers[n1].close()
266              self.output_details_buffers[n1].close()
267          
268      def SMO_parallel(self, training_matrices, training_labels, index_1, index_2, no_training_vectors, no_variables, C, tolerance, max_itr):
269          # index_1 is the index of the first training vector with respoect to the entire training dataset
270          # index_2 is same but for negative class
271          # lists for the different parallel classifier executions
272          
273          # initialise buffers
274          self.pynq_buffer_init()
275          no_variables = int(no_variables)
276          
277          # store start index of negative class
278          negative_class_index = np.zeros(shape=(self.no_cores), dtype=np.uint32)
279          for n1 in range(self.no_cores):
280              if(n1 == len(self.classifier_indices)):
281                  break
282              negative_class_index[n1] = np.where(training_labels[n1] == -1)[0][0]
283              
284          # instantiate all DMAs
285          for n1 in range(self.no_cores):
286              # check if we are out of range of no_classifiers
287              if(n1 == len(self.classifier_indices)):
288                  break
289              self.dma_dp_o_1.append(self.SMO_dispatcher[n1+1].dma_dp_o_1)
290              self.dma_dp_i_1.append(self.SMO_dispatcher[n1+1].dma_dp_i_1)
291              self.dma_dp_o_2.append(self.SMO_dispatcher[n1+1].dma_dp_o_2)
292              self.dma_dp_i_2.append(self.SMO_dispatcher[n1+1].dma_dp_i_2)
293              self.dma_dp_id_o.append(self.SMO_dispatcher[n1+1].dma_dp_id_o)
294              self.dma_dp_id_i.append(self.SMO_dispatcher[n1+1].dma_dp_id_i)
295              self.dma_tl.append(self.SMO_dispatcher[n1+1].dma_tl)
296              self.dma_tm_o.append(self.SMO_dispatcher[n1+1].dma_tm_o)
297              self.dma_tm_i.append(self.SMO_dispatcher[n1+1].dma_tm_i)
298              self.dma_id.append(self.SMO_dispatcher[n1+1].dma_id)
299              self.dma_ao.append(self.SMO_dispatcher[n1+1].dma_ao)
300              self.dma_kkt.append(self.SMO_dispatcher[n1+1].dma_kkt)
301              self.dma_od.append(self.SMO_dispatcher[n1+1].dma_od)
302              
303          # allocate buffers for each classifier
304          for n1 in range(self.no_cores):
305              if(n1 == len(self.classifier_indices)):
306                  break
307              no_training_vectors[n1] = int(no_training_vectors[n1])
308              self.training_matrix_buffer = allocate(shape=(no_training_vectors[n1]*no_variables,), dtype=np.uint16)
309              self.alpha_out_buffer = allocate(shape=(no_training_vectors[n1],1), dtype=np.uint32)
310              
311              self.training_matrix_buffers.append(self.training_matrix_buffer)
312              self.alpha_out_buffers.append(self.alpha_out_buffer)
313                  
314          # loop over number of cores to send data which is constant for the current classifier
315          for n1 in range(self.no_cores):
316              if(n1 == len(self.classifier_indices)):
317                  break
318              training_labels_buffer = allocate(shape=(no_training_vectors[n1],), dtype=np.int8)
319              
320  			# ONLY NECESSARY FOR ZYNQ MPSOC - TEMPORARY WORKAROUND
321              ###############
322              copy_length = len(training_labels_buffer)
323              if(copy_length%8 != 0):
324                  modulo = copy_length%8
325                  np.copyto(training_labels_buffer[0:copy_length-modulo], training_labels[n1][0:copy_length-modulo])
326                  for mod_loop in range(modulo):
327                      training_labels_buffer[copy_length-mod_loop-1] = training_labels[n1][copy_length-mod_loop-1]
328              else:
329                  np.copyto(training_labels_buffer, training_labels[n1])
330              ###############
331              
332              # also want to obtain and store the training matrices and dot product mastrices for all classifiers in this parallel iteration
333              ###############
334              copy_length = len(training_matrices[n1])
335              if(copy_length%4 != 0):
336                  modulo = copy_length%4
337                  np.copyto(self.training_matrix_buffers[n1][0:copy_length-modulo], training_matrices[n1][0:copy_length-modulo])
338                  for mod_loop in range(modulo):
339                      training_matrix_buffers[n1][copy_length-mod_loop-1] = training_matrices[n1][copy_length-mod_loop-1]
340              else:
341                  np.copyto(self.training_matrix_buffers[n1], training_matrices[n1])         
342              ###############
343  
344              self.no_training_vectors_all[n1] = no_training_vectors[n1]
345              
346              #### INPUT DETAILS
347              # convert floats to IEEE754 bits format
348              no_training_vectors_IEEE754 = np.asarray(no_training_vectors[n1], dtype=np.float32).view(np.int32).item()
349              no_variables_IEEE754 = np.asarray(no_variables, dtype=np.float32).view(np.int32).item()
350              max_itr_IEEE754 = np.asarray(max_itr, dtype=np.float32).view(np.int32).item()
351              tol_IEEE754 = np.asarray(tolerance, dtype=np.float32).view(np.int32).item()
352              C_IEEE754 = np.asarray(C, dtype=np.float32).view(np.int32).item()
353                      
354              # INPUT_DETAILS
355              # no_training_vectors - from file
356              # no_variables - from file
357              # max_itr, tolerance, C - specified by user
358              x = [no_training_vectors_IEEE754, no_variables_IEEE754, max_itr_IEEE754, tol_IEEE754, C_IEEE754]
359              np.copyto(self.input_details_buffer[0:4], np.asarray(x, np.int32)[0:4])
360              self.input_details_buffer[4] = np.asarray(x, np.int32)[4]
361              
362              # INPUT_DETAILS for matrix multiply cores - these are integer, not float
363              x = [no_training_vectors[n1], no_variables]
364              self.input_details_dpm_buffers[n1][0] = x[0]
365              self.input_details_dpm_buffers[n1][1] = x[1]
366              
367              start_time = time.time()
368              
369              # transfer input details and training labels to DMA
370              # send channels:
371              self.dma_id[n1].sendchannel.transfer(self.input_details_buffer)
372              self.dma_tl[n1].sendchannel.transfer(training_labels_buffer)
373              self.dma_id[n1].sendchannel.wait()
374              self.dma_tl[n1].sendchannel.wait()
375                          
376              # receive channels
377              self.dma_ao[n1].recvchannel.transfer(self.alpha_out_buffers[n1])
378              
379              self.training_latency = self.training_latency + time.time() - start_time
380              
381                          
382          # if this is 0, the design has exited without changed_alphas = 0 meaning its iterations have saturated
383          # if it is 1, then we requiured less iterations than specified
384          # this parameter is used to determing the last element in the "output_details" stream - the last element should be the offset
385          changed_alphas_exit = np.zeros(shape=(self.no_cores,), dtype=np.uint32)
386  
387          start_time = time.time()
388  
389          # iterate over the maximum number of iterations
390          for n0 in range(max_itr):
391              # iterate over the cores
392              for n0_1 in range(self.no_cores):
393                  if(n0_1 == len(self.classifier_indices)):
394                      break
395                  if(changed_alphas_exit[n0_1] == 0):
396                      self.dma_od[n0_1].recvchannel.transfer(self.output_details_buffers[n0_1])
397  
398                      self.dma_dp_id_o[n0_1].sendchannel.transfer(self.input_details_dpm_buffers[n0_1])
399                      self.dma_dp_id_o[n0_1].sendchannel.wait()
400              
401                      # TRANSFER OUTER DOT PRODUCT MATRIX (FIRST TRAINING MATRIX - NEEDED ONCE PER ITERATION):
402                      self.dma_dp_o_1[n0_1].sendchannel.transfer(self.training_matrix_buffers[n0_1])
403                      # send initial copy of outer training matrix and dot product matrix
404                      self.dma_tm_o[n0_1].sendchannel.transfer(self.training_matrix_buffers[n0_1])
405          
406              # p loops:
407              for n1 in range(max(self.no_training_vectors_all)):
408                  # iterate over the cores
409                  for n1_1 in range(self.no_cores):
410                      if(n1_1 == len(self.classifier_indices)):
411                          break
412                      if(changed_alphas_exit[n1_1] == 0):
413                          if(n1 < self.no_training_vectors_all[n1_1]):
414                              
415                              # loop until we see a kkt violation or can execute next iteration of SMO
416                              self.dma_kkt[n1_1].recvchannel.transfer(self.kkt_violation_buffers[n1_1])
417                              
418                              # TRANSFER SECOND TRAINING MATRIX (TO COMPUTE OUTER DOT PRODUCT MATRIX) - ONCE PER P LOOP
419                              self.dma_dp_o_2[n1_1].sendchannel.transfer(self.training_matrix_buffers[n1_1])
420                              self.dma_dp_o_2[n1_1].sendchannel.wait()
421  
422  
423                              while(1):
424                                  s2mm_status_kkt = self.dma_kkt[n1_1].read(0x34)
425                                  if(s2mm_status_kkt == 4098):
426                                      break
427                      
428                              if(self.kkt_violation_buffers[n1_1] == 1):
429                                  
430                                  # transfer nput details for matrix multiply core
431                                  self.dma_dp_id_i[n1_1].sendchannel.transfer(self.input_details_dpm_buffers[n1_1])
432                                  self.dma_dp_id_i[n1_1].sendchannel.wait()
433                                  # kkt violation - transfer inner matrices
434                                  self.dma_tm_i[n1_1].sendchannel.transfer(self.training_matrix_buffers[n1_1])
435  
436                                  # COMPUTE AND TRANSFER DOT PRODUCT MATRIX:
437                                  self.dma_dp_i_1[n1_1].sendchannel.transfer(self.training_matrix_buffers[n1_1])
438                                  for n1_2 in range(self.no_training_vectors_all[n1_1]):
439                                      self.dma_dp_i_2[n1_1].sendchannel.transfer(self.training_matrix_buffers[n1_1])
440                                      self.dma_dp_i_2[n1_1].sendchannel.wait()
441                                      
442                                  self.dma_tm_i[n1_1].sendchannel.wait()
443                                  self.dma_dp_i_1[n1_1].sendchannel.wait()
444                                                                              
445              # check to see if we should go to next iteration or if alpha has been calculated - we can break
446              # if we should go to next iteration
447              # loop over no_cores:
448              for n0_1 in range(self.no_cores):
449                  if(n0_1 == len(self.classifier_indices)):
450                      break
451                  if(changed_alphas_exit[n0_1] == 0):
452                      while(1):
453                          s2mm_status_od = self.dma_od[n0_1].read(0x34)
454                          if(s2mm_status_od == 4098):
455                              test = int(self.output_details_buffers[n0_1])
456                              break
457                      
458                      if(int(self.fixed_point_to_float(test,32,12)) == (n0 + 1)):
459                          # exiting with "changed_alphas =/= 0" (on last iteration)
460                          changed_alphas_exit[n0_1] = 0
461                          #continue
462                      else:
463                          # exiting with "changed_alphas == 0"
464                          changed_alphas_exit[n0_1] = 1
465                          #break
466              
467              # check if all training models are completed - if any remain, continue
468              # if all complete, break_all goes to 1 - can read results from all classifiers
469              break_all = 0
470              for n0_1 in range(self.no_cores):
471                  if(n0_1 == len(self.classifier_indices)):
472                      break
473                  if(changed_alphas_exit[n0_1] == 0):
474                      break
475                  if(n0_1 == (self.no_cores - 1)):
476                      break_all = 1
477              
478              if(break_all == 1):
479                  break
480              
481          # loop over cores - get results
482          for n0 in range(self.no_cores):
483              if(n0 == len(self.classifier_indices)):
484                  break
485              if(changed_alphas_exit[n0] == 0):
486                  self.dma_od[n0].recvchannel.transfer(self.output_details_buffers[n0])
487                  self.dma_od[n0].recvchannel.wait()
488          
489              # DMA wait
490              self.dma_ao[n0].recvchannel.wait()
491              
492              # NEED TO OBTAIN COEFFICIENTS - ALPHAS OF NEGATIVE CLASS SHOULD BE MULTIPLIED BY -1
493              coeffs_temp = self.alpha_out_buffers[n0]
494              coeffs_temp[negative_class_index[n0]:no_training_vectors[n0],0] = coeffs_temp[negative_class_index[n0]:no_training_vectors[n0],0] * -1
495              # set very small coefficients to zero
496              coeffs_temp[np.where(np.absolute(coeffs_temp) < 0.00001)] = 0
497              coeffs_temp_2 = np.zeros(shape=(len(np.where(coeffs_temp != 0)[0])), dtype=np.uint32)
498              coeffs_temp_2 = coeffs_temp[np.where(coeffs_temp != 0)[0]]
499              self.sv_coeffs.append(coeffs_temp_2)
500              self.offsets.append(self.output_details_buffers[n0])
501              
502              # GET INDICES OF SUPPORT VECTORS WITH RESPECT TO ENTIRE TRAINING SET
503              sv_indices_old = np.where(coeffs_temp != 0)[0]
504              
505              length_class_1 = negative_class_index[n0]
506              length_class_2 = no_training_vectors[n0] - length_class_1
507              
508              first_classifier_indices = np.where(sv_indices_old < length_class_1)[0]
509              second_classifier_indices = np.where(sv_indices_old >= length_class_1)[0]
510              
511              sv_indices_new = np.zeros(shape=(len(sv_indices_old)), dtype=np.uint8)
512              
513              # these lines get the actual indices corresponding to the support vectors identified from the binary training
514              sv_indices_new[first_classifier_indices] = sv_indices_old[first_classifier_indices] + index_1[n0]
515              sv_indices_new[second_classifier_indices] = sv_indices_old[second_classifier_indices] - length_class_1 + index_2[n0]
516              
517              self.sv_indices.append(sv_indices_new)
518                          
519          self.training_latency = self.training_latency + time.time() - start_time
520          
521          self.pynq_buffer_delete()
522          
523      def SMO_driver_top(self, C, tolerance, max_itr):
524          # this function calls the "SMO_parallel" driver function to execute (no_cores) runs of the SMO in parallel
525          # it populates the "classifier_instances" variable with the relevant numbers - e.g. if we had 5 classifiers,
526          # and 2 cores, "classifier_instances" would take the values [1,2] on the first iteration, [3,4] on the second
527          # and [5] on the third
528          
529          # this function also gets the indices for each classifier
530          # e.g. the labels need to be changed to +1 and -1 and the correct classes of the full training matrix need to be used
531          
532          self.training_latency = 0
533  
534          # THIS LIST CONTAINS TRAINING MATRICES AND TRAINING LABELS
535          training_matrices = []
536          training_labels = []
537          no_training_vectors_all = []
538          training_data_1_ind_all = []
539          training_data_2_ind_all = []
540          
541          # keep track of which classifiers we are working on
542          self.classifier_indices = []
543          
544          self.get_training_matrix()
545          self.get_training_labels()
546          self.get_input_details()
547          
548          done = 0
549          current_classifier = 0
550          
551          # this keeps track of what core we are currently generating data for - if all cores have been used or more
552          # need to be used...
553          core_count = 0
554          
555          no_classifiers = int(0.5 * self.no_classes * (self.no_classes - 1))
556          print("no_classifiers -> ", no_classifiers)
557          
558          for n1 in range(self.no_classes):
559              # loop from zero to (no_classes - 1)
560              for n2 in range(n1 + 1, self.no_classes):
561                  # loop from (upper loop index + 1) to (no_classes - 1)
562                                         
563                  # iterate over number of cores
564                  if(core_count < self.no_cores and current_classifier < no_classifiers):
565                      training_data_1_indices = np.where(self.training_labels_data_fi_uint8 == (n1+1))[0]        # postive class
566                      training_data_2_indices = np.where(self.training_labels_data_fi_uint8 == (n2+1))[0]        # negative class
567                      training_data_1_ind_all.append(training_data_1_indices[0])
568                      training_data_2_ind_all.append(training_data_2_indices[0])
569                      
570                      length_class_1 = len(training_data_1_indices)
571                      length_class_2 = len(training_data_2_indices)
572                      no_training_vectors = length_class_1 + length_class_2
573                  
574                      # populate the new training matrix with the two classes in question
575                      # as training matrix has 2 dimensions, find first and last elements of interest
576                      first_index_1 = training_data_1_indices[0] * self.no_variables_int
577                      last_index_1 = (training_data_1_indices[length_class_1 - 1] + 1) * self.no_variables_int
578                      first_index_2 = training_data_2_indices[0] * self.no_variables_int
579                      last_index_2 = (training_data_2_indices[length_class_2 - 1] + 1) * self.no_variables_int
580                      
581                      training_matrix_new = np.zeros(shape=(no_training_vectors*self.no_variables_int), dtype=np.uint16)
582                      training_matrix_new[0:length_class_1*self.no_variables_int] = self.training_mat_data_fi_uint16[first_index_1:last_index_1]
583                      training_matrix_new[length_class_1*self.no_variables_int:(length_class_1*self.no_variables_int+length_class_2*self.no_variables_int)] = self.training_mat_data_fi_uint16[first_index_2:last_index_2]
584                  
585                      # populate training labels with 1s and -1s
586                      training_labels_new = np.zeros(shape=(no_training_vectors), dtype=np.int8)
587                      training_labels_new[0:length_class_1] = 1
588                      training_labels_new[length_class_1:no_training_vectors] = -1
589                  
590                      training_matrices.append(training_matrix_new)
591                      training_labels.append(training_labels_new)
592                      
593                      no_training_vectors_all.append(no_training_vectors)
594                  
595                      current_classifier = current_classifier + 1
596                      core_count = core_count + 1
597                      
598                      self.classifier_indices.append(current_classifier)
599                      
600                  print("current_classifier -> ", current_classifier)
601                      
602                  if(core_count == self.no_cores or current_classifier == no_classifiers):
603                      
604                      self.SMO_parallel(training_matrices, training_labels, training_data_1_ind_all, training_data_2_ind_all, no_training_vectors_all, self.no_variables_int, C, tolerance, max_itr)
605                      core_count = 0
606                      
607                      # reset lists to empty for next parallel iteration
608                      training_matrices = []
609                      training_labels = []
610                      no_training_vectors_all = []
611                      training_data_1_ind_all = []
612                      training_data_2_ind_all = []
613                      
614                      # reset this to empty
615                      self.classifier_indices = []
616          
617  print("DONE")
618  
619  
620  # In[23]:
621  
622  
623  SMO_driver_inst = SMO_driver()
624  
625  
626  # ### RUN vv
627  
628  # In[24]:
629  
630  
631  C = 1
632  tolerance = 0.0001
633  max_itr = 20
634  
635  SMO_driver_inst.SMO_driver_top(C, tolerance, max_itr)
636  
637  print("training latency = ", SMO_driver_inst.training_latency)
638  