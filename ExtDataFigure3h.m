clear
clc
close all

%%% uncomment rat name to produce the corresponding plot

% ratto='P049';
ratto='P055';
% ratto='P059';
% ratto='P095';
% ratto='P100';
% ratto='P101';
% ratto='P102';







directory_sessions='data/Sessions_trials/';


load([directory_sessions ratto '_sessions.mat']);



minperf=.65;
minbeta=.65;
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

gammadir=log(vecr./vecl);
gammafreq=log(vechi./veclo);




disp('location')



%%% analyze location trials
choice1=choice(task=='d');
gammadir1=gammadir(task=='d',:);
gammafreq1=gammafreq(task=='d',:);


%%% actual choices
yd=choice1;
yd_orig=yd;


Xd=[gammadir1 gammafreq1];

%  Setup the data matrix appropriately
[m, n] = size(Xd);
% Add intercept term
Xd = [ones(m, 1) Xd];

lambda=1;
thetad = logregression(Xd,yd,lambda);
       
%%% prediction based on the temporal kernels
y2=sigmoid(Xd*thetad);




y2=y2*2-1;
yd=yd*2-1;

f=figure;
set(f,'Position',[616   458   475   560])

subplot(2,2,1)
gdir1=gdir(task=='d');
vals=[-4 -2.5 -1 1 2.5 4];
for iii=1:6
    ind=find(gdir1==vals(iii));
    cho1(iii)=mean(yd(ind));
    cho2(iii)=mean(y2(ind));
end
hold on
plot(vals,cho1,'b')
plot(vals,cho2,'r')
xlim([-4 4])
plot(xlim,[0 0],'k--')
ylim([-1 1])
title('LOC context')
xlabel('LOC evidence')
ylabel('% go Right')
set(gca,'FontSize',15)

set(gca,'TickDir','out')
box off




subplot(2,2,2)
gfreq1=gfreq(task=='d');
vals=[-4 -2.5 -1 1 2.5 4];
for iii=1:6
    ind=find(gfreq1==vals(iii));
    cho1(iii)=mean(yd(ind));
    cho2(iii)=mean(y2(ind));
end
hold on
plot(vals,cho1,'b')
plot(vals,cho2,'r')
xlim([-4 4])
plot(xlim,[0 0],'k--')
ylim([-1 1])
title('LOC context')
xlabel('FRQ evidence')
ylabel('% go Right')
set(gca,'FontSize',15)

set(gca,'TickDir','out')
box off





disp('frequency')



%%% analyze location trials
choice1=choice(task=='f');
gammadir1=gammadir(task=='f',:);
gammafreq1=gammafreq(task=='f',:);
yd=choice1;
Xd=[gammadir1 gammafreq1];

%  Setup the data matrix appropriately
[m, n] = size(Xd);
% Add intercept term
Xd = [ones(m, 1) Xd];

lambda=1;
thetad = logregression(Xd,yd,lambda);
       

y2=sigmoid(Xd*thetad);


y2=y2*2-1;
yd=yd*2-1;





subplot(2,2,3)
gdir1=gdir(task=='f');
vals=[-4 -2.5 -1 1 2.5 4];
for iii=1:6
    ind=find(gdir1==vals(iii));
    cho1(iii)=mean(yd(ind));
    cho2(iii)=mean(y2(ind));
end
hold on
plot(vals,cho1,'b')
plot(vals,cho2,'r')
xlim([-4 4])
plot(xlim,[0 0],'k--')
ylim([-1 1])
title('FRQ context')
xlabel('LOC evidence')
ylabel('% go Right')
set(gca,'FontSize',15)

set(gca,'TickDir','out')
box off




subplot(2,2,4)
gfreq1=gfreq(task=='f');
vals=[-4 -2.5 -1 1 2.5 4];
for iii=1:6
    ind=find(gfreq1==vals(iii));
    cho1(iii)=mean(yd(ind));
    cho2(iii)=mean(y2(ind));
end
hold on
plot(vals,cho1,'b')
plot(vals,cho2,'r')
xlim([-4 4])
plot(xlim,[0 0],'k--')
ylim([-1 1])
title('FRQ context')
xlabel('FRQ evidence')
ylabel('% go Right')
set(gca,'FontSize',15)

set(gca,'TickDir','out')
box off

