function [bdir,bfreq,bdd,bfd,bdf,bff,hit,hitd,hitf,hitl,hitr,dir_congr,dir_incongr,...
    freq_congr,freq_incongr] = compute_training(sessions)


%min num. of trials in a session
mintri=100;


%%%%% EXTRACT FROM SESSIONS %%%%%

% s=sessions{ratnum};
s=sessions;

%number of valid trials
valid=[s(:).valid];

%good session flag
good=[s(:).good];

%define ind_good flag
ind_good=find(good==1 & valid>mintri);
s=s(ind_good);
% valid=valid(ind_good);

%beta direction
bdir=[s(:).bdir];
% bdir=bdir(ind_good);

%beta frequency
bfreq=[s(:).bfreq];
% bfreq=bfreq(ind_good);


%beta direction
betadir=[s(:).betadir];
bfd=betadir(1,:);
bdd=betadir(2,:);
% bdir=bdir(ind_good);

%beta frequency
betafreq=[s(:).betafreq];
bff=betafreq(1,:);
bdf=betafreq(2,:);
% bfreq=bfreq(ind_good);

%hit
hit=[s(:).hit];
% hit=hit(ind_good);

%hitd
hitd=[s(:).hitd];
% hitd=hitd(ind_good);

%hitf
hitf=[s(:).hitf];
% hitf=hitf(ind_good);

%hitl
hitl=[s(:).hitl];
% hitl=hitl(ind_good);

%hitr
hitr=[s(:).hitr];
% hitr=hitr(ind_good);

%dir_congr
dir_congr=[s(:).dir_congr];
% dir_congr=dir_congr(ind_good);

%dir_incongr
dir_incongr=[s(:).dir_incongr];
% dir_incongr=dir_incongr(ind_good);

%freq_congr
freq_congr=[s(:).freq_congr];
% freq_congr=freq_congr(ind_good);

%freq_incongr
freq_incongr=[s(:).freq_incongr];
% freq_incongr=freq_incongr(ind_good);




