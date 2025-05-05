function w = get_weights(x,y)

% [const,w,allw,Imat] = get_weights(x,y)
%
% This function performs a regularized linear regression to retrieve the 
% kernels describing the selectivity of a single neuron

% GLOBAL VARIABLES: this function assumes the definition of global
% variable "glm" that defines a series of hyperparameters, computed
% by compute_glm_variables
%
% PARAMETERS: regressor matrix "x". Rows indicate time points across
% trials, columns indicate regressors; binned neural activity "y" across
% time and across trials
% 
% RETURNS: regressor matrix "x". Rows indicate time points across
% trials, columns indicate regressors


global glm

% Precompute some quantities (X'X and X'*y)

xx = x'*x;
xx=double(xx);

xy = x'*y;  % spike-triggered average


Imat = eye(size(xx)); 
Imat(1,1) = 0; % don't apply penalty to constant coeff
z=2;
for i=1:length(glm.ngrps)
    if(glm.ngrps(i)==glm.ntfilt)
        Imat(z:z+glm.ngrps(i)-1,z:z+glm.ngrps(i)-1)=Imat(z:z+glm.ngrps(i)-1,z:z+glm.ngrps(i)-1)*glm.lam(i);
        z=z+glm.ngrps(i);
    else
        Imat(z:z+glm.ngrps(i)-1,z:z+glm.ngrps(i)-1)=Imat(z:z+glm.ngrps(i)-1,z:z+glm.ngrps(i)-1)*glm.lam(i);
        z=z+glm.ngrps(i);
    end    
end

D=0;
for i=1:length(glm.ngrps)
    Dx1 = spdiags(ones(glm.ngrps(i),1)*[-1 1],0:1,glm.ngrps(i)-1,glm.ngrps(i));
    Dx = Dx1'*Dx1*glm.lam(i)*32; % computes squared diffs
    D = blkdiag(D,Dx);   
end
D=double(D);


w = (xx+D+Imat) \ xy;


