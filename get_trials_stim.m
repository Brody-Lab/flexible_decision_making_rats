function [hits,task,choice,gfreq,gdir,side,nta,vecr,vecl,vechi,veclo] = ...
    get_trials_stim(sessions,trials,minperf,mintri,minbe)


ind=find([sessions.hit]>=minperf & ...
    [sessions.valid]>=mintri & [sessions.good]==1 & ...
    ([sessions.bdir]+[sessions.bfreq])/2>=minbe);

tr=trials(ind);

hits={tr.hits_all};
hits=[hits{:}]';

task={tr.task_all};
task=[task{:}]';

choice={tr.choice_all};
choice=[choice{:}]';

gfreq={tr.gfreq_all};
gfreq=[gfreq{:}]';

gdir={tr.gdir_all};
gdir=[gdir{:}]';

side={tr.side_all};
side=[side{:}]';

nta={tr.nta_all};
nta=[nta{:}]';


ce={tr.vecr_all};
le=cellfun(@(x) size(x,1),ce);
vecr=nan(sum(le),130);
z=1;
for i=1:length(le)
    l=le(i);
    vecr(z:z+l-1,:)=ce{i};
    z=z+l;
end


ce={tr.vecl_all};
le=cellfun(@(x) size(x,1),ce);
vecl=nan(sum(le),130);
z=1;
for i=1:length(le)
    l=le(i);
    vecl(z:z+l-1,:)=ce{i};
    z=z+l;
end


ce={tr.vechi_all};
le=cellfun(@(x) size(x,1),ce);
vechi=nan(sum(le),130);
z=1;
for i=1:length(le)
    l=le(i);
    vechi(z:z+l-1,:)=ce{i};
    z=z+l;
end


ce={tr.veclo_all};
le=cellfun(@(x) size(x,1),ce);
veclo=nan(sum(le),130);
z=1;
for i=1:length(le)
    l=le(i);
    veclo(z:z+l-1,:)=ce{i};
    z=z+l;
end


end
