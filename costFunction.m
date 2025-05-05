function [J,grad] = costFunction(theta, X, y, lambda)

%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

% from : https://github.com/mohammadaltaleb/Logistic-Regression

% Initialize some useful values
m = length(y); % number of training examples


grad = zeros(size(theta));

h = sigmoid(X * theta);
J = -(1 / m) * sum( (y .* log(h)) + ((1 - y) .* log(1 - h)) );

%%% J grows as the difference between the predicted choice (h) and 
%%% the actual choice (y) grows. If 0, cost is 0. As it approaches
%%% 1, cost goes up to infinity. J is the average cost over trials
% https://ml-cheatsheet.readthedocs.io/en/latest/logistic_regression.html#cost-function
% https://towardsdatascience.com/introduction-to-logistic-regression-66248243c148
% https://towardsdatascience.com/optimization-loss-function-under-the-hood-part-ii-d20a239cde11



numer=(length(theta)-1)/2;
theta1=theta(2:numer+1);
theta2=theta(numer+2:end);


% %nearby points regularization part 1
J = J + lambda*sum(diff(theta1).^2);
% %nearby points regularization part 2
J = J + lambda*sum(diff(theta2).^2);


%%% gradient term for logistic regression
for i = 1 : size(theta, 1)
    grad(i) = (1 / m) * sum( (h - y) .* X(:, i) );
end


%%% gradient term for nearby regularization part 1
gradtemp1=zeros(numer,1);
gradtemp1(1)=lambda*(2*theta1(1)-2*theta1(2));
for i=2:numer-1
    gradtemp1(i)=lambda*(-2*theta1(i-1)+4*theta1(i)-2*theta1(i+1));
end
gradtemp1(numer)=lambda*(2*theta1(end)-2*theta1(end-1));

%%% gradient term for nearby regularization part 2
gradtemp2=zeros(numer,1);
gradtemp2(1)=lambda*(2*theta2(1)-2*theta2(2));
for i=2:numer-1
    gradtemp2(i)=lambda*(-2*theta2(i-1)+4*theta2(i)-2*theta2(i+1));
end
gradtemp2(numer)=lambda*(2*theta2(end)-2*theta2(end-1));

gradtemp=[0;gradtemp1;gradtemp2];

grad=grad+gradtemp;




end
