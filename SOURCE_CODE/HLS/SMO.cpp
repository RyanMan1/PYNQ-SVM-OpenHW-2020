1   #include "SMO.h"
2   
3   dot_products dot_product(data_vectors row_vec[n], data_vectors col_vec[n], n_variables *no_variables){
4   
5   	// return the dot product between two input vectors
6   
7   	dot_products accumulate = 0.0;
8   
9   	dot_product_accum: for(loop_ind_n n1 = 0; n1 < n; n1++){
10  #pragma HLS PIPELINE
11  		if(n1 < *no_variables){
12  			accumulate = accumulate + row_vec[n1] * col_vec[n1];
13  		}
14  		else{
15  			break;
16  		}
17  	}
18  
19  	return accumulate;
20  
21  }
22  
23  void get_training_vector(training_matrix_stream &training_matrix,
24  						 data_vectors x_q[n],
25  						 n_variables *no_variables){
26  
27  	// return training vector at index q - correct streaming of training matrix is ensured in calling function
28  	get_training_vector_loop: for(loop_ind_n n1 = 0; n1 < n; n1++){
29  		if(n1 < *no_variables){
30  			x_q[n1] = training_matrix.read().data;
31  		}
32  		else{
33  			break;
34  		}
35  	}
36  
37  }
38  
39  inter_values get_u_k(dot_product_matrix_stream &dot_product_matrix,
40  		   	 class_labels y[m],
41  			 alphas_AXIS alpha[m],
42  			 n_training_vectors *no_training_vectors,
43  			 n_variables *no_variables,
44  			 training_details *offset){
45  
46  	// compute the value of u_k - functional value of data vector x_k - indicates which side of current hyperplane (defined by alpha and b) the point x_k
47  	// is on and how far it is from the hyperplane relative to the support vectors being a functional margin of one from the hyperplane
48  
49  	inter_values accumulator = 0.0;
50  
51  	u_k_accum: for(loop_ind_m n1 = 0; n1 < m; n1++){
52  #pragma HLS PIPELINE
53  		if(n1 < *no_training_vectors){
54  			// each read of the dot product matrix stream is the next element in the dot product vector - length of vector is no_training_vectors
55  			accumulator += alpha[n1].data * y[n1] * dot_product_matrix.read().data;
56  		}
57  		else{
58  			break;
59  		}
60  	}
61  
62  	// return functional value for x_k
63  	return accumulator + *offset;
64  }
65  
66  void SMO_p_loop_linear(dot_product_matrix_stream &dot_product_matrix,
67  					   training_matrix_stream &training_matrix,
68  					   data_vectors x_p[n],
69  					   class_labels y[m],
70  					   alphas_AXIS alpha[m],
71  					   n_training_vectors *no_training_vectors,
72  					   n_variables *no_variables,
73  					   training_details *C,
74  					   training_details *tolerance,
75  					   training_details *offset,
76  					   inter_values *E_p,
77  					   training_data_indices *p_in,
78  					   n_training_vectors *changed_alphas){
79  
80  	// return the updated lagrange multipliers (alpha) for some p value
81  
82  	training_data_indices p = *p_in - 1;		// only used for indexing - subtract one
83  	training_details offset_temp = *offset;
84  	training_details changed_alphas_temp = *changed_alphas;
85  
86  	// compute and store for use in each iteration
87  	dot_products xp_xp = dot_product(x_p, x_p, no_variables);
88  
89  	// loop over alpha_q values - this will happen if KKT violation with alpha_p (decided in processing system)
90  	SMO_q_loop:for(loop_ind_m q = 0; q < m; q++){
91  		if(q < *no_training_vectors){
92  			if(q == p){
93  				// also need to read one of the vectors of dot product values at index p
94  				for(loop_ind_m n1 = 0; n1 < m; n1++){
95  					if(n1 < *no_training_vectors){
96  						dot_product_matrix.read();
97  					}
98  					else{
99  						break;
100 					}
101 				}
102 				// still need to read the vector at index p of the dot product matrix to ensure true streaming
103 				for(loop_ind_n n1 = 0; n1 < n; n1++){
104 					if(n1 < *no_variables){
105 						training_matrix.read();			// read, dont store in memory
106 					}
107 					else{
108 						break;
109 					}
110 				}
111 			}
112 			else{
113 				// get u_q
114 				inter_values u_q = 0;
115 				u_q = get_u_k(dot_product_matrix, y, alpha, no_training_vectors, no_variables, &offset_temp);
116 
117 				// get E_q - error term - indicates error between label and functional value
118 				inter_values E_q = 0;
119 				E_q = u_q - y[q];
120 
121 				// get old (current) version of both alpha values
122 				alphas alpha_p_old = alpha[p].data;
123 				alphas alpha_q_old = alpha[q].data;
124 
125 				// compute s - either 1 or -1
126 				class_labels s = y[p] * y[q];
127 
128 				// check if s = 1, else s = -1 => s = y_p * y_q
129                 // compute upper and lower bounds for alpha_q_new
130 				alphas L = 0;
131 				alphas H = 0;
132 				if(s == 1){
133 					// classes for x_p and x_q are same
134 					if((alpha_p_old + alpha_q_old - *C) > 0){
135 						L = alpha_p_old + alpha_q_old - *C;
136 					}
137 					else{
138 						L = 0;
139 					}
140 					if((alpha_p_old + alpha_q_old) < *C){
141 						H = alpha_p_old + alpha_q_old;
142 					}
143 					else{
144 						H = *C;
145 					}
146 				}
147 				else{
148 					// s =/= 1 - classes are not the same
149 					if((alpha_q_old - alpha_p_old) > 0){
150 						L = alpha_q_old - alpha_p_old;
151 					}
152 					else{
153 						L = 0;
154 					}
155 					if((*C + alpha_q_old - alpha_p_old) < *C){
156 						H = *C + alpha_q_old - alpha_p_old;
157 					}
158 					else{
159 						H = *C;
160 					}
161 				}
162 
163 				// check if L and H are equal
164 				if((H - *tolerance) < L){
165 					// need to read training matrix, index q - since continuing past read below
166 					for(loop_ind_n n1 = 0; n1 < n; n1++){
167 						if(n1 < *no_variables){
168 							training_matrix.read();
169 						}
170 					}
171 					continue;
172 				}
173 
174 				// compute eta - kernel product here for kernelised SVM - this version linear so kernel function is dot product
175 				inter_values eta = 0;
176 				// get x_q
177 				data_vectors x_q[n];
178 				get_training_vector(training_matrix, x_q, no_variables);
179 				dot_products xp_xq = dot_product(x_p, x_q, no_variables);
180 				dot_products xq_xq = dot_product(x_q, x_q, no_variables);
181 
182 				//eta = 2 * dot_product(x_p, x_q) - dot_product(x_p, x_p) - dot_product(x_q, x_q);
183 				eta = 2 * xp_xq - xp_xp - xq_xq;
184 
185 				// compute the new value of alpha_q - used to calculate new alpha_p
186 				alphas alpha_q_new = alpha_q_old + y[q] * (E_q - *E_p) / eta;
187 
188 				// we need to consider the original wolfe dual constraint (lagrange multipliers must be in range [0,C] - (inclusive of ends)
189 				if(alpha_q_new >= H){
190 					alpha_q_new = H;
191 				}
192 				else if(alpha_q_new <= L){
193 					alpha_q_new = L;
194 				}
195 				// (else stays the same - constraint satisfied)
196 
197 				// if alpha_q_new same as alpha_q_old - no need to update alpha_p_new
198 				alphas alpha_p_new = alpha_p_old;
199 
200 				// update alphas vector
201 				alpha[p].data = alpha_p_new;
202 				alpha[q].data = alpha_q_new;
203 
204 				// only need to compute new alpha_p if change in alpha_q
205 				/*if(abs(alpha_q_new - alpha_q_old) < *tolerance){
206 					continue;
207 				}*/
208 				alphas delta_q = alpha_q_new - alpha_q_old;
209 				if((delta_q <= 0) && (delta_q > (0 - *tolerance))){
210 					continue;
211 				}
212 				else if((delta_q >= 0) && (delta_q < *tolerance)){
213 					continue;
214 				}
215 				// else continue
216 
217 				// update alpha_p
218 				alpha_p_new = alpha_p_old - s * (alpha_q_new - alpha_q_old);
219 
220 				// we need to update the weights vector and BIAS(OFFSET); the weights vector is implicitly updated by changing alpha_p and alpha_q
221 				alphas delta_p = alpha_p_new - alpha_p_old;
222 				//alphas delta_q = alpha_q_new - alpha_q_old;
223 
224 				dot_products xq_xp = dot_product(x_q, x_p, no_variables);
225 				training_details b_p_new = offset_temp - *E_p - delta_p * y[p] * xp_xp - delta_q * y[q] * xq_xp;
226 				training_details b_q_new = offset_temp - E_q - delta_p * y[p] * xp_xq - delta_q * y[q] * xq_xq;
227 				//we use this if one of alpha_p_new or alpha_q_new correspond to a support vector => 0 < alpha_k_new < C
228 
229 				if((alpha_p_new > 0) && (alpha_p_new < *C)){
230 					offset_temp = b_p_new;
231 				}
232 				else if((alpha_q_new > 0) && (alpha_q_new < *C)){
233 					offset_temp = b_q_new;
234 				}
235 				else{
236 					offset_temp = (b_p_new + b_q_new) / 2;
237 				}
238 
239 				alpha[p].data = alpha_p_new;					// update alphas vector
240 
241 				changed_alphas_temp = changed_alphas_temp + 1;	// updated an alpha value
242 			}
243 		}
244 		else{
245 			break;
246 		}
247 	}
248 
249 	*offset = offset_temp;
250 	*changed_alphas = changed_alphas_temp;
251 }
252 
253 void SMO_outer(dot_product_matrix_stream &dot_product_matrix_outer,
254 		 	   dot_product_matrix_stream &dot_product_matrices_inner,
255 			   class_labels y[m],
256 			   training_matrix_stream &training_matrix_outer,
257 			   training_matrix_stream &training_matrices_inner,
258 			   alphas_AXIS alpha[m],
259 			   n_training_vectors *no_training_vectors,
260 			   n_variables *no_variables,
261 			   training_details *C,
262 			   training_details *tolerance,
263 			   n_max_itr *max_itr_user,
264 			   indicators_stream &kkt_violations,
265 			   scalars_stream &output_details){
266 // this function iterates over the p values, calling the inner loop function (all of the q loops) as needed
267 // also, it iterates some maximum number of times as specified by the user in the "max_itr_user" parameter
268 
269 	n_training_vectors changed_alphas = 0;
270 
271 	training_details no_itr;
272 	training_details offset;
273 
274 	no_itr = 0;
275 	offset = 0;
276 
277 	max_itr_loop: for(loop_ind_itr n1 = 0; n1 < max_itr_abs; n1++){
278 		if(n1 < *max_itr_user){
279 			changed_alphas = 0;
280 
281 			// loop over all p values
282 			smo_p_loop: for(loop_ind_m p = 0; p < m; p++){
283 				if(p < *no_training_vectors){
284 					class_labels y_p = y[p];
285 
286 					// get u_p
287 					inter_values u_p = get_u_k(dot_product_matrix_outer, y, alpha, no_training_vectors, no_variables, &offset);
288 
289 					// compute the error term for training vector x_p, E_p
290 					inter_values E_p = u_p - y_p;
291 
292 					// get alpha_p_old
293 					alphas alpha_p_old = alpha[p].data;
294 
295 					inter_values yp_Ep = y_p * E_p;
296 
297 					// get x_p
298 					data_vectors x_p[n];
299 					get_training_vector(training_matrix_outer, x_p, no_variables);
300 
301 					// check for KKT violation - need two if statements as the second one wil not be entered unless the inner matrices are made
302 					// available on the mm2s (memory-map to stream)
303 					//bool kkt_check = (alpha_p_old < *C && yp_Ep < -*tolerance) || (alpha_p_old > 0 && yp_Ep > *tolerance);
304 					if((alpha_p_old < *C && yp_Ep < -*tolerance) || (alpha_p_old > 0 && yp_Ep > *tolerance)){
305 						// indicate to the processing system, a KKY violation has taken place and the inner matrices should be transferred
306 						indicators_AXIS kkt_viol_AXIS;
307 						kkt_viol_AXIS.data = 1;
308 						kkt_viol_AXIS.last = 1;
309 						kkt_violations.write(kkt_viol_AXIS);
310 					}
311 					if((alpha_p_old < *C && yp_Ep < -*tolerance) || (alpha_p_old > 0 && yp_Ep > *tolerance)){
312 						// call function to iterate over all q loops
313 						training_data_indices p_in = p + 1;
314 						SMO_p_loop_linear(dot_product_matrices_inner,
315 										  training_matrices_inner,
316 										  x_p,
317 										  y,
318 										  alpha,
319 										  no_training_vectors,
320 										  no_variables,
321 										  C,
322 										  tolerance,
323 										  &offset,
324 										  &E_p,
325 										  &p_in,
326 										  &changed_alphas);
327 					}
328 					else{
329 						// indicate to processing system when there is no KKT violation
330 						indicators_AXIS kkt_viol_AXIS;
331 						kkt_viol_AXIS.data = 2;
332 						kkt_viol_AXIS.last = 1;
333 						kkt_violations.write(kkt_viol_AXIS);
334 					}
335 					// FOR TESTING...
336 					// in actual design we will simply not load enough inner training matrices and dot product matrices to break the DMA transfer
337 					// i.e. only the correct amount for data will be passed to dma
338 					/*else{
339 						// read the inner training matrix
340 						for(loop_ind i = 0; i < m; i++){
341 							if(i < *no_training_vectors){
342 								for(loop_ind j = 0; j < n; j++){
343 									if(j < *no_variables){
344 										training_matrices_inner.read();
345 									}
346 								}
347 							}
348 						}
349 						// read the inner dot product matrix
350 						for(loop_ind i = 0; i < m; i++){
351 							if(i < *no_training_vectors){
352 								for(loop_ind j = 0; j < m; j++){
353 									if(j < *no_training_vectors){
354 										dot_product_matrices_inner.read();
355 									}
356 								}
357 							}
358 						}
359 					}*/
360 					// FOR TESTING...
361 				}
362 				else{
363 					break;
364 				}
365 			}
366 
367 			// in this case, we do not need to do any more SMO iterations
368 			if(changed_alphas == 0){
369 				break;
370 			}
371 
372 			no_itr = no_itr + 1;
373 
374 			// send indication to PS that we should go to next iteration
375 			scalars_AXIS no_itr_AXIS;
376 			no_itr_AXIS.data = no_itr;
377 			no_itr_AXIS.last = 1;
378 			output_details.write(no_itr_AXIS);
379 
380 		}
381 		else{
382 			break;
383 		}
384 	}
385 
386 	scalars_AXIS offset_AXIS;
387 	offset_AXIS.data = offset;
388 	offset_AXIS.last = 1;
389 	output_details.write(offset_AXIS);
390 
391 }
392 
393 void SMO_top(dot_product_matrix_stream &dot_product_matrix_outer,
394 			 dot_product_matrix_stream &dot_product_matrices_inner,
395 			 training_labels_stream &training_labels_in,
396 			 training_matrix_stream &training_matrix_outer,
397 			 training_matrix_stream &training_matrices_inner,
398 			 input_details_stream &input_details,
399 			 alphas_stream &alpha_out,
400 			 indicators_stream &kkt_violations,
401 			 scalars_stream &output_details){
402 #pragma HLS INTERFACE axis port=kkt_violations
403 #pragma HLS INTERFACE ap_ctrl_none port=return
404 #pragma HLS INTERFACE axis port=dot_product_matrix_outer
405 #pragma HLS INTERFACE axis port=dot_product_matrices_inner
406 #pragma HLS INTERFACE axis port=training_labels_in
407 #pragma HLS INTERFACE axis port=training_matrix_outer
408 #pragma HLS INTERFACE axis port=training_matrices_inner
409 #pragma HLS INTERFACE axis port=input_details
410 #pragma HLS INTERFACE axis port=alpha_out
411 #pragma HLS INTERFACE axis port=output_details
412 
413 	// get various scalar parameters from input details stream - unsigned integers
414 	n_training_vectors no_training_vectors = ap_uint<16>(input_details.read().data);
415 	n_variables no_variables = ap_uint<9>(input_details.read().data);
416 	n_max_itr max_itr = ap_uint<8>(input_details.read().data);
417 	training_details tolerance = ap_fixed<32,12>(input_details.read().data);
418 	training_details C = ap_fixed<32,12>(input_details.read().data);
419 
420 	// store training labels
421 	class_labels y[m];
422 //#pragma HLS RESOURCE variable=y core=RAM_2P_BRAM
423 	for(loop_ind_m n1 = 0; n1 < m; n1++){
424 		if(n1 < no_training_vectors){
425 			y[n1] = ap_int<2>(training_labels_in.read().data);
426 		}
427 		else{
428 			break;
429 		}
430 	}
431 
432 	// store alpha values
433 	alphas_AXIS alpha[m];
434 //#pragma HLS RESOURCE variable=alpha core=RAM_2P_BRAM
435 	for(loop_ind_m n1 = 0; n1 < m; n1++){
436 		if(n1 < no_training_vectors){
437 			alpha[n1].data = 0;
438 			alpha[n1].last = 0;
439 		}
440 		else{
441 			break;
442 		}
443 	}
444 	alpha[no_training_vectors - 1].last = 1;
445 
446 	training_details no_itr = 0;
447 	training_details offset = 0;
448 
449 	// call next function
450 	SMO_outer(dot_product_matrix_outer,
451 			  dot_product_matrices_inner,
452 			  y,
453 			  training_matrix_outer,
454 			  training_matrices_inner,
455 			  alpha,
456 			  &no_training_vectors,
457 			  &no_variables,
458 			  &C,
459 			  &tolerance,
460 			  &max_itr,
461 			  kkt_violations,
462 			  output_details);
463 
464 	// output resulting alpha values and new offset/changed alphas to streams
465 	/*scalars_AXIS offset_AXIS;
466 	offset_AXIS.data = offset;
467 	offset_AXIS.last = 0;
468 	output_details.write(offset_AXIS);
469 
470 	scalars_AXIS no_itr_AXIS;
471 	no_itr_AXIS.data = no_itr;
472 	no_itr_AXIS.last = 1;
473 	output_details.write(no_itr_AXIS);*/
474 
475 	// output alpha stream
476 	for(loop_ind_m n1 = 0; n1 < m; n1++){
477 		if(n1 < no_training_vectors){
478 			alpha_out.write(alpha[n1]);
479 		}
480 		else{
481 			break;
482 		}
483 	}
484 
485 }
486 