function [slope_results] = compute_slope(logreg_results)


%%% weight of location evidence in the location context
d(:,1)=logreg_results.thetadd;
%%% weight of location evidence in the frequency context
d(:,2)=logreg_results.thetadf;

%%% weight of frequency evidence in the frequency context
f(:,1)=logreg_results.thetaff;
%%% weight of frequency evidence in the location context
f(:,2)=logreg_results.thetafd;



%%% use only data from the second half of the stimulus
d1=d(14:26,1);
d2=d(14:26,2);

f1=f(14:26,1);
f2=f(14:26,2);

vecx_use=logreg_results.vecx(14:26);



%%% compute slope for location evidence (linear fit)
x=vecx_use;
y=d1-d2;
y=y';
y=y/max(abs(y));
slope_results.pd=polyfit(x,y,1);
slope_results.d_shap=slope_results.pd(1);



%%% compute slope for frequency evidence (linear fit)
x=vecx_use;
y=f1-f2;
y=y';
y=y/max(abs(y));
slope_results.pf=polyfit(x,y,1);
slope_results.f_shap=slope_results.pf(1);

