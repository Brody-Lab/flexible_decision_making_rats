function [] = compute_logistic_regression(ratto)


nreps=50;

load(['data/Sessions_trials/' ratto '_sessions.mat']);


minperf=.7;
minbeta=.7;
mintri=100;


ind=find([sessions.hit]>=minperf & (([sessions.bdir]+[sessions.bfreq])/2)>=minbeta & ...
    [sessions.valid]>=mintri & [sessions.good]==1);

sessions=sessions(ind);
trials=trials(ind);





[hits,task,choice,gfreq,gdir,side,nta,vecr,vecl,vechi,veclo] = ...
    get_trials_stim(sessions,trials,minperf,mintri,minbeta);

vec=0:.01:1.3;

vec(end)=vec(end)+eps;

di=diff(vec);
di=di(1);
vecx=vec+di/2;
vecx=vecx(1:end-1);



%%% 50ms steps
downsamp=5;
lambda=200;




down2=round(downsamp/2);

%%% downsample by "downsamp"
mat=vecr;
mat=conv2(mat,ones(1,downsamp),'same');
mat=mat(:,down2:downsamp:size(mat,2));
vecr=mat;

mat=vecl;
mat=conv2(mat,ones(1,downsamp),'same');
mat=mat(:,down2:downsamp:size(mat,2));
vecl=mat;

mat=vechi;
mat=conv2(mat,ones(1,downsamp),'same');
mat=mat(:,down2:downsamp:size(mat,2));
vechi=mat;

mat=veclo;
mat=conv2(mat,ones(1,downsamp),'same');
mat=mat(:,down2:downsamp:size(mat,2));
veclo=mat;


vecx=vecx(down2:downsamp:length(vecx));


vecr=vecr+eps;
vecl=vecl+eps;
vechi=vechi+eps;
veclo=veclo+eps;

%%% strength of location evidence per bin
gammadir=log(vecr./vecl);
%%% strength of frequency evidence per bin
gammafreq=log(vechi./veclo);




disp('location')



%%% analyze location trials
choice1=choice(task=='d');
gammadir1=gammadir(task=='d',:);
gammafreq1=gammafreq(task=='d',:);
yd=choice1;
Xd=[gammadir1 gammafreq1];

%  Setup the data matrix appropriately
[m, n] = size(Xd);
% Add intercept term
Xd = [ones(m, 1) Xd];

thetad = logregression(Xd,yd,lambda);


%%% bootstrap to compute error bars 
clear thetads
for i=1:nreps    
    ind=randsample(1:size(Xd,1),size(Xd,1),true);    
    thetads(:,i) = logregression(Xd(ind,:),yd(ind),lambda);    
end
thetad_se=std(thetads,[],2);


%%% compute half splits
ra=1:size(Xd,1);
num=round(size(Xd,1)/2);
ind1=ra(1:num);
ind2=ra(num+1:size(Xd,1));
thetad_half(:,1) = logregression(Xd(ind1,:),yd(ind1),lambda);
thetad_half(:,2) = logregression(Xd(ind2,:),yd(ind2),lambda);

    


disp('frequency')


%%% analyze frequency trials
choice1=choice(task=='f');
gammadir1=gammadir(task=='f',:);
gammafreq1=gammafreq(task=='f',:);
yf=choice1;
Xf=[gammadir1 gammafreq1];

%  Setup the data matrix appropriately
[m, n] = size(Xf);
% Add intercept term
Xf = [ones(m, 1) Xf];

thetaf = logregression(Xf,yf,lambda);



%%% bootstrap to compute error bars 
clear thetafs
for i=1:nreps    
    ind=randsample(1:size(Xf),size(Xf,1),true);    
    thetafs(:,i) = logregression(Xf(ind,:),yf(ind),lambda);    
end
thetaf_se=std(thetafs,[],2);



%%% compute half splits
ra=1:size(Xf,1);
num=round(size(Xf,1)/2);
ind1=ra(1:num);
ind2=ra(num+1:size(Xf,1));
thetaf_half(:,1) = logregression(Xf(ind1,:),yf(ind1),lambda);
thetaf_half(:,2) = logregression(Xf(ind2,:),yf(ind2),lambda);

    


    
save(['data/logistic_regression_results/logreg_best_' ratto '_5.mat'],'thetad','thetad_se','thetad_half',...
    'thetaf','thetaf_se','thetaf_half','vecx');





