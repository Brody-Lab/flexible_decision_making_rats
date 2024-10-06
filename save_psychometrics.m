clear
clc


d=dir('data/Sessions_trials/*sessions.mat');


for qqq=1:length(d)
    
    [qqq length(d)]

    
    load(['data/Sessions_trials/' d(qqq).name]);
    
    rats{qqq}=d(qqq).name(1:4);
    
    
    
    
    
    
    
    
    %min num. of trials in a session
    mintri=100;
    %
    
    %smoothing
    smo=7;
    
    % requirements for a session to be included in the analyses
    % minimum performance on congruent trials
    minpe=.65;
    % minimum beta
    minbe=.65;
    
    
    
    
    %%%%% EXTRACT FROM SESSIONS %%%%%
    
    % s=sessions{ratnum};
    s=sessions;
    
    %number of valid trials
    valid=[s(:).valid];
    
    %good session flag
    good=[s(:).good];
    
    %define ind_good flag
    ind_good=find(good==1 & valid>mintri);
    
    valid=valid(ind_good);
    
    %beta direction
    bdir=[s(:).bdir];
    bdir=bdir(ind_good);
    
    %beta frequency
    bfreq=[s(:).bfreq];
    bfreq=bfreq(ind_good);
    
    %beta
    be=(bdir+bfreq)/2;
    
    
    
    
    
    %perf direction and frequency
    perfdir={s(:).perfdir};
    perffreq={s(:).perffreq};
    pedir=nan(6,3,length(perfdir));
    pefreq=nan(6,3,length(perffreq));
    for i=1:length(perfdir)
        if(isempty(perfdir{i}) || isempty(perffreq{i}))
            continue
        end
        pedir(:,:,i)=perfdir{i};
        pefreq(:,:,i)=perffreq{i};
    end
    
    %performances over all congruent trials
    pedir=squeeze(pedir([1 2 3],:,:));
    pefreq=squeeze(pefreq([1 2 3],:,:));
    pedir=reshape(pedir,[9,size(pedir,3)]);
    pefreq=reshape(pefreq,[9,size(pefreq,3)]);
    
    pedir=pedir(:,ind_good);
    pefreq=pefreq(:,ind_good);
    
    %perf
    pe=nanmean((pedir+pefreq)/2);
    
    
    
    
    %choice direction and frequency
    choicedir={s(:).choicedir};
    choicefreq={s(:).choicefreq};
    choicedir_num={s(:).choicedir_num};
    choicefreq_num={s(:).choicefreq_num};
    cdir=nan(6,6,length(choicedir));
    cfreq=nan(6,6,length(choicefreq));
    cdir_num=nan(6,6,length(choicedir_num));
    cfreq_num=nan(6,6,length(choicefreq_num));
    for i=1:length(choicedir)
        if(isempty(choicedir{i}) || isempty(choicefreq{i}))
            continue
        end
        cdir(:,:,i)=choicedir{i};
        cfreq(:,:,i)=choicefreq{i};
        cdir_num(:,:,i)=choicedir_num{i};
        cfreq_num(:,:,i)=choicefreq_num{i};
    end
    cdir=cdir(:,:,ind_good);
    cfreq=cfreq(:,:,ind_good);
    cdir_num=cdir_num(:,:,ind_good);
    cfreq_num=cfreq_num(:,:,ind_good);
    
    
    
    %training stage
    o=[s(:).sta2];
    stag=o(ind_good);
    
    
    %colors for the stages
    colo={[.95 1 1],[.75 .9 1],[1 .95 1],[1 1 .6]};
    
    
    
    if(isempty(stag))
        continue
    end
    
    
    
    
    
    
    
    len=length(ind_good);
    % nsessions=min([len nsessions]);
    nsessions=len;
    good=len-nsessions+1:len;
    ind=find(pe>=minpe & be>=minbe);
    good=intersect(good,ind);
    % disp(['n of good sessions: ' num2str(length(good))])
    
    
    
    
    
    be=be(good);
    pe=pe(good);
    stag=stag(good);
    cdir=cdir(:,:,good);
    cdir_num=cdir_num(:,:,good);
    cfreq=cfreq(:,:,good);
    cfreq_num=cfreq_num(:,:,good);
    
    
    
    cdir=nansum(cdir.*cdir_num,3)./nansum(cdir_num,3);
    cfreq=nansum(cfreq.*cfreq_num,3)./nansum(cfreq_num,3);
    
    
    
    cdirs{qqq}=cdir;
    cfreqs{qqq}=cfreq;
    cdir_nums{qqq}=cdir_num;
    cfreq_nums{qqq}=cfreq_num;
    
    
    
    
    
    
    
    
end


save('data/psychometrics_all_rats.mat','rats',...
    'cdirs','cfreqs','cdir_nums','cfreq_nums');




