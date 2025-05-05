function [] = prep_glm()


global glm

%used to compute histograms (bin edges)
glm.centers=(glm.xmi-glm.res/2):glm.res:(glm.xma+glm.res/2);
%used to plot (bin centers)
glm.centers2=glm.xmi:glm.res:glm.xma;

%number of time points
glm.ntime=length(glm.centers2);

%points in the pulse filter (1 s long)
glm.ntfilt=glm.pulsedur/glm.res;
%time vector for pulse filter
glm.ttk=linspace(0,glm.pulsedur,glm.ntfilt);


