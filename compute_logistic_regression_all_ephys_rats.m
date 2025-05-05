clear
clc
close all


rat_names={'P049','P055','P059','P095','P100','P101','P102'};



logreg_parameters.lambda=200;

logreg_parameters.min_perf=0.65;
logreg_parameters.min_beta=0.6;
logreg_parameters.min_trials=100;

logreg_parameters.compute_bootstrap=1;
logreg_parameters.bootstrap_reps=20;

logreg_parameters.compute_halfsplit=1;



for iii=1:length(rat_names)
    iii
    rat=rat_names{iii}

    logreg_results{iii}=compute_logreg_rat(rat,logreg_parameters);

    slope_results{iii}=compute_slope(logreg_results{iii});

    location(iii)=slope_results{iii}.d_shap;
    frequency(iii)=slope_results{iii}.f_shap;


end


save data/logistic_regression_results_ephys_rats logreg_results slope_results location frequency


