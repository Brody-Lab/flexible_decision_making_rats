clear
clc

global glm


%%%%% SET HYPERPARAMETERS


%bin width
resolution=2; 
glm.res=resolution/100;

%pulse duration
duration=65;
%ensure duration can be divided by resolution
if(mod(duration,resolution)~=0)
    duration=duration+1;
end
glm.pulsedur=duration/100;


glm.keep_regression_values=0;

% only consider pulses presented within this interval
% (seconds from stim. onset)
time_limit=65;
glm.limi=[0 time_limit/100];


%limits or time vector (aligned to stim. start)
glm.xmi=-1;
glm.xma=2;


glm.bootstrap=1;
%number of repeats for bootstrap
glm.reps_bootstrap=5;

glm.nthist=20;
glm.include_history=0;


glm.include_choice=1;

%lambda for regularization of regression
glm.lambda1=2^8;




for iii=1:3495
    
    
    load(['data/neural_data/cell_' num2str(iii) '.mat']);

    %%% run glm
    warning off
    glm_fit = run_glm_neuron(behav,ephys);
    warning on


    save(['data/neural_kernels/filter_' num2str(iii)],'glm','glm_fit');

       
end





