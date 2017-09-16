function putVerticalLines(slotsMatrix, time)
% Visualizacion de datos
for sample = 1:7
    for column = 1:2
        pos = slotsMatrix(sample,column);
        timeMark = time(pos);
        line([timeMark timeMark],get(gca,'YLim'),'Color',...
            [ mod(sample,2)~=0 mod(sample,2)==0 0])
    end
end
end


