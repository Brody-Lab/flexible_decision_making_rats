function theta = logregression(X,y,lambda)

%%% compute regularized logistic regression

%  Setup the data matrix appropriately
[m, n] = size(X);

% Initialize fitting parameters
initial_theta = zeros(n, 1);

options = optimset('GradObj', 'on', 'MaxIter', 400,'Display', 'off');

theta = fminunc(@(t)(costFunction(t, X, y, lambda)), initial_theta, options);



end
