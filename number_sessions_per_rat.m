clear
clc

d=dir('data/Sessions_trials/*sessions.mat');

nrats=length(d);


for iii=1:nrats
    
    [iii nrats]
    
    
    rats{iii}=d(iii).name(1:4);
    
    
    load(['data/Sessions_trials/' d(iii).name]);
    

    num(iii)=length(sessions);
    
    numgood(iii)=sum([sessions.good]);
    


    minperf=.7;
    mintri=100;
    minbe=.7;
    
    

    hits = ...
        get_trials_stim_be(sessions,trials,minperf,mintri,minbe);
    

    numhits(iii)=length(hits);
    
    
    
end



save([data_base_dir '/numsessions_all_rats.mat'],'rats',...
    'num','numgood','numhits');



