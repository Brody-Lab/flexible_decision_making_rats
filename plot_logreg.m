function [] = plot_logreg(logreg_results,type)

%%% this function plots the results of the logistic regression of behavior

ylimi=[-.2 1.45];

slope_results=compute_slope(logreg_results);


dif_d=(logreg_results.thetadd-logreg_results.thetadf)/2;

dif_f=(logreg_results.thetaff-logreg_results.thetafd)/2;

dif_d_se=(logreg_results.thetadd_se+logreg_results.thetadf_se)/2;

dif_f_se=(logreg_results.thetaff_se+logreg_results.thetafd_se)/2;



vecx=logreg_results.vecx;


if(strcmp(type,'location'))
    maxval=max(abs(dif_d(14:26)));
    dif_d_normalized=dif_d/maxval;
    dif_d_se_normalized=dif_d_se/maxval;
    hold on


    vec1=dif_d_normalized'-dif_d_se_normalized';
    vec2=dif_d_normalized'+dif_d_se_normalized';
    fill([vecx' vecx(end:-1:1)' vecx(1)'],[vec1 vec2(end:-1:1) vec1(1)],...
        [130 130 130]/255,'FaceAlpha',0.2,'EdgeColor','none');


    plot(vecx,dif_d_normalized,'-','MarkerSize',10,'LineWidth',1,'Color',[130 130 130]/255)

    indices_markers=2:3:26;
    plot(vecx(indices_markers),dif_d_normalized(indices_markers),'.','MarkerSize',30,'LineWidth',1,'Color',[130 130 130]/255)

    plot(vecx,slope_results.pd(1)*vecx+slope_results.pd(2),'-','LineWidth',3,'Color',[130 130 130]/255)

    xlim([vecx(1) vecx(end)])


    set(gca,'XTick',vecx([1 length(vecx)]));
    set(gca,'XTickLabel',[0 1.3]);
    set(gca,'FontSize',15);
    box off
    set(gca,'TickDir','out')


    xlim([0.6750 1.2750])


    aaa=dif_d_normalized(14:26);

    plot(xlim,[0 0],'-','Color',[0 0 0]/255,'LineWidth',2)

    limite=max(aaa)*1.1;

    
    ylim(ylimi)









elseif(strcmp(type,'frequency'))


    maxval=max(abs(dif_f(14:26)));
    dif_f_normalized=dif_f/maxval;

    dif_f_se_normalized=dif_f_se/maxval;


    indices_markers=2:3:26;

    hold on

    vec1=dif_f_normalized'-dif_f_se_normalized';
    vec2=dif_f_normalized'+dif_f_se_normalized';
    fill([vecx' vecx(end:-1:1)' vecx(1)'],[vec1 vec2(end:-1:1) vec1(1)],...
        [130 130 130]/255,'FaceAlpha',0.2,'EdgeColor','none');


    plot(vecx,dif_f_normalized,'-','MarkerSize',10,'LineWidth',1,'Color',[57 83 164]/255)


    plot(vecx(indices_markers),dif_f_normalized(indices_markers),'.','MarkerSize',30,'LineWidth',1,'Color',[57 83 164]/255)
    plot(vecx,slope_results.pf(1)*vecx+slope_results.pf(2),'-','LineWidth',3,'Color',[57 83 164]/255)


    set(gca,'FontSize',15);
    box off
    set(gca,'TickDir','out')
    set(gca,'XTick',vecx([1 length(vecx)]));
    set(gca,'XTickLabel',[0 1.3]);



    xlim([0.6750 1.2750])


    aaa=dif_f_normalized(1:26);

    plot(xlim,[0 0],'-','Color',[0 0 0]/255,'LineWidth',2)

    limite=max(aaa)*1.1;

    
    ylim(ylimi)


else
    error('wrong type')


end

