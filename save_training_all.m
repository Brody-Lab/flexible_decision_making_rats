clear
clc



d=dir('data/Sessions_trials/*sessions.mat');



nrats=length(d);

maxsess=500;

bdirs=nan(nrats,maxsess);
bfreqs=nan(nrats,maxsess);
bdds=nan(nrats,maxsess);
bfds=nan(nrats,maxsess);
bdfs=nan(nrats,maxsess);
bffs=nan(nrats,maxsess);
hits=nan(nrats,maxsess);
hitds=nan(nrats,maxsess);
hitfs=nan(nrats,maxsess);
hitls=nan(nrats,maxsess);
hitrs=nan(nrats,maxsess);
dir_congrs=nan(nrats,maxsess);
dir_incongrs=nan(nrats,maxsess);
freq_congrs=nan(nrats,maxsess);
freq_incongrs=nan(nrats,maxsess);

for iii=1:nrats
    
    [iii nrats]
    
    
    rats{iii}=d(iii).name(1:4);
    
    
    load(['data/Sessions_trials/' d(iii).name],'sessions');
    
    
    
    
    %min num. of trials in a session
    mintri=100;
    s=sessions;
    %number of valid trials
    valid=[s(:).valid];
    %good session flag
    good=[s(:).good];
    %define ind_good flag
    ind_good=find(good==1 & valid>mintri);
    if(isempty(ind_good))
        continue
    end
    
    
    
    
    
    [bdir,bfreq,bdd,bfd,bdf,bff,hit,hitd,hitf,hitl,hitr,dir_congr,dir_incongr,...
    freq_congr,freq_incongr] = compute_training(sessions);
    
    %smoothing factor
    smo=14;

    
    
    bdir=smooth(bdir,smo)';
    bfreq=smooth(bfreq,smo)';  
    
    bdd=smooth(bdd,smo)';
    bdf=smooth(bdf,smo)';
    bfd=smooth(bfd,smo)';
    bff=smooth(bff,smo)';
    
    hit=smooth(hit,smo)';
    hitd=smooth(hitd,smo)';
    hitf=smooth(hitf,smo)';
    hitl=smooth(hitl,smo)';
    hitr=smooth(hitr,smo)';
    dir_congr=smooth(dir_congr,smo)';
    dir_incongr=smooth(dir_incongr,smo)';
    freq_congr=smooth(freq_congr,smo)';
    freq_incongr=smooth(freq_incongr,smo)';
    

    if(length(bdir)<maxsess)
        diffe=maxsess-length(bdir);
        bdir=[bdir nan(1,diffe)];
        bfreq=[bfreq nan(1,diffe)];
        
        bdd=[bdd nan(1,diffe)];
        bdf=[bdf nan(1,diffe)];
        bfd=[bfd nan(1,diffe)];
        bff=[bff nan(1,diffe)];
        
        hit=[hit nan(1,diffe)];
        hitd=[hitd nan(1,diffe)];
        hitf=[hitf nan(1,diffe)];
        hitl=[hitl nan(1,diffe)];
        hitr=[hitr nan(1,diffe)];
        dir_congr=[dir_congr nan(1,diffe)];
        dir_incongr=[dir_incongr nan(1,diffe)];
        freq_congr=[freq_congr nan(1,diffe)];
        freq_incongr=[freq_incongr nan(1,diffe)];
    end
    
    if(length(bdir)>maxsess)
        bdir=bdir(1:maxsess);
        bfreq=bfreq(1:maxsess);
        
        bdd=bdd(1:maxsess);
        bdf=bdf(1:maxsess);
        bfd=bfd(1:maxsess);
        bff=bff(1:maxsess);
        
        hit=hit(1:maxsess);
        hitd=hitd(1:maxsess);
        hitf=hitf(1:maxsess);
        hitl=hitl(1:maxsess);
        hitr=hitr(1:maxsess);
        dir_congr=dir_congr(1:maxsess);
        dir_incongr=dir_incongr(1:maxsess);
        freq_congr=freq_congr(1:maxsess);
        freq_incongr=freq_incongr(1:maxsess);
    end
        
    bdirs(iii,:)=bdir;
    bfreqs(iii,:)=bfreq;   
    
    bdds(iii,:)=bdd;
    bdfs(iii,:)=bdf;
    bfds(iii,:)=bfd;
    bffs(iii,:)=bff;
    
    hits(iii,:)=hit;
    hitds(iii,:)=hitd;
    hitfs(iii,:)=hitf;
    hitls(iii,:)=hitl;
    hitrs(iii,:)=hitr;
    dir_congrs(iii,:)=dir_congr;
    dir_incongrs(iii,:)=dir_incongr;
    freq_congrs(iii,:)=freq_congr;
    freq_incongrs(iii,:)=freq_incongr;
    
end


save data/training_all bdirs bfreqs bdds bdfs bfds bffs ...
    hits hitds hitfs hitls hitrs ...
    dir_congrs dir_incongrs freq_congrs freq_incongrs rats



