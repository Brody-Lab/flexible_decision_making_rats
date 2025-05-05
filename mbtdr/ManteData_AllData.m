function [Xzetai,Xi,Ai,Ri,ni,zzi,SXnorm,xbar,Ybar,Yi] = ManteData_AllData(Data,cntxt,includeTerms,variable_name,ssm,TrainTrials)
% function [Xzetai,Xi,Ai,Ri,ni,zzi,SXnorm] = ManteData_AllData(Data,cntxt,includeTerms,variable_name,ssm,TrainTrials)
% Make sufficient statistics for Mante data using all units
% Motion context- cntxt = 1
% Color context-  cntxt = -1
% ssm - smoothing parameter
% INPUT:
% --------
%     Data - structured array containing data
%     cntxt - {-1,0,1} indicating which context to use. -1 = color, 1 =
%              motion, 0 = both contexts
%     includeTerms - indices of variable_name describing task variables to
%              include in the model.
%     variable_name - String array of variable names listed in Data
%     ssm - smoothing parameter
%     TrainTrials (optional) - Cell array of trials to include for each
%                neuron
%
% OUTPUT:
% ------
%   Xzetai - [Txn] task-variable weighted PSTH
%   Xi - cell array of n (ni x P) design matrices
%   Ai - Xi'*Xi
%   Ri - Xzetai*Xzetai'
%   ni - number of trials for each neuron
%   zzi - squared L2 norm of all observations for each neuron
%   SXnorm - diagonal matrix of normalizing constants

% Last updated: MCA 06/06/17

n = length(Data.unit);%number of units in the data set
T = size(Data.unit(1).response,2);
if iscell(includeTerms) &&  length(includeTerms)>1
    Pt = length(includeTerms);
    P = numel(includeTerms{1});
    for pp = 2:Pt
        P = P + size(includeTerms{pp},1);
    end
else
    P = numel(includeTerms{1});
    Pt = 1;
end
ni = zeros(n,1);
Xi = cell(n,1);
Ai = zeros(P,P,n); Ri = zeros(P*T,P*T,n);  zzi = zeros(n,1);
Xzetai = zeros(P*T,n);
xbar = zeros(n,P);
Ybar = zeros(T,n);
% Loop over neurons
for i = 1:n
    
    % Only use specified trials
    if isempty(TrainTrials)
        trainind = 1:size(Data.unit(i).response,1);
    else
        trainind = TrainTrials{i};
    end
    
    % One context or both?
    if cntxt==0
        trialind = 1:length(Data.unit(i).task_variable.context(trainind));
    else
        trialind = find(Data.unit(i).task_variable.context(trainind) ==cntxt);
    end
    ni(i) = length(trialind);
    
    % Construct design matrix with linear terms
    Xi{i} =[];
    for  p = includeTerms{1}%(1:end-1)
        Xi{i} = [ Xi{i} Data.unit(i).task_variable.(variable_name{p})(trainind(trialind))];
    end
    
    % Add in possible interaction terms
    if Pt>=2
        
        % Go no higher than 3rd order interactions
        if Pt>=3
            ppstop = 3;
        else
            ppstop = 2;
        end
        
        for pp = 2:ppstop% Loop through orders
            for  p = 1:size(includeTerms{pp},1)% Loop through terms
                xtemp = ones(ni(i),1);
                for q = includeTerms{pp}(p,:);% Loop through factors
                    xtemp = xtemp.*Data.unit(i).task_variable.(variable_name{q})(trainind(trialind));
                end
                Xi{i} = [Xi{i} xtemp];
            end
        end
    end
    
    % Add in possible nonlinear, nonpolynomial terms
    if Pt==4
        for  p = 1:size(includeTerms{4},2)% Loop through functions
            for q = includeTerms{4}(:,p)';% Loop through variables
                if p==1% Absolute value
                    fun = @(x)abs(x);
                end
                xtemp = fun(Data.unit(i).task_variable.(variable_name{q})(trainind(trialind)));
                Xi{i} = [Xi{i} xtemp];
            end
        end
    end
%     % Add in easiness term
%     if Pt==5
%         xtemp = zeros(ni(i),1);
%         for k = 1:ni(i)
%             if Xi{i}(k,4)==1
%                 q = 1;% Motion context
%             else
%                 q = 3;% Color context
%             end
%                 xtemp(k) = abs(Data.unit(i).task_variable.(variable_name{q})(trainind(trialind(k))));
%         end
%         Xi{i} = [Xi{i} xtemp];
%     end
%     
end
SXnorm = diag(1./sqrt(mean(cat(1,Xi{:}).^2,1)));%root mean squared stimulus variables for normalization
Yi = cell(n,1);
for i = 1:n
    if isempty(TrainTrials)
        trainind = 1:size(Data.unit(i).response,1);
    else
        trainind = TrainTrials{i};
    end
    
    if cntxt==0
        trialind = 1:length(Data.unit(i).task_variable.context(trainind));
    else
        trialind = find(Data.unit(i).task_variable.context(trainind) ==cntxt);
    end
    smthDat = gsmooth(Data.unit(i).response(trainind(trialind),:)',ssm)';
    Xi{i} = Xi{i}*SXnorm;
    Yi{i} = smthDat';
    zetai = vec(Yi{i});
    Ai(:,:,i)  = Xi{i}'* Xi{i};
    Xzetai(:,i) = kronmult({speye(T),Xi{i}'},zetai);
    Ri(:,:,i)  = Xzetai(:,i)*Xzetai(:,i)';
    zzi(i) = zetai'*zetai;
    
    xbar(i,:) = mean(Xi{i},1)';
    Ybar(:,i) = mean(Yi{i},2);
end

