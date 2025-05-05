clear
clc


d=dir('data/Sessions_trials/*sessions.mat');

nrats=length(d);


z=1;
for iii=1:nrats
    
    [iii nrats]
    
    
    rats{iii}=d(iii).name(1:4);
    
    
    load(['data/Sessions_trials/' d(iii).name]);
    
    [az1d2f(:,iii),az2d2f(:,iii),az1f2d(:,iii),az2f2d(:,iii)] = compute_taskswitch(sessions,trials);

end


save data/taskswitch_all_rats az1d2f az2d2f az1f2d az2f2d d






