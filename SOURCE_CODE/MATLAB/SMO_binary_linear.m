function training_model = SMO_binary_linear(training_matrix, training_labels, C)
% SMO_BINARY returns the optimal Lagrange multipliers for the SVM
% optimisation problem, using sequential minimal optimisation (SMO)
% training labels must be +1 and -1, order doesnt matter

% INPUTS %%%%
% training_matrix - for two classes only
% training_labels - for two classes - +1 and -1 only
% C - user cost parameter - adjust behaviour of soft margin

% OUTPUTS %%%%
% training model - file containing the various components of the training
% model

m = length(training_matrix(:,1));   % no. observations of training dataset
alpha = single(zeros(m,1));                 % lagrange multipliers for SVM optimisation problem
y = training_labels;                % training labels corresponding to dataset
b = 0;                              % offset of hyperplane for this binary problem
tolerance = single(0.0001);                 % tolerance for checking KKT violations and if changes made to Lagrange multipliers

% C = 1;                              % defined by the user

max_it = 20;                        % pre-defined maximum number of iterations
no_itr = 0;                         % count number of iterations

for it = 1:1:max_it
    changed_alphas = 0;
    for p = 1:1:m
    
        x_p = (training_matrix(p,:))';     % get training vector p
        y_p = training_labels(p);       % training label p
    
        % comput the position of x_p relative to the current hyperplane,
        % defined by the current lagrange multipliers and current offset
        dot_product_vector = training_matrix*x_p;  % compute the matrix of dot product values of the training matrix and current training vector
        % dot_product_matrix - mx1 matrix
        u_p = single(0);
        u_p = sum(alpha.*y.*dot_product_vector) + b;   % uses old alpha values
    
        E_p = single(0);
        E_p = u_p - y_p;                % compute error term for this training vector
    
        alpha_p_old = alpha(p);         % old (current) version of alpha_p
    
        % check if KKT violation
        yp_Ep = y_p * E_p;    
        if((alpha_p_old < C && yp_Ep < -tolerance) || (alpha_p_old > 0 && yp_Ep > tolerance))   % KKT conditions violated
            for q = 1:1:m
                % only do this for alpha_p =/ alpha_q
                if(p ~= q)
                    x_q = (training_matrix(q,:))';     % get training vector q
                    y_q = training_labels(q);       % training label q
        
                    % same as above - compute x_q position relative to hyperplane 
                    dot_product_vector = training_matrix*x_q;  % compute the matrix of dot product values of the training matrix and current training vector
                    % dot_product_matrix - mx1 matrix
                    u_q = sum(alpha.*y.*dot_product_vector) + b;
        
                    E_q = u_q - y_q;
        
                    alpha_p_old = alpha(p);         % old (current) version of alpha_p
                    alpha_q_old = alpha(q);         % get old (current) versions of alpha_q
        
                    s = y_p * y_q;
        
                    % check if s = 1, else s = -1 => s = y_p * y_q
                    % compute upper and lower bounds for alpha_q_new
                    if(s == 1)
                        L = max([0, alpha_p_old + alpha_q_old - C]);
                        H = min([alpha_p_old + alpha_q_old, C]);
                    else
                        L = max([0, alpha_q_old - alpha_p_old]);
                        H = min([C + alpha_q_old - alpha_p_old, C]);
                    end
                    
                    if(L == H)
                        continue; 
                    end
        
                    % compute eta - kernel product will be here
                    eta = 2 * x_p' * x_q - x_p' * x_p - x_q' * x_q;
        
                    % compute the new value of alpha_q - used to calculate new alpha_p
                    alpha_q_new = alpha_q_old + y_q * (E_q - E_p) / eta;
        
                    % we need to consider the original wolfe dual constraint (lagrange
                    % multipliers must be in range [0,C] - (inclusive of ends)
        
                    if(alpha_q_new >= H)
                        alpha_q_new = H;
                    elseif(alpha_q_new <= L)
                        alpha_q_new = L;
                    end
                    % (else alpha_q_new remains same - already satisfied constraint)
        
                    % if alpha_q_new same as alpha_q_old - no need to update
                    % alpha_p_new
                    alpha_p_new = alpha_p_old;
        
                    % only need to compute new alpha_p if change in alpha_q
                    if(abs(alpha_q_new - alpha_q_old) > tolerance)
                        % update alpha_p
                        alpha_p_new = alpha_p_old - s * (alpha_q_new - alpha_q_old);
            
                        % we need to update the weights vector and bias
                        % the weights vector is implicitly updated by changing alpha_p
                        % and alpha_q
                        delta_p = alpha_p_new - alpha_p_old;
                        delta_q = alpha_q_new - alpha_q_old;

                        b_p_new = b - E_p - delta_p * y_p * x_p' * x_p - delta_q * y_q * x_q' * x_p;
                        b_q_new = b - E_q - delta_p * y_p * x_p' * x_q - delta_q * y_q * x_q' * x_q;
                        % we use this if one of alpha_p_new or alpha_q_new correspond
                        % to a support vector => 0 < alpha_k_new < C
            
                        if(alpha_p_new > 0 && alpha_p_new < C)
                            b = b_p_new;
                        elseif(alpha_q_new > 0 && alpha_q_new < C)
                            b = b_q_new;
                        else
                            b = (b_p_new + b_q_new) / 2;    % take average - there are other ways to handle this case
                        end
                        
                        changed_alphas = changed_alphas + 1;
                    end
                    
                    % update alpha values
                    alpha(p) = alpha_p_new;
                    alpha(q) = alpha_q_new;
                                        
                end 
            end 
        end
    end
    if(changed_alphas == 0)
        break; 
    end
    no_itr = no_itr + 1;
end

% populate training model struct
sv_coeffs = 0;
sv_indices = 0;
no_svs = 0;

for n1 = 1:1:m
    % check if current alpha not equal to zero - SUPPORT VECTOR
    if(alpha(n1) > tolerance || alpha(n1) < -tolerance)
        if(no_svs == 0)
            sv_coeffs = alpha(n1) * y(n1);
            sv_indices = n1;
        else
            sv_coeffs = [sv_coeffs; alpha(n1) * y(n1)];
            sv_indices = [sv_indices; n1];
        end
        no_svs = no_svs + 1;
    end
end

training_model.sv_coeffs = sv_coeffs;
training_model.sv_indices = sv_indices;
training_model.no_svs = no_svs;
training_model.no_itr = no_itr;
training_model.offset = b;

end

