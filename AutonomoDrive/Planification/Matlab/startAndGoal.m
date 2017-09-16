function [start,goal] =startAndGoal(map,option)

switch lower(option)
    case 'r'
        
        freeVal=find(map==0);
        % Start
        indexStart=round(rand*length(freeVal));
        start=freeVal(indexStart);
        freeVal(indexStart)=[];
        
        %Goal
        indexGoal=round(rand*length(freeVal));
        goal=freeVal(indexGoal);
        
    case 'm'
        
        outsideMapStart=1;outsideMapGoal=1; % para entrar en el while
        plotMap(map);
        
        %start
        while outsideMapStart
            [x,y] = ginput(1);
            posStartRow=round(y);
            posStartColumn=round(x);
            outsideMapStart=map(posStartRow,posStartColumn)~=0;
        end
        %Goal
        while outsideMapGoal
            [x,y] = ginput(1);
            posGoalRow=round(y);
            posGoalColumn=round(x);
            outsideMapGoal=map(posGoalRow,posGoalColumn)~=0;
        end
        start=sub2ind(size(map),posStartRow,posStartColumn);
        goal=sub2ind(size(map),posGoalRow,posGoalColumn);
    case 'ml'
        
        outsideMapStart=1; % para entrar en el while
        plotMap(map);
        
        %start
        while outsideMapStart
            [x,y] = ginput(1);
            posStartRow=round(y);
            posStartColumn=round(x);
            outsideMapStart=map(posStartRow,posStartColumn)~=0;
        end
        
        start=sub2ind(size(map),posStartRow,posStartColumn);
        goal=1;
        
end
end


function [mapcode]=plotMap(map)
close all
mapcode=imagesc(map);
grid on
[nrow,ncolumn]=size(map);
set(gca,'xtick',1.5:1:nrow-0.5);
set(gca,'ytick',1.5:1:ncolumn-0.5);
end
