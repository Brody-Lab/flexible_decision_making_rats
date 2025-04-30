clear
clc
close all

%%% This script reproduces panel d of Figure 5.


rat_names={'P049','P055','P059','P095','P100','P101','P102'};

load data/logistic_regression_results_ephys_rats



for iii=1:length(rat_names)

    rat=rat_names{iii};

    slope_results2{iii}=compute_slope(logreg_results{iii});

    location(iii)=slope_results2{iii}.d_shap;
    frequency(iii)=slope_results2{iii}.f_shap;

    clear locations frequencies
    for jjj=1:20

        logreg_results_temp=logreg_results{iii};
        logreg_results_temp.thetadd=logreg_results_temp.thetadds(:,jjj);
        logreg_results_temp.thetadf=logreg_results_temp.thetadfs(:,jjj);
        logreg_results_temp.thetafd=logreg_results_temp.thetafds(:,jjj);
        logreg_results_temp.thetaff=logreg_results_temp.thetaffs(:,jjj);

        slope_results_temp=compute_slope_errorbars(logreg_results_temp,slope_parameters);

        locations(jjj)=slope_results_temp.d_shap;
        frequencies(jjj)=slope_results_temp.f_shap;

    end

    location_se(iii)=std(locations);
    frequency_se(iii)=std(frequencies);




end


[~,ind_loc]=sort(location,'descend');
[~,ind_freq]=sort(frequency,'descend');



for i=1:7
    indice_loc(i)=find(ind_loc==i);
    indice_freq(i)=find(ind_freq==i);
end

ind_loc=indice_loc;
ind_freq=indice_freq;
    



logreg_parameters.type='ratio';

logreg_parameters.lambda=200;

logreg_parameters.min_perf=0.65;
logreg_parameters.min_beta=0.6;
logreg_parameters.min_trials=100;

logreg_parameters.compute_bootstrap=0;
logreg_parameters.bootstrap_reps=20;

logreg_parameters.compute_halfsplit=0;



h=figure;
set(h,'Position',[220          57        1161         592]);


for iii=1:length(rat_names)
    iii
    rat=rat_names{iii};


    subplot(4,7,ind_loc(iii))

    plot_logreg(logreg_results{iii},'location')


    title(rat)


    subplot(4,7,14+ind_freq(iii))


    plot_logreg(logreg_results{iii},'frequency')


    title(rat)


end



for iii=1:length(rat_names)
    iii
    rat=rat_names{iii};

    [loc_neur(iii),freq_neur(iii),loc_neur_se(iii),freq_neur_se(iii)] = get_neurnew(rat);


    subplot(4,7,7+ind_loc(iii))

    plot_neur(rat,'location');




    subplot(4,7,21+ind_freq(iii))

    plot_neur(rat,'frequency');

end





shapes='.s^pvdh';
sizes=[50 20 15 20 15 15 20]*1.3;



figure;
hold on
for i=1:7
    
    sha=shapes(i);
    plot(location(i),loc_neur(i),[sha 'k'],'MarkerSize',sizes(i),'MarkerFaceColor','k')
    
    
    errorbar(location(i),loc_neur(i),location_se(i),'horizontal','k','LineWidth',1)
    
    errorbar(location(i),loc_neur(i),loc_neur_se(i),'vertical','k','LineWidth',1)
    
    
    plot(frequency(i),freq_neur(i),[sha 'b'],'MarkerSize',sizes(i),'MarkerFaceColor','b')


    errorbar(frequency(i),freq_neur(i),frequency_se(i),'horizontal','b','LineWidth',1)
    
    errorbar(frequency(i),freq_neur(i),freq_neur_se(i),'vertical','b','LineWidth',1)
    
    
end
xlabel('Behavioral index')
ylabel('Neural index')
set(gca,'FontSize',20)
box off
set(gca,'TickDir','out')
xlim([-2 1.15])
ylim([-1 2.5])


aaa=[location frequency];
bbb=[loc_neur freq_neur];
[correlation,pvalue]=corr(aaa',bbb')


aaa=[frequency];
bbb=[freq_neur];
[correlation,pvalue]=corr(aaa',bbb')


aaa=[location];
bbb=[loc_neur];
[correlation,pvalue]=corr(aaa',bbb')




