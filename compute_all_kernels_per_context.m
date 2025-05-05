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


glm.bootstrap=0;
%number of repeats for bootstrap
glm.reps_bootstrap=5;

glm.nthist=20;
glm.include_history=0;


glm.include_choice=1;

%lambda for regularization of regression
glm.lambda1=2^8;





for iii=1:3495
    
    [iii 3495]
    
    
    load(['data/neural_data/cell_' num2str(iii) '.mat']);


    %%% select only trials in the location context
    ind=find(behav.task=='d');

    if(isempty(ind))
        disp('No location trials!')
        glm_fit_loc=[];
    else
        behav_loc.hits=behav.hits(ind);
        behav_loc.stim=behav.stim(ind,:,:);
        behav_loc.side=behav.side(ind);
        behav_loc.task=behav.task(ind);
        behav_loc.gdir=behav.gdir(ind);
        behav_loc.gfreq=behav.gfreq(ind);
        behav_loc.tim=behav.tim(:,ind);
        behav_loc.choice=behav.choice(ind);
        behav_loc.nTrials=length(ind);
        ephys_loc.neural_data=ephys.neural_data(:,ind);
        ephys_loc.neural_data_convolved=ephys.neural_data_convolved(:,ind);

        ephys_loc.neural_data_convolved10=ephys.neural_data_convolved10(:,ind);
        ephys_loc.neural_data_convolved20=ephys.neural_data_convolved20(:,ind);
        ephys_loc.neural_data_convolved30=ephys.neural_data_convolved30(:,ind);


        %%% run glm
        warning off
        glm_fit_loc = run_glm_neuron(behav_loc,ephys_loc);
        warning on
    end





    %%% select only trials in the frequency context
    ind=find(behav.task=='f');

    if(isempty(ind))
        disp('No frequency trials!')
        glm_fit_freq=[];

    else

        behav_freq.hits=behav.hits(ind);
        behav_freq.stim=behav.stim(ind,:,:);
        behav_freq.side=behav.side(ind);
        behav_freq.task=behav.task(ind);
        behav_freq.gdir=behav.gdir(ind);
        behav_freq.gfreq=behav.gfreq(ind);
        behav_freq.tim=behav.tim(:,ind);
        behav_freq.choice=behav.choice(ind);
        behav_freq.nTrials=length(ind);
        ephys_freq.neural_data=ephys.neural_data(:,ind);
        ephys_freq.neural_data_convolved=ephys.neural_data_convolved(:,ind);


        ephys_freq.neural_data_convolved10=ephys.neural_data_convolved10(:,ind);
        ephys_freq.neural_data_convolved20=ephys.neural_data_convolved20(:,ind);
        ephys_freq.neural_data_convolved30=ephys.neural_data_convolved30(:,ind);





        %%% run glm
        warning off
        glm_fit_freq = run_glm_neuron(behav_freq,ephys_freq);
        warning on

    end



    save(['data/neural_kernels_per_context/filter_' num2str(iii)],'glm',...
        'glm_fit_loc','glm_fit_freq');

       
end





