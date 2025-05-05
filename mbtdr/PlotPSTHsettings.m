function [chceind, cntxtind,moinds,colinds,cmap,mrkrface,flp,colorstr] = PlotPSTHsettings(settings)

switch settings
    
    case  1 % motion context, averaged over color, preferred choice and motion direction
        chceind = 2;cntxtind = 2;
        moinds = 4:6;colinds = zeros(3,1);
        cmap = 'redblue';%nc = length(condindNews);
        mrkrface = 'full';flp = 1;
        colorstr = {'l','d','k'};
    case  2 % motion context, averaged over color, nonpreferred choice and motion direction
        chceind = 1;cntxtind = 2;
        moinds = 1:3;colinds =zeros(3,1);
        cmap ='redblue';
        mrkrface = 'empty';flp = 0;
        colorstr = {'k','d','l'};
    case  3 % motion context, averaged over motion, preferred direction choice, preferred color direction
        chceind = 2;cntxtind = 2;
        colinds = 4:6;moinds = zeros(3,1);
        cmap = 'blue';
        mrkrface = 'full';flp = 1;
        colorstr = {'z','s','b'};
    case  4 % motion context, averaged over motion, preferred choice, antipreferred color direction
        chceind = 2;cntxtind = 2;
        colinds = 1:3;moinds = zeros(3,1);
        cmap = 'blue';
        mrkrface = 'empty';flp = zeros(3,1);
    case 5 % motion context, averaged over motion, nonpreferred choice, preferred color direction
        chceind = 1;cntxtind = 2;
        colinds = 4:6;moinds = zeros(3,1);
        cmap = 'blue';
        mrkrface = 'full';flp = 1;
        colorstr = {'z','s','b'};
    case 6 % motion context, averaged over motion, nonpreferred choice, nonpreferred color direction
        chceind = 1;cntxtind = 2;
        colinds = 1:3;moinds = zeros(3,1);
        cmap = 'blue';
        mrkrface = 'empty';flp = 0;
    case  7% Color context, averaged over motion, preferred direction
        chceind = 2;cntxtind = 1;
        colinds = 4:6;moinds = zeros(3,1);
        cmap = 'blue';
        mrkrface = 'full';flp = 1;
        colorstr = {'z','s','b'};
    case  8% Color context, averaged over motion, nonpreferred direction
        chceind = 1;cntxtind = 1;
        colinds = 1:3;moinds = zeros(3,1);
        cmap = 'blue';
        mrkrface = 'empty';flp = 0;
        colorstr = {'b','s','z'};
        
    case 9% Color context, averaged over color, preferred choice, preferred motion stimulus
        chceind = 2;cntxtind = 1;
        moinds = 4:6;colinds = zeros(3,1);
        cmap ='darkgray';
        mrkrface = 'full';flp = 1;
        colorstr = {'l','d','k'};
    case 10% Color context, averaged over color, preferred choice, nonpreferred motion stimulus
        chceind = 2;cntxtind = 1;
        moinds = 1:3;colinds = zeros(3,1);
        cmap ='darkgray';%nc = length(condindNews);
        mrkrface = 'empty';flp = 0;
        colorstr = {'k','d','l'};
    case 11% Color context, averaged over color, nonpreferred direction, preferred motion stimulus
        chceind = 1;cntxtind = 1;
        moinds = 4:6;colinds = zeros(3,1);
        cmap ='darkgray';
        mrkrface = 'full';flp = 1;
        colorstr = {'l','d','k'};
    case 12% Color context, averaged over color, nonpreferred direction, nonpreferred motion stimulus
        chceind = 1;cntxtind = 1;
        moinds = 1:3;colinds = zeros(3,1);
        cmap ='darkgray';
        mrkrface = 'empty';flp = 0;
        colorstr = {'k','d','l'};
    case 13% Motion context, strongest preferred color, nonpreferred motion direction
        chceind = 1;cntxtind = 2;
        moinds = 1:3;colinds = 6*ones(1,3);
        cmap ='darkgray';
        mrkrface = 'empty';flp = 0;
        colorstr = {'k','d','l'};
    case 14% Motion context, strongest preferred color, preferred motion direction
        chceind = 2;cntxtind = 2;
        moinds = 4:6;colinds = 6*ones(1,3);
        cmap ='darkgray';
        mrkrface = 'empty';flp = 1;
        colorstr = {'k','d','l'};
    case 15% Motion context, strongest nonpreferred color, nonpreferred motion direction
        chceind = 1;cntxtind = 2;
        moinds = 1:3;colinds = 1*ones(1,3);
        cmap ='darkgray';
        mrkrface = 'empty';flp = 0;
        colorstr = {'k','d','l'};
    case 16% Motion context, strongest nonpreferred color, preferred motion direction
        chceind = 2;cntxtind = 2;
        moinds = 4:6;colinds = 1*ones(1,3);
        cmap ='darkgray';
        mrkrface = 'empty';flp = 1;
        colorstr = {'k','d','l'};
    case 17% color context, strongest preferred motion, nonpreferred color direction
        chceind = 1;cntxtind = 1;
        moinds = 6*ones(1,3);colinds = 1:3;
        cmap ='blue';
        mrkrface = 'empty';flp = 0;
        colorstr = {'k','d','l'};
    case 18% color context, strongest preferred motion, preferred color direction
        chceind = 2;cntxtind = 1;
        moinds = 6*ones(1,3);colinds = 4:6;
        cmap ='blue';
        mrkrface = 'empty';flp = 1;
        colorstr = {'k','d','l'};
    case 19% color context, strongest nonpreferred motion, nonpreferred color direction
        chceind = 1;cntxtind = 1;
        moinds = 1*ones(1,3);colinds = 1:3;
        cmap ='blue';
        mrkrface = 'empty';flp = 0;
        colorstr = {'k','d','l'};
    case 20% color context, strongest nonpreferred motion, preferred color direction
        chceind = 2;cntxtind = 1;
        moinds = 1*ones(1,3);colinds = 4:6;
        cmap ='blue';
        mrkrface = 'empty';flp = 1;
        colorstr = {'k','d','l'};
end