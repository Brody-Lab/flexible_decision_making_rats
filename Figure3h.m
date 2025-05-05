clear
clc
close all


rat_names={'P049','P055','P059','P095','P100','P101','P102'};



for iii=1:length(rat_names)
    iii
    rat=rat_names{iii}

    [loc_neur(iii),freq_neur(iii),loc_neur_se(iii),freq_neur_se(iii)] = get_neural_slope(rat);


end




figure;
hold on
for i=1:7
    
    sha='^';
    plot(loc_neur(i),freq_neur(i),[sha 'k'],'MarkerSize',15,'MarkerFaceColor','k')
    

    
end
xlabel('LOC slope index')
ylabel('FRQ slope index')
set(gca,'FontSize',20)
box off
set(gca,'TickDir','out')

