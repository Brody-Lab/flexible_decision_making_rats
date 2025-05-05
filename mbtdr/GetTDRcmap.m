function lc = GetTDRcmap(settings,flp)

if any(settings==[1 2 9:12 13:16])
    lc = redblue(7);
else
    lc = parula(8);
    lc(1,:) = [];
    
    for kk = 1:3
        lc(kk,:) = GetShade(lc(kk,:),[1 1 1],kk,5);
        lc(7-kk,:) = GetShade(lc(7-kk,:),[1 1 1],kk,5);
    end
end
if flp==1;lc(1:4,:) = [];end
% if any(settings==[1 2 9:12 13:16])
%         [map, descriptorname, description] = colorcet('D1');
%         ncol = size(map,1);
%         lc = interp1(map,[1:ncol/5:ncol ncol]);
% else
%         [map, descriptorname, description] = colorcet('D2');
%         ncol = size(map,1);
%         lc = interp1(map,[1:ncol/5:ncol ncol]);
% end
% if flp==1;lc(1:3,:) = [];end

