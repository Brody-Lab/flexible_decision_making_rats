function g = sigmoid(z)
%SIGMOID Compute sigmoid function
%   J = SIGMOID(z) computes the sigmoid of z.

g = 1 ./ (1 + exp(-z));


end
