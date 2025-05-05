clear
clc
close all


%%% Compute mTDR using macaque FEF data from Mante et al., 2013

addpath('mbtdr/functionFiles')
addpath('mbtdr/functionFiles/tools_kron')
addpath('mbtdr/minFunc')
addpath('mbtdr')


%% plotMarinoResults


%%% load macaque dataset
fileDir = 'Arrays_Mante/';
load(['data/' fileDir 'dataT'])




paramFile = 'Pars_mTDR_rank3_AllData';

load(['data/' fileDir paramFile]) %'pars','r0','n','T'


Fd = 20; % Hz %original sampling frequency=1kHz

TrainTrials = [];% use all data

%% make sufficient stats with training data
fprintf('Building Sufficient statistics...\n')
variable_name = { 'stim_dir','targ_dir','stim_col2dir','context'};
varnames = {'motion','choice','color','context','\beta_0'};
cntxt = 0;% both contexts

ssm = 0*Fd;% Smoothing parameter.  ssm = 0: no smoothing
includeTerms{1} = [1,2,3,4];% Array of linear terms to include
includeTermssvd{1} = [1,2,3,4,5];% Array of linear terms to include
P = numel(includeTerms{1});

[Xzetai,Xi,Ai,Ri,ni,zzi,SXnorm,xbari,Ybar,zetai] = ...
    ManteData_AllData(dataT,cntxt,includeTerms,variable_name,ssm,TrainTrials);
[XX, XY,Yn,allstim,n,T] = ...
    MkSuffStats_BilinReg_Data(dataT,includeTermssvd,variable_name,cntxt,ssm,TrainTrials);
g = 0;


%% Estimate parameters
% saveFile = 'marinoPars_mTDR_rank1_AllData';
% saveDir = '/Users/mikio/Dropbox/tdrauxilliary/EstimatedPars';
pars0 = parhist;% Parameters
% rtot = P; %For now

rtot=sum(r0);

b0 = reshape(pars0(n+rtot*T+1:end),T,n);



[~,~,Xzetai] = ECMEsuffstat(zetai,Xi,b0);
% b0 = interp1(tx,b0,tq,'spline');

paramfile = ['data/' fileDir paramFile];
[Bhat, r,What,Shat,lambhat] = MakeBhat_data(paramfile,Ai,Xzetai,r0,[]);



%% Plot some things about estimates
fntsz = 10;lnwdth = 2;mrksz = 10;
ts = dataT.time;
fullvarnames = {'motion','choice','color','context','\beta_0'};

% 
% figure;
for p = 1:P
    [U{p},S{p},V] = svd(Bhat{p});
end

load(['data/' fileDir 'TrlCtlg'])% get descriptive data arrays
load(['data/' fileDir 'PSTHs0'])

% 
[Tmatches, setts] = TrajPlotPars(1,[]);
corrind = 2;% 2 = correct trials, 1 = incorrect trials

%%% take each row of the W matrix: cluster the weights


%% Make projections from PSTHs
Nboot = 1;b = 1;
% Initialize arrays
Yw = cell(P,Nboot);
TrainTrials = [];
traintest = 'train';

% orthogonalize axes
UU = [U{2}(:,1) U{1}(:,1) U{3}(:,1) U{4}(:,1)];
[W,~] = qr(UU);
W = W(:,[2 1 3 4]);

%b0 : matrix N x T : average response of neuron N at time point T

%lambhat: precision

for p = 1:P
    for settings = setts{p}% Iterate over settings
        [chceind, cntxtind,moinds,colinds,cmap,mrkrface,flp] = ...
            PlotPSTHsettings(settings);
        for c = 1:3 % Iterate over stimulus strengths
            
            % Generate appropriate PSTHs
            [newCond,condindNews] = ConditionIndexes(unique_cond,[moinds(c),chceind,cntxtind,corrind,colinds(c)]);
            myPSTHs = nanmean(AllPSTHs(:,:,condindNews),3);
            Yind = (settings-1)*3 +c;
            nanind  = isnan(myPSTHs);
            myPSTHs(nanind) = 0;
            % Make projection
            Yw{p}(Yind,:) = ...
                W(:,p)'*diag(lambhat)*(myPSTHs-b0');
        end
    end
    
end




%% Plot projection in 2D

figure(4)% motion-choice
p = 1;% motion
% p = 2;% choice
for settings = setts{p}; % loop over settings
    [chceind, cntxtind,moinds,colinds,cmap,mrkrface,flp] = ...
        PlotPSTHsettings(settings);
    lc = GetTDRcmap(settings,flp);
    for c = 1:3% loop over stimulus strengths
        Yind = (settings-1)*3 +c;
        tempY1 = squeeze(Yw{1}(Yind,:));
        tempY2 = squeeze(Yw{2}(Yind,:));
        
        plot(smooth(tempY2),smooth(tempY1),'.-','linewidth',lnwdth,'MarkerSize',20,'color',lc(c,:));hold on
    end
