function kernels = weights_to_kernels(w)

global glm

curr_index=1;
num=1;
kernels.const=w(curr_index:curr_index+num-1);
curr_index=curr_index+num;


if(isfield(glm,'no_pulse') && glm.no_pulse==1)
    
    num=glm.ntime;
    kernels.dd=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
    
    num=glm.ntime;
    kernels.fd=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
    
    num=glm.ntime;
    kernels.df=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
    
    num=glm.ntime;
    kernels.ff=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
    
    
else
    
    
    num=glm.ntfilt;
    kernels.dd=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
    
    num=glm.ntfilt;
    kernels.fd=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
    
    num=glm.ntfilt;
    kernels.df=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
    
    num=glm.ntfilt;
    kernels.ff=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
    
end

num=glm.ntime;
kernels.time=w(curr_index:curr_index+num-1);
curr_index=curr_index+num;

num=glm.ntime;
kernels.context=w(curr_index:curr_index+num-1);
curr_index=curr_index+num;

if(glm.include_choice)
    num=glm.ntime;
    kernels.choice=w(curr_index:curr_index+num-1);
    curr_index=curr_index+num;
else
    kernels.choice=[];
end

if(glm.include_history)
    
    if(glm.n_neur==1) %one neuron
        num=glm.nthist;
        kernels.history=w(curr_index:curr_index+num-1);
        curr_index=curr_index+num;
    elseif(glm.n_neur>1) %many neurons
        kernels.history=nan(glm.n_neur,glm.nthist);
        for iii=1:glm.n_neur
            num=glm.nthist;
            kernels.history(iii,:)=w(curr_index:curr_index+num-1);
            curr_index=curr_index+num;
        end
    else
        error('?')
    end
    
% %     check 0 remaining
    if(curr_index~=length(w)+1)
        error('?')
    end
else
    kernels.history=[];
    %check 0 remaining
    if(curr_index~=length(w)+1)
        error('?')
    end
end
