function glm_fit = run_glm_neuron(behav,ephys)



global glm


if(size(ephys.neural_data,3)==0)
    error('no neurons')
end

if(size(ephys.neural_data,3)>1)
    error('more than one neuron')
end


glm.n_neur=1;

disp('running for a single neuron');

prep_glm;


x = build_matrix_regressors(behav,ephys);
glm_fit.x = x;

x2=reshape(x,glm.ntime,behav.nTrials,size(x,2));


neural_data=ephys.neural_data;
neural_data_convolved=ephys.neural_data_convolved;

y=neural_data(:);

w = get_weights(x,y);
glm_fit.w = w;

glm_fit.kernels = weights_to_kernels(w);


%%% compare estimated responses w/ convolved true
%%% responses (because of smoothing regularization)
y2=x*w;
y3=reshape(y2,glm.ntime,behav.nTrials);



if(glm.bootstrap) 
%%% bootstrap error bars

    bootstrap.const=nan(glm.reps_bootstrap,1);



    if(isfield(glm,'no_pulse') && glm.no_pulse==1)

        bootstrap.dd=nan(glm.reps_bootstrap,glm.ntime);
        bootstrap.df=nan(glm.reps_bootstrap,glm.ntime);
        bootstrap.fd=nan(glm.reps_bootstrap,glm.ntime);
        bootstrap.ff=nan(glm.reps_bootstrap,glm.ntime);

    else
        bootstrap.dd=nan(glm.reps_bootstrap,glm.ntfilt);
        bootstrap.df=nan(glm.reps_bootstrap,glm.ntfilt);
        bootstrap.fd=nan(glm.reps_bootstrap,glm.ntfilt);
        bootstrap.ff=nan(glm.reps_bootstrap,glm.ntfilt);

    end

    bootstrap.time=nan(glm.reps_bootstrap,glm.ntime);
    bootstrap.context=nan(glm.reps_bootstrap,glm.ntime);
    if(glm.include_choice)
        bootstrap.choice=nan(glm.reps_bootstrap,glm.ntime);
    end
    if(glm.include_history)
        bootstrap.history=nan(glm.reps_bootstrap,glm.nthist);
    end


    %%% bootstrapping error bars
    for jjj=1:glm.reps_bootstrap

        %sample nTrials with replacement
        indtrain=randi(behav.nTrials,1,behav.nTrials);

        x2train=x2(:,indtrain,:);
        xtrain=reshape(x2train,[behav.nTrials*glm.ntime,size(x,2)]);
        rrr4train=ephys.neural_data(:,indtrain);
        ytrain=rrr4train(:);

        w = get_weights(xtrain,ytrain);
        kernels = weights_to_kernels(w);

        bootstrap.const(jjj)=kernels.const;
        bootstrap.dd(jjj,:)=kernels.dd;
        bootstrap.df(jjj,:)=kernels.df;
        bootstrap.fd(jjj,:)=kernels.fd;
        bootstrap.ff(jjj,:)=kernels.ff;
        bootstrap.time(jjj,:)=kernels.time;
        bootstrap.context(jjj,:)=kernels.context;
        if(glm.include_choice)
            bootstrap.choice(jjj,:)=kernels.choice;
        end
        if(glm.include_history)
            bootstrap.history(jjj,:)=kernels.history;
        end

    end

    glm_fit.bootstrap=bootstrap;

    glm_fit.bootstrap.const_se=std(bootstrap.const);
    glm_fit.bootstrap.dd_se=std(bootstrap.dd);
    glm_fit.bootstrap.df_se=std(bootstrap.df);
    glm_fit.bootstrap.fd_se=std(bootstrap.fd);
    glm_fit.bootstrap.ff_se=std(bootstrap.ff);
    glm_fit.bootstrap.time_se=std(bootstrap.time);
    glm_fit.bootstrap.context_se=std(bootstrap.context);
    if(glm.include_choice)
        glm_fit.bootstrap.choice_se=std(bootstrap.choice);
    end
    if(glm.include_history)
        glm_fit.bootstrap.history_se=std(bootstrap.history);
    end


end



if(glm.keep_regression_values==0)
    glm_fit = rmfield(glm_fit,'x');
    glm_fit = rmfield(glm_fit,'w');
end



%%% split the trials in half and compute correlation of reconstructed
%%% PSTHs across the two halves


%%% we divide indices of all trials into ind1 and ind2
ind1=[];
ind2=[];


vec_tot='lr';
for j=1:length(vec_tot)
    india=find(behav.side==vec_tot(j) & behav.task=='d');
    nu=length(india);
    ra=randperm(nu);
    nu2=round(nu/2);
    ind1=[ind1 india(ra(1:nu2))];
    ind2=[ind2 india(ra(nu2+1:nu))];
end

for j=1:length(vec_tot)
    india=find(behav.side==vec_tot(j) & behav.task=='f');
    nu=length(india);
    ra=randperm(nu);
    nu2=round(nu/2);
    ind1=[ind1 india(ra(1:nu2))];
    ind2=[ind2 india(ra(nu2+1:nu))];
end



x2_half1=x2(:,ind1,:);
x_half1=reshape(x2_half1,[length(ind1)*glm.ntime,size(x,2)]);
rrr4_half1=ephys.neural_data(:,ind1);
y_half1=rrr4_half1(:);
w_half1 = get_weights(x_half1,y_half1);

x2_half2=x2(:,ind2,:);
x_half2=reshape(x2_half2,[length(ind2)*glm.ntime,size(x,2)]);
rrr4_half2=ephys.neural_data(:,ind2);
y_half2=rrr4_half2(:);
w_half2 = get_weights(x_half2,y_half2);



yest_half1=x_half1*w_half2;
yest_half2=x_half2*w_half1;

yconv_half1=ephys.neural_data_convolved(:,ind1);
yconv_half2=ephys.neural_data_convolved(:,ind2);



yest_half1_reformatted=reshape(yest_half1,glm.ntime,length(ind1));
yconv_half1_reformatted=reshape(yconv_half1,glm.ntime,length(ind1));

yest_half2_reformatted=reshape(yest_half2,glm.ntime,length(ind2));
yconv_half2_reformatted=reshape(yconv_half2,glm.ntime,length(ind2));


ydm1 = get_psth_curves(yconv_half1_reformatted',glm.centers2,behav.hits(ind1),behav.gdir(ind1),behav.gfreq(ind1),behav.task(ind1),behav.tim(:,ind1),4,[-1 2]);
ydm2 = get_psth_curves(yest_half1_reformatted',glm.centers2,behav.hits(ind1),behav.gdir(ind1),behav.gfreq(ind1),behav.task(ind1),behav.tim(:,ind1),4,[-1 2]);
psth_err=ydm1-ydm2;
var_psth1=1-var(psth_err(:))/var(ydm1(:));

ydm1 = get_psth_curves(yconv_half2_reformatted',glm.centers2,behav.hits(ind2),behav.gdir(ind2),behav.gfreq(ind2),behav.task(ind2),behav.tim(:,ind2),4,[-1 2]);
ydm2 = get_psth_curves(yest_half2_reformatted',glm.centers2,behav.hits(ind2),behav.gdir(ind2),behav.gfreq(ind2),behav.task(ind2),behav.tim(:,ind2),4,[-1 2]);
psth_err=ydm1-ydm2;
var_psth2=1-var(psth_err(:))/var(ydm1(:));


glm_fit.corr_psth=(var_psth1+var_psth2)/2;



