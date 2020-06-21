function [kernel_fn_output] = kernel_functions(vector_1,vector_2, kernel_type, varargin)
% KERNEL_FUNCTIONS returns the value of the kernel computation between the
% two input vectors
% INPUTS %%%%
% vector_1, vector_2 - *ROW* vectors of same length
% kernel_type - string either "linear", "polynomial", "rbf"
% varargin - specify extra arguments, c, d and gamma for the polynomial and
% radial basis function (rbf) kernels
% OUTPUTS %%%%
% kernel_fn_output - result of the kernel computation

if(kernel_type == 0)
    kernel_fn_output = vector_1 * vector_2';
elseif(kernel_type == 1)
    r = varargin{1};
    d = varargin{2};
    gamma = varargin{3};
    kernel_fn_output = (gamma * vector_1 * vector_2' + r)^d;
elseif(kernel_type == 2)
    gamma = varargin{3};
%     kernel_fn_output = exp(-gamma * (norm(vector_1 - vector_2))^2);
    kernel_fn_output = exp(-gamma * sum((vector_1 - vector_2).^2));
else
    print("kernel type not recognised");
end

end

