clear
clc



z=1;
for iii=1:3495
    
    
    load(['data/neural_data/cell_' num2str(iii) '.mat']);

    ntrials=size(ephys.neural_data,2);
    total_time=ntrials*3;
    mean_firing_rate=sum(ephys.neural_data(:))/total_time;

    a(iii)=mean_firing_rate;


    load(['data/neural_kernels/filter_' num2str(iii)]);

    b(iii)=glm_fit.corr_psth;

end


figure

semilogx(a,b,'.k','MarkerSize',10)
ylim([0 1])
xlim([0.2 101])

set(gca,'YTick',[0 0.5 1])
box off
set(gca,'TickDir','out')