end
% plot([0 0],[-1 1]*.4,'k')
% plot([-1 1]*.8,[0 0],'k')
hold off
set(gca,'tickdir','out')
xlabel('Choice')
ylabel('Motion')
title('Motion Context')
box off
set(gcf,'color','w')
set(gca,'FontSize',24)
ylim([-.1 .15])
xlim([-0.21 0.21])


figure(5)% color-choice
p = 3;% color
% p = 2;% choice
for settings = setts{p}; % loop over settings
    [chceind, cntxtind,moinds,colinds,cmap,mrkrface,flp] = ...
        PlotPSTHsettings(settings);
    lc = GetTDRcmap(settings,flp);
    for c = 1:3% loop over stimulus strengths
        Yind = (settings-1)*3 +c;
        tempY1 = squeeze(Yw{3}(Yind,:));
        tempY2 = squeeze(Yw{2}(Yind,:));
        
        plot(smooth(tempY2),-smooth(tempY1),'.-','linewidth',lnwdth,'MarkerSize',20,'color',lc(c,:));hold on
    end
end
% plot([0 0],[-1 1]*.5,'k')
% plot([-1 1]*.8,[0 0],'k')
hold off
set(gca,'tickdir','out')
xlabel('Choice')
ylabel('Color')
title('Color Context')
box off
set(gcf,'color','w')
set(gca,'FontSize',24)
xlim([-0.21 0.21])


























[Tmatches, setts] = TrajPlotPars(3,[]);
corrind = 2;% 2 = correct trials, 1 = incorrect trials



%% Make projections from PSTHs
Nboot = 1;b = 1;
% Initialize arrays
Yw = cell(P,Nboot);
TrainTrials = [];
traintest = 'train';

% orthogonalize axes
UU = [U{2}(:,1) U{1}(:,1) U{3}(:,1) U{4}(:,1)];
[W,~] = qr(UU);
W = W(:,[2 1 3 4]);


for p = 1:P
    for settings = setts{p}% Iterate over settings
        [chceind, cntxtind,moinds,colinds,cmap,mrkrface,flp] = ...
            PlotPSTHsettings(settings);
        for c = 1:3 % Iterate over stimulus strengths
            
            % Generate appropriate PSTHs
            [newCond,condindNews] = ConditionIndexes(unique_cond,[moinds(c),chceind,cntxtind,corrind,colinds(c)]);
            myPSTHs = nanmean(AllPSTHs(:,:,condindNews),3);
            Yind = (settings-1)*3 +c;
            nanind  = isnan(myPSTHs);
            myPSTHs(nanind) = 0;
            % Make projection
            Yw{p}(Yind,:) = ...
                W(:,p)'*diag(lambhat)*(myPSTHs-b0');
        end
    end
    
end




%% Plot projection in 2D

figure(6)% motion-choice
p = 1;% motion
% p = 2;% choice
for settings = setts{p}; % loop over settings
    [chceind, cntxtind,moinds,colinds,cmap,mrkrface,flp] = ...
        PlotPSTHsettings(settings);
    lc = GetTDRcmap(settings,flp);
    for c = 1:3% loop over stimulus strengths
        Yind = (settings-1)*3 +c;
        tempY1 = squeeze(Yw{1}(Yind,:));
        tempY2 = squeeze(Yw{2}(Yind,:));
        
        plot(smooth(tempY2),smooth(tempY1),'.-','linewidth',lnwdth,'MarkerSize',20,'color',lc(c,:));hold on
    end
end
% plot([0 0],[-1 1]*.4,'k')
% plot([-1 1]*.8,[0 0],'k')
hold off
set(gca,'tickdir','out')
xlabel('Choice')
ylabel('Motion')
title('Color Context')
box off
set(gcf,'color','w')
set(gca,'FontSize',24)
xlim([-0.21 0.21])



figure(7)% color-choice
p = 3;% color
% p = 2;% choice
for settings = setts{p}; % loop over settings
    [chceind, cntxtind,moinds,colinds,cmap,mrkrface,flp] = ...
        PlotPSTHsettings(settings);
    lc = GetTDRcmap(settings,flp);
    for c = 1:3% loop over stimulus strengths
        Yind = (settings-1)*3 +c;
        tempY1 = squeeze(Yw{3}(Yind,:));
        tempY2 = squeeze(Yw{2}(Yind,:));
        
        plot(smooth(tempY2),-smooth(tempY1),'.-','linewidth',lnwdth,'MarkerSize',20,'color',lc(c,:));hold on
    end
end
% plot([0 0],[-1 1]*.5,'k')
% plot([-1 1]*.8,[0 0],'k')
hold off
set(gca,'tickdir','out')
xlabel('Choice')
ylabel('Color')
title('Motion Context')
box off
set(gcf,'color','w')
set(gca,'FontSize',24)
xlim([-0.21 0.21])















