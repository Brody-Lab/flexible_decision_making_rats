function [logreg_results] = compute_logreg_rat(rat,parameters)


load(['data/Sessions_trials/' rat '_sessions.mat']);

ind=find([sessions.hit]>=parameters.min_perf & (([sessions.bdir]+[sessions.bfreq])/2)>=parameters.min_beta & ...
    [sessions.valid]>=parameters.min_trials & [sessions.good]==1);


sessions=sessions(ind);
trials=trials(ind);




[hits,task,choice,gfreq,gdir,side,nta,vecr,vecl,vechi,veclo] = ...
    get_trials_stim(sessions,trials,parameters.min_perf,parameters.min_trials,parameters.min_beta);

numtrials=length(hits);
disp(['Number of trials = ' num2str(numtrials)])


vec=0:.01:1.3;





vec(end)=vec(end)+eps;

di=diff(vec);
di=di(1);
vecx=vec+di/2;
vecx=vecx(1:end-1);

%50 ms steps
downsamp=5;

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

logreg_results.vecx=vecx';



vecr=vecr+eps;
vecl=vecl+eps;
vechi=vechi+eps;
veclo=veclo+eps;

%%% strength of location evidence per bin
gammadir=log(vecr./vecl);
%%% strength of frequency evidence per bin
gammafreq=log(vechi./veclo);






disp('Analysing location context...')



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

thetad = logregression(Xd,yd,parameters.lambda);


%%% weight of location evidence in the location context
logreg_results.thetadd=thetad(2:27);
%%% weight of frequency evidence in the location context
logreg_results.thetafd=thetad(28:end);




if(parameters.compute_bootstrap)

    clear thetads

    %%% bootstrap to compute error bars
    for i=1:parameters.bootstrap_reps
        ind=randsample(1:size(Xd,1),size(Xd,1),true);
        thetads(:,i) = logregression(Xd(ind,:),yd(ind),parameters.lambda);
    end


    logreg_results.thetadds=thetads(2:27,:);
    logreg_results.thetafds=thetads(28:end,:);


    %%% location evidence in the location context
    logreg_results.thetadd_se=std(logreg_results.thetadds,[],2);
    %%% frequency evidence in the location context
    logreg_results.thetafd_se=std(logreg_results.thetafds,[],2);


end


if(parameters.compute_halfsplit)

    %%% compute half splits
    ra=1:size(Xd,1);
    num=round(size(Xd,1)/2);
    ind1=ra(1:num);
    ind2=ra(num+1:size(Xd,1));
    thetad_half(:,1) = logregression(Xd(ind1,:),yd(ind1),parameters.lambda);
    thetad_half(:,2) = logregression(Xd(ind2,:),yd(ind2),parameters.lambda);


    %%% location evidence in the location context
    logreg_results.thetadd_half=thetad_half(2:27,:);
    %%% frequency evidence in the location context
    logreg_results.thetafd_half=thetad_half(28:end,:);

end







disp('Analysing frequency context...')


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

thetaf = logregression(Xf,yf,parameters.lambda);

%%% weight of location evidence in the frequency context
logreg_results.thetadf=thetaf(2:27);
%%% weight of frequency evidence in the frequency context
logreg_results.thetaff=thetaf(28:end);


if(parameters.compute_bootstrap)

    %%% bootstrap to compute error bars
    clear thetafs
    for i=1:parameters.bootstrap_reps
        ind=randsample(1:size(Xf),size(Xf,1),true);
        thetafs(:,i) = logregression(Xf(ind,:),yf(ind),parameters.lambda);
    end

    logreg_results.thetadfs=thetafs(2:27,:);
    logreg_results.thetaffs=thetafs(28:end,:);

    %%% location evidence in the frequency context
    logreg_results.thetadf_se=std(logreg_results.thetadfs,[],2);
    %%% frequency evidence in the frequency context
    logreg_results.thetaff_se=std(logreg_results.thetaffs,[],2);


end


if(parameters.compute_halfsplit)

    %%% compute half splits
    ra=1:size(Xf,1);
    num=round(size(Xf,1)/2);
    ind1=ra(1:num);
    ind2=ra(num+1:size(Xf,1));
    thetaf_half(:,1) = logregression(Xf(ind1,:),yf(ind1),parameters.lambda);
    thetaf_half(:,2) = logregression(Xf(ind2,:),yf(ind2),parameters.lambda);


    %%% location evidence in the frequency context
    logreg_results.thetadf_half=thetaf_half(2:27,:);
    %%% frequency evidence in the frequency context
    logreg_results.thetaff_half=thetaf_half(28:end,:);

end



