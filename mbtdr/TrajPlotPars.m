function [Tmatches, setts] = TrajPlotPars(type,animal)

if type==1% CorrIncorr, All Correct, active stimuli
    
    setts{1} = 1:2;
    setts{2} = [1 2 7 8];
    setts{3} = 7:8;
    setts{4} = [1 2 7 8];
    setts{5} = 1:2;
    setts{6} = 7:8;
elseif type==2% Cross-modulated
    setts{1} = 13:16;
    setts{3} = 17:20;
    setts{2} = 13:20;
    setts{4} = 13:20;
    setts{5} = 13:16;
    setts{6} = 17:20;
elseif type==3% CorrIncor, All Correct, inactive stimuli
    setts{1} = 9:12;
    setts{2} = [3:6 9:12];
    setts{3} = 3:6;
    setts{4} = [3:6 9:12];
    setts{5} = 9:12;
    setts{6} = 3:6;
elseif type==4% CorrIncorr, averaged over irrelevant variables
    setts{1} = [1 9 11; 2 10 12];% averaging over color, separated by motion direction
    setts{2} = [1 3 4 7 9 10;2 5 6 8 11 12];% all cases, separated by decision direction
    setts{3} = [3 5 7;4 6 8];% averaging over motion, separated by color direction
    setts{4} = [1:6; 7:12];% All cases, separated by context
    setts{5} = [1 9 11; 2 10 12];% Same as 1
    setts{6} = [3 5 7;4 6 8];% Same as 3
end


Tmatches = cell(6,1);
for p = 1:6
    if strcmp(animal,'ar')
        switch p
            case 1
                tpoints = repmat([20 15 31 20 30 40],numel(setts{p}),1);
            case 3
                tpoints = repmat([27 57 45],numel(setts{p}),1);
            case 2
                tpoints = repmat([57 50 30 25],numel(setts{p}),1);
            case 4
                tpoints = repmat([20 10 25 4 30 30],numel(setts{p}),1);
            case 5
                tpoints = repmat([20 15 31 20 30 40],numel(setts{p}),1);
            case 6
                tpoints = repmat([27 57 45],numel(setts{p}),1);
        end
    elseif strcmp(animal,'fe')
        switch p
            case 1
                tpoints = repmat([20 15 31 20 30 40],numel(setts{p}),1);
            case 3
                tpoints = repmat([27 57 45],numel(setts{p}),1);
            case 2
                tpoints = repmat([57 50 30 25],numel(setts{p}),1);
            case 4
                tpoints = repmat([57 10 25 4 30 30],numel(setts{p}),1);
            case 5
                tpoints = repmat([25 50 31 20 30 40],numel(setts{p}),1);
            case 6
                tpoints = repmat([27 57 45],numel(setts{p}),1);
        end
    
    end
    
    if ~isempty(animal)
        Tmatches{p}(setts{p},:) = tpoints;
    else
                fprintf('No animal specified. No switch points assigned.\n')
    end
end