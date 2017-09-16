function [mapcode]=plotMap(map)
close all
mapcode=imagesc(map);
grid on
[rowMap,columnMap]=size(map);
set(gca,'xtick',1.5:1:rowMap-0.5);
set(gca,'ytick',1.5:1:columnMap-0.5);
end