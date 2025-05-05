function [XX, XY,Yn,allstim,n,T] = MkSuffStats_BilinReg_Data(Data,includeTerms,variable_name,cntxt,ssm,TrainTrials)

n = length(Data.unit);%number of units in the data set
T = size(Data.unit(1).response,2);
allstim = cell(n,1);
Yn = cell(n,1); % neural responses (each cell has resps for one neuron)
ntrials = zeros(n,1);
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

for i = 1:n  % loop over neurons
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
    
    ntrials(i) = length(trialind);
    
    % Construct design matrix with linear terms
    for  p = includeTerms{1}(1:end-1)
        allstim{i} = [ allstim{i} Data.unit(i).task_variable.(variable_name{p})(trainind(trialind))];
    end
    if Pt>=2% Add in possible quadratic terms
        for  pq = 1:size(includeTerms{2},1)
            p = includeTerms{2}(pq,1);q = includeTerms{2}(pq,2);
            allstim{i} = [ allstim{i}...
                Data.unit(i).task_variable.(variable_name{p})(trainind(trialind)).*...
                Data.unit(i).task_variable.(variable_name{q})(trainind(trialind))];
        end
    end
    % Add in possible nonlinear, nonpolynomial terms
    if Pt==4
        for  p = 1:size(includeTerms{4},2)% Loop through functions
            if p==1% Absolute value
                fun = @(x)abs(x);
            end
            for q = includeTerms{4}(:,p)';% Loop through variables
                xtemp = fun(Data.unit(i).task_variable.(variable_name{q})(trainind(trialind)));
                allstim{i} = [allstim{i} xtemp];
            end
        end
    end
        % Add in easiness term
    if Pt==5
        xtemp = zeros(ntrials(i),1);
        for k = 1:ntrials(i)
            if allstim{i}(k,4)==1
                q = 1;% Motion context
            else
                q = 3;% Color context
            end
                xtemp(k) = abs(Data.unit(i).task_variable.(variable_name{q})(trainind(trialind(k))));
        end
        allstim{i} = [allstim{i} xtemp];
    end

    % Add baseline term
    allstim{i} = [ allstim{i}  ones(ntrials(i),1)];
    
    
    smthDat = gsmooth(Data.unit(i).response(trainind(trialind),:)',ssm)';
    
    %     Yn{i} = Data.unit(i).response(trialind,:);
    Yn{i} = smthDat;
end
It = speye(T);  % sparse matrix of size for 1 trial for one variable
XXperneuron = cell(1,n); % cell array for XX terms
XYperneuron = zeros(T*P,n); % matrix for XY terms
msqrX =  diag(1./sqrt(mean(cat(1,allstim{:}).^2,1)));%mean squared stimulus variables for normalization

for jx = 1:n
    allstim{jx} = allstim{jx}*msqrX;
    stm = allstim{jx}; % grab relevant stimuli
    XXperneuron{jx} = kron(stm'*stm,It); % (multiply before kron)
    XYperneuron(:,jx) = vec(reshape(Yn{jx},T,ntrials(jx))*stm); % (avoids kron)
end
% Construct block-diagonal XX matrix and XY vector
XX = blkdiag(XXperneuron{:});
XY = XYperneuron(:);

% Permute indices so coefficients grouped by matrix instead of by neuron
% Map [ntrials x nx
nwtot = P*T*n;
iiperm = reshape(1:nwtot,T,P,n);
iiperm = vec(permute(iiperm,[1 3 2]));
XX = XX(iiperm,iiperm);
XY = XY(iiperm);
