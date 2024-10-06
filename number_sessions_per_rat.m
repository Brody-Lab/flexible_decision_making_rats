clear
clc

%%% This script determines the total number of sessions
%%% and the total number of trials available per rat


%%% create a list of all rat with behavioral data
d=dir('data/Sessions_trials/*sessions.mat');

%%% total number of rats
nrats=length(d);


for iii=1:nrats
    
    [iii nrats]
    
    %%% rat name
    rats{iii}=d(iii).name(1:4);
    
    %%% load behavioral data
    load(['data/Sessions_trials/' d(iii).name]);
    
    %%% total number of sessions
    num(iii)=length(sessions);
    
    %%% total number of "good" sessions
    numgood(iii)=sum([sessions.good]);
    



    minperf=.7; %min performance
    mintri=100; %min number of trials
    minbe=.7; %min beta coefficient
    
    
    %%% total number of trials from sessions with good performance
    hits = ...
        get_trials_stim(sessions,trials,minperf,mintri,minbe);
    
    numhits(iii)=length(hits);
    
    
    
end


%%% save data
save('data/numsessions_all_rats.mat','rats',...
    'num','numgood','numhits');



