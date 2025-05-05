function colorrgb = GetShade(basecol,endcol,shadeInd,Numshades)

if ischar(basecol)
    basecolor = ColorCode(basecol);
else
    basecolor = basecol;
end

if ischar(endcol)
    endcolor = ColorCode(endcol);
else
    endcolor = endcol;
end
r = linspace(basecolor(1,1), endcolor(1,1), Numshades);
g = linspace(basecolor(1,2), endcolor(1,2), Numshades);
b = linspace(basecolor(1,3), endcolor(1,3), Numshades);
colorrgb = [r(shadeInd) g(shadeInd) b(shadeInd)];

function cc = ColorCode(colstr)

    if strcmp(colstr,'y')
        cc = [1 1 0];
    elseif strcmp(colstr,'m')
        cc = [1 0 1];
    elseif strcmp(colstr,'c')
        cc = [0 1 1];
    elseif strcmp(colstr,'r')
        cc = [1 0 0];
    elseif strcmp(colstr,'g')
        cc = [0 1 0];
    elseif strcmp(colstr,'b')
        cc = [0 0 1];
    elseif strcmp(colstr,'k')
        cc = [0 0 0];
    elseif strcmp(colstr,'w')
        cc = [1 1 1];
    elseif strcmp(colstr,'k')
        cc = [0 0 0];
    end
