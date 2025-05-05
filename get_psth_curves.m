function ydm = get_psth_curves(rrr,centers,hits,gdir,gfreq,task,tim,alignto,limi)



ind=find(centers>=limi(1)-0.0001 & centers<=limi(2)+0.0001);
rrr=rrr(:,ind);


%%%% direction task errorbars
vec_tot=[-1 1];
for j=1:length(vec_tot)
    indz=find(sign(gdir)==vec_tot(j) & task=='d' & hits==1);
    ydm(:,j)=squeeze(mean(rrr(indz,:),1)); 

end


%%%% frequency task errorbars
for j=1:length(vec_tot)
    indz=find(sign(gfreq)==vec_tot(j) & task=='f' & hits==1);
    ydm(:,2+j)=squeeze(mean(rrr(indz,:),1));

end

