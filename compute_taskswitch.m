function [az1d2f,az2d2f,az1f2d,az2f2d] = compute_taskswitch(sessions,trials)

minperf=.65;
mintri=100;
minbe=0.65;

[hits,task,choice,gfreq,gdir,side,nta] = get_trials_stim(sessions,trials,minperf,mintri,minbe);



prevstart=5;
prevend=30;
lenprev=prevend-prevstart+1;
newend=30;
bz1=nan(1,lenprev+newend);
bz2=nan(1,lenprev+newend);
for i=1:lenprev
    
    ind = find(task=='d' & nta==prevstart+i-1);
    if(~isempty(ind))
        Y=choice(ind);
        X=[gdir(ind) gfreq(ind)];
        
        B = glmfit(X, Y, 'binomial', 'link', 'logit');
        
        bz1(i)=B(2);
        bz2(i)=B(3);
    end
    
end

for i=1:newend
    
    ind = find(task=='f' & nta==i);
    if(~isempty(ind))
        Y=choice(ind);
        X=[gdir(ind) gfreq(ind)];
        
        B = glmfit(X, Y, 'binomial', 'link', 'logit');
        
        bz1(i+lenprev)=B(2);
        bz2(i+lenprev)=B(3);
    end
end



az1d2f=bz1./(bz1+bz2);    
az2d2f=bz2./(bz1+bz2);






bz1=nan(1,lenprev+newend);
bz2=nan(1,lenprev+newend);
for i=1:lenprev
    
    ind = find(task=='f' & nta==prevstart+i-1);
    if(~isempty(ind))
        Y=choice(ind);
        X=[gdir(ind) gfreq(ind)];
        
        B = glmfit(X, Y, 'binomial', 'link', 'logit');
        
        bz1(i)=B(2);
        bz2(i)=B(3);
    end
    
end

for i=1:newend
    
    ind = find(task=='d' & nta==i);
    if(~isempty(ind))
        Y=choice(ind);
        X=[gdir(ind) gfreq(ind)];
        
        B = glmfit(X, Y, 'binomial', 'link', 'logit');
        
        bz1(i+lenprev)=B(2);
        bz2(i+lenprev)=B(3);
    end
end



az1f2d=bz1./(bz1+bz2);    
az2f2d=bz2./(bz1+bz2);




end







