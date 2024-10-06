clear
clc
close all


%%% THIS SCRIPT USES RAT DATA
%script that plots psychometrics across all animals


load('data/numsessions_all_rats.mat');

rat_list=rats(find(numhits>=120000));



load('data/psychometrics_all_rats.mat');

rats_psychometrics=rats;





z=1;


h=figure;
set(h,'Position',[616   458   477   560]);

% ha = tight_subplot(1,2,0.01,0.01,0.01);
for i=1:length(rat_list)
    
    
    ratto=rat_list{i};
    
    
    
    
    
    rat_index=find(ismember(rats_psychometrics,ratto));
    
    cdir=cdirs{rat_index};
    cfreq=cfreqs{rat_index};
    cdir_num=cdir_nums{rat_index};
    cfreq_num=cfreq_nums{rat_index};
    
    
    
%     
%     figure
    
    vec=[-4 -2.5 -1 1 2.5 4];
    
    le1=cdir;
    le2=cfreq;
    
    %     axes(ha(1));
    subplot(2,2,1)
    hold on
    
    
    %%% location context, ranked by location strengths
    
    y1=nanmean(le1,1);
%     plot(vec,y1,'k.','MarkerSize',10)
    
    
    ylim([0 1])
    xlim([-4 4])
    hold on
    if(i==1)
    plot([-4 4],[.5 .5],'k:','LineWidth',1)
    end
    set(gca,'XTick',vec)
    
    box off
    set(gca,'TickDir','out')
    set(gca,'FontSize',20);
%     set(gca,'XTick',[],'YTick',[])
    
    
    
    
    ft = fittype( 'bao+t./(1+exp(-(x-alpha)/beta))', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( ft );
    opts.Display = 'Off';
    opts.Lower = [0 0 0 0];
    opts.StartPoint = [0.5 0.5 1 1];
    opts.Upper = [0.1 2 15 15];
    [fitresult, gof] = fit( vec', y1', ft, opts );
    x=-4:.01:4;
    y=fitresult.bao+fitresult.t./(1+exp(-(x-fitresult.alpha)/fitresult.beta));
    hold on
    plot(x,y,'k','LineWidth',1)
    
    
    %%% frequency context, ranked by location strengths
    
    y3=nanmean(le2,1);
%     plot(vec,y3,'.','MarkerSize',10,'Color',[0.6 0.6 0.6])
    ylim([0 1])
    xlim([-4 4])
    hold on
%     plot([-4 4],[.5 .5],'k:','LineWidth',1)
    set(gca,'XTick',vec)
    
%     box off
%     set(gca,'TickDir','out')
%     set(gca,'XTick',[],'YTick',[])
%     

    subplot(2,2,3)
    hold on
    
    ft = fittype( 'bao+t./(1+exp(-(x-alpha)/beta))', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( ft );
    opts.Display = 'Off';
    opts.Lower = [0 0 0 0];
    opts.StartPoint = [0.5 0.5 1 1];
    opts.Upper = [0.1 2 15 15];
    [fitresult, gof] = fit( vec', y3', ft, opts );
    x=-4:.01:4;
    y=fitresult.bao+fitresult.t./(1+exp(-(x-fitresult.alpha)/fitresult.beta));
    hold on
    plot(x,y,'k','LineWidth',1)
    
    
    
    ylim([0 1])
    xlim([-4 4])
    hold on
%     plot([-4 4],[.5 .5],'k:','LineWidth',1)
    set(gca,'XTick',vec)
    
    
    if(i==1)
    plot([-4 4],[.5 .5],'k:','LineWidth',1)
    end
    
    box off
    set(gca,'TickDir','out')
    set(gca,'FontSize',20);
    
    
    
%     
%     
    subplot(2,2,2)
    hold on
    
    
    %%% location context, ranked by frequency strengths
    
    y2=nanmean(le1,2);
%     plot(vec,y2,'.','MarkerSize',10,'Color',[0 1 1])
    ylim([0 1])
    xlim([-4 4])
    hold on
    if(i==1)
    plot([-4 4],[.5 .5],'k:','LineWidth',1)
    end
    set(gca,'XTick',vec)
    
    box off
    set(gca,'TickDir','out')
    set(gca,'FontSize',20);
%     set(gca,'XTick',[],'YTick',[])
    %     xlabel('Frequency gamma')
    %     ylabel('Choices to right (%)')
    
    
    
    ft = fittype( 'bao+t./(1+exp(-(x-alpha)/beta))', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( ft );
    opts.Display = 'Off';
    opts.Lower = [0 0 0 0];
    opts.StartPoint = [0.5 0.5 1 1];
    opts.Upper = [0.1 2 15 15];
    [fitresult, gof] = fit( vec', y2, ft, opts );
    x=-4:.01:4;
    y=fitresult.bao+fitresult.t./(1+exp(-(x-fitresult.alpha)/fitresult.beta));
    hold on
    plot(x,y,'-b','LineWidth',1)
%     plot(x,y,'Color',[0 1 1],'LineWidth',1)
    
    y3a(:,z)=y;
    
    
    
    %%% frequency context, ranked by frequency strengths
    
    y4=nanmean(le2,2);
%     plot(vec,y4,'b.','MarkerSize',10)
    ylim([0 1])
    xlim([-4 4])
    hold on
%     plot([-4 4],[.5 .5],'k:','LineWidth',1)
    set(gca,'XTick',vec)
    
    
    
    subplot(2,2,4)
    hold on
    
    ft = fittype( 'bao+t./(1+exp(-(x-alpha)/beta))', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( ft );
    opts.Display = 'Off';
    opts.Lower = [0 0 0 0];
    opts.StartPoint = [0.5 0.5 1 1];
    opts.Upper = [0.1 2 15 15];
    [fitresult, gof] = fit( vec', y4, ft, opts );
    x=-4:.01:4;
    y=fitresult.bao+fitresult.t./(1+exp(-(x-fitresult.alpha)/fitresult.beta));
    hold on
    plot(x,y,'b','LineWidth',1)
    
    y4a(:,z)=y;

    
    ylim([0 1])
    xlim([-4 4])
    hold on
%     plot([-4 4],[.5 .5],'k:','LineWidth',1)
    set(gca,'XTick',vec)
    
    if(i==1)
    plot([-4 4],[.5 .5],'k:','LineWidth',1)
    end
    
    box off
    set(gca,'TickDir','out')
    set(gca,'FontSize',20);
    
    
    
    
    
    z=z+1;
    
end





% 
% %%% plot average curves
% 
% subplot(1,2,1)
% plot(x,mean(y1a,2),'r','LineWidth',2)
% 
% subplot(1,2,1)
% plot(x,mean(y2a,2),'r','LineWidth',2)
% 
% subplot(1,2,2)
% plot(x,mean(y3a,2),'r','LineWidth',2)
% 
% subplot(1,2,2)
% plot(x,mean(y4a,2),'r','LineWidth',2)
% 




