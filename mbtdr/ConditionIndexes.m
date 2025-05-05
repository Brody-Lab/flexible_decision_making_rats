function [newCond, newCondinds] = ConditionIndexes(unique_cond,reginds)
% function [newCond, newCondinds] = ConditionIndexes(unique_cond,reginds) 
% a function to return the conditions and the global conditions indices by
% a specified set of variable indices
% INPUT: 
% unique_cond - C x P array listing all C possible contingencies among P
% task variables
% reginds - [motion choice context correct/incorrect color]
%           array listing the contingencies to return the condition indices
%           for.  An index of 0 indicates to average over all values of this task
%           variable. 
% EXAMPLE:  Return the indices of the conditions corresponding to the following:
%  - average over all values of the motion coherence
%  - choice toward the preferred direction.
%  - motion-context trials
%  - Correct choice
%  - strongest, preferred-direction color coherence
%
% regind = [0 2 2 2 6]
% OUTPUT:
% newCond - list of all contingencies corresponding to the indicated
%           reginds
% newCondinds - Global indices of the contingencies identifies in newCond


% Any variables that have their indices set to 0 will be averaged over
varind = 1:5;
varind(reginds==0) = [];

% Define stimulus conditions
mos = [-.5 -.17 -.06 .06 .17 .5];
chce = [-1 1];
cntxts = [-1 1];
corrs = [0 1];
cols = [-.5 -.17 -.06 .06 .17 .5];

vars{1} = mos;
vars{2} = chce;
vars{3} = cntxts;
vars{4} = corrs;
vars{5} = cols;

newCond = [];
for p = varind
    newCond = [newCond vars{p}(reginds(p))];
end
newCondinds = find(ismember(unique_cond(:,varind),newCond,'rows'));
