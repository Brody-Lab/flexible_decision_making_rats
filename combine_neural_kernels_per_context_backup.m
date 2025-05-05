clear
% clc


res=2;
dur=66;



all_trials_loc.glm_dd=nan(dur/res,3495);
all_trials_loc.glm_df=nan(dur/res,3495);
all_trials_loc.glm_fd=nan(dur/res,3495);
all_trials_loc.glm_ff=nan(dur/res,3495);
all_trials_loc.glm_time=nan(length(-1:res/100:2),3495);
all_trials_loc.glm_context=nan(length(-1:res/100:2),3495);
all_trials_loc.glm_choice=nan(length(-1:res/100:2),3495);


all_trials_freq.glm_dd=nan(dur/res,3495);
all_trials_freq.glm_df=nan(dur/res,3495);
all_trials_freq.glm_fd=nan(dur/res,3495);
all_trials_freq.glm_ff=nan(dur/res,3495);
all_trials_freq.glm_time=nan(length(-1:res/100:2),3495);
all_trials_freq.glm_context=nan(length(-1:res/100:2),3495);
all_trials_freq.glm_choice=nan(length(-1:res/100:2),3495);




for z=1:3495
    

    load(['data/computed_filters_per_context/filter_' num2str(z) '.mat'])



    if(~isempty(glm_fit_loc))
        all_trials_loc.glm_dd(:,z)=glm_fit_loc.kernels.dd;
        all_trials_loc.glm_fd(:,z)=glm_fit_loc.kernels.fd;
        all_trials_loc.glm_df(:,z)=glm_fit_loc.kernels.df;
        all_trials_loc.glm_ff(:,z)=glm_fit_loc.kernels.ff;
        all_trials_loc.glm_time(:,z)=glm_fit_loc.kernels.time;
        all_trials_loc.glm_context(:,z)=glm_fit_loc.kernels.context;
        all_trials_loc.glm_choice(:,z)=glm_fit_loc.kernels.choice;
    end



    if(~isempty(glm_fit_freq))
        all_trials_freq.glm_dd(:,z)=glm_fit_freq.kernels.dd;
        all_trials_freq.glm_fd(:,z)=glm_fit_freq.kernels.fd;
        all_trials_freq.glm_df(:,z)=glm_fit_freq.kernels.df;
        all_trials_freq.glm_ff(:,z)=glm_fit_freq.kernels.ff;
        all_trials_freq.glm_time(:,z)=glm_fit_freq.kernels.time;
        all_trials_freq.glm_context(:,z)=glm_fit_freq.kernels.context;
        all_trials_freq.glm_choice(:,z)=glm_fit_freq.kernels.choice;
    end
    



end



data_all_trials_loc.glm_dd=all_trials_loc.glm_dd(:,:,iii);
data_all_trials_loc.glm_fd=all_trials_loc.glm_fd(:,:,iii);
data_all_trials_loc.glm_df=all_trials_loc.glm_df(:,:,iii);
data_all_trials_loc.glm_ff=all_trials_loc.glm_ff(:,:,iii);
data_all_trials_loc.glm_time=all_trials_loc.glm_time(:,:,iii);
data_all_trials_loc.glm_context=all_trials_loc.glm_context(:,:,iii);
data_all_trials_loc.glm_choice=all_trials_loc.glm_choice(:,:,iii);


data_all_trials_freq.glm_dd=all_trials_freq.glm_dd(:,:,iii);
data_all_trials_freq.glm_fd=all_trials_freq.glm_fd(:,:,iii);
data_all_trials_freq.glm_df=all_trials_freq.glm_df(:,:,iii);
data_all_trials_freq.glm_ff=all_trials_freq.glm_ff(:,:,iii);
data_all_trials_freq.glm_time=all_trials_freq.glm_time(:,:,iii);
data_all_trials_freq.glm_context=all_trials_freq.glm_context(:,:,iii);
data_all_trials_freq.glm_choice=all_trials_freq.glm_choice(:,:,iii);





% data_bootstrap.glm_dd=bootstrap.glm_dd_se(:,:,iii);
% data_bootstrap.glm_fd=bootstrap.glm_fd_se(:,:,iii);
% data_bootstrap.glm_df=bootstrap.glm_df_se(:,:,iii);
% data_bootstrap.glm_ff=bootstrap.glm_ff_se(:,:,iii);
% data_bootstrap.glm_time=bootstrap.glm_time_se(:,:,iii);
% data_bootstrap.glm_context=bootstrap.glm_context_se(:,:,iii);
% data_bootstrap.glm_choice=bootstrap.glm_choice_se(:,:,iii);



vecx=0.01:0.02:0.66;

save('data/combined_kernels_per_context.mat','vecx',...
    'data_all_trials_loc','data_all_trials_freq','glm');

    

    


