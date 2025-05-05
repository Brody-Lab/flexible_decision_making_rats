clear
clc


%%% This script computes the psychometrics data for each rat


%%% create a list of all rat with behavioral data
d=dir('data/Sessions_trials/*sessions.mat');


for qqq=1:length(d)
    

    [qqq length(d)]

    %%% load behavioral data
    load(['data/Sessions_trials/' d(qqq).name]);
    
    %%% rat name
    rats{qqq}=d(qqq).name(1:4);
    
    
    
    % requirements for a session to be included
    
    %min num. of trials in a session
    mintri=100;    
    % minimum performance on congruent trials
    minpe=.65;
    % minimum beta coefficient
    minbe=.65;
    
    
    
    
    %%%%% EXTRACT FROM SESSIONS %%%%%
    
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
    
    
    
    
    
    %performance on location trials
    perfdir={s(:).perfdir};
    %performance on frequency trials
    perffreq={s(:).perffreq};

    %compute matrix of performances across all stimulus strengths
    pedir=nan(6,3,length(perfdir));
    pefreq=nan(6,3,length(perffreq));
    for i=1:length(perfdir)
        if(isempty(perfdir{i}) || isempty(perffreq{i}))
            continue
        end
        pedir(:,:,i)=perfdir{i};
        pefreq(:,:,i)=perffreq{i};
    end
    

    %performances over congruent trials
    pedir=squeeze(pedir([1 2 3],:,:));
    pefreq=squeeze(pefreq([1 2 3],:,:));
    pedir=reshape(pedir,[9,size(pedir,3)]);
    pefreq=reshape(pefreq,[9,size(pefreq,3)]);
    
    pedir=pedir(:,ind_good);
    pefreq=pefreq(:,ind_good);
    
    %overall peformances
    pe=nanmean((pedir+pefreq)/2);
    
    
    
    %choices on location trials across sessions
    choicedir={s(:).choicedir};    
    %choices on frequency trials across sessions
    choicefreq={s(:).choicefreq};

    %number of choices on location trials across sessions
    choicedir_num={s(:).choicedir_num};
    %number of choices on frequency trials across sessions
    choicefreq_num={s(:).choicefreq_num};


    %compute matrix of choices into a single tensor
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

    %matrix of choices for trials in the location context
    cdir=cdir(:,:,ind_good);

    %matrix of choices for trials in the frequency context
    cfreq=cfreq(:,:,ind_good);


    %number of trials for each stimulus strength in the location context
    cdir_num=cdir_num(:,:,ind_good);
    %number of trials for each stimulus strength in the frequency context
    cfreq_num=cfreq_num(:,:,ind_good);
    
    


    % choose good sessions
    len=length(ind_good);
    nsessions=len;
    good=len-nsessions+1:len;
    ind=find(pe>=minpe & be>=minbe);
    good=intersect(good,ind);



    %only use data from good sessions
    be=be(good);
    pe=pe(good);
    cdir=cdir(:,:,good);
    cdir_num=cdir_num(:,:,good);
    cfreq=cfreq(:,:,good);
    cfreq_num=cfreq_num(:,:,good);
    
    
    %%% average matrix of choices for trials in the location context
    cdir=nansum(cdir.*cdir_num,3)./nansum(cdir_num,3);


    %%% average matrix of choices for trials in the frequency context
    cfreq=nansum(cfreq.*cfreq_num,3)./nansum(cfreq_num,3);
    
    
    %%% save matrix of choices for current rat
    cdirs{qqq}=cdir;
    cfreqs{qqq}=cfreq;
    cdir_nums{qqq}=cdir_num;
    cfreq_nums{qqq}=cfreq_num;
    
    
    
    
end


%%% save data
save('data/psychometrics_all_rats.mat','rats',...
    'cdirs','cfreqs','cdir_nums','cfreq_nums');




