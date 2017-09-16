function [ findWay] = waveFrontPlan( map,start,goal )
blockcode=-5;originalMap=map;
map(map==1)=blockcode; % Cambiamos el valor de las zonas bloqueadas del mapa.
plotStartGoal(map,start,goal); % Plotea los resultados
pause;
frontWave=start;% Variable que contiene los distintos frentes de onda.
finish=0; % Permite salir del bucle cuando se haya finalizado


%1)
%%%%%%%%%%%%%%%%% EXPANSION DE LA ONDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while finish==0 
    [map,frontWave,finish]= updateMapandWaveFront(map,goal,frontWave);
    plotStartGoal(map,start,goal); % Plotea los resultados
    pause
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2)
%%%%%%%%%%%%BUSQUEDA DEL CAMINO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotStartGoal(map,start,goal); 
[findWay] = findingWay(map,start,goal);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


%%%%%%%%%%%%%%%%%%%%%%%%%%FUNCIONES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%% EXPANSION DE LA ONDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [map,frontWave,finish]= updateMapandWaveFront(map,goal,frontWave)
[nrow,ncol]=size(map);
newfrontWave=[]; %1)
for f=1:length(frontWave) %2)
    
    [cPoswfRow,cPoswfColumn] = ind2sub([nrow,ncol],frontWave(f)); % Pasamos de formato indice a formato row,col
    
    % 3)(En el pseudocodigo de la memoria se propone un bucle for. Aqui se despliegan las 4 opciones) 
    % 3)Comprobamos las inmediaciones de cada posicion del frente de onda
    % 4) Si se cumple alguna, se entra y se ejecutan las instrucciones
    if map(cPoswfRow,cPoswfColumn-1)==0
        map(cPoswfRow,cPoswfColumn-1)=map(cPoswfRow,cPoswfColumn)+1; %5) (para todas las demás igual)
        indleft=sub2ind([nrow,ncol],cPoswfRow,cPoswfColumn-1);%6)
        newfrontWave=[newfrontWave; indleft];%6)
    end
    
    if map(cPoswfRow,cPoswfColumn+1)==0
        map(cPoswfRow,cPoswfColumn+1)=map(cPoswfRow,cPoswfColumn)+1;
        indright=sub2ind([nrow,ncol],cPoswfRow,cPoswfColumn+1);
        newfrontWave=[newfrontWave; indright];
    end
    
    
    if  map(cPoswfRow-1,cPoswfColumn)==0
        map(cPoswfRow-1,cPoswfColumn)=map(cPoswfRow,cPoswfColumn)+1;
        inddown=sub2ind([nrow,ncol],cPoswfRow-1,cPoswfColumn);
        newfrontWave=[newfrontWave; inddown];
    end
    
    if  map(cPoswfRow+1,cPoswfColumn)==0
        map(cPoswfRow+1,cPoswfColumn)=map(cPoswfRow,cPoswfColumn)+1;
        indup=sub2ind([nrow,ncol],cPoswfRow+1,cPoswfColumn);
        newfrontWave=[newfrontWave; indup];
    end
end

frontWave=newfrontWave;%7)
if frontWave~=goal %8)
    disp('No hemos llegado');
    finish=0;
else
    finish=1;
end
end
%%%%%%%%%%%%BUSQUEDA DEL CAMINO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [way] = findingWay(map,start,goal)
%Inicieamos algunas variables y parametros
[filas,columnas]=size(map);
way=goal; %1) Iniciamos el camino
mapPlot=map;finish=0;
wayCode=-50;

while finish==0 %2) Iniciamos el bucle para recorrer el camino de vuelta
    [cfrontWayRow,cfrontWayColumn] = ind2sub([filas,columnas],way(end)); % Cambiamos de formato
   % 3) Calculamos los gradientes
    gradleft = map(cfrontWayRow,cfrontWayColumn)-map(cfrontWayRow,cfrontWayColumn-1);
    gradright = map(cfrontWayRow,cfrontWayColumn)-map(cfrontWayRow,cfrontWayColumn+1);
    graddown = map(cfrontWayRow,cfrontWayColumn)-map(cfrontWayRow-1,cfrontWayColumn);
    gradup = map(cfrontWayRow,cfrontWayColumn)-map(cfrontWayRow+1,cfrontWayColumn);
    % 4) Elegimos una direccion de avance. Se podría haber solucionado con
    % un for, sin embargo se desplegaron todas las opciones.
    
    if map(cfrontWayRow,cfrontWayColumn-1)>0 &&  gradleft>=0 % 5) Para cada direccion las mismas condiciones.
        
        newfrontWay=sub2ind([filas,columnas],cfrontWayRow,cfrontWayColumn-1);
        way=[way newfrontWay]; % 6)Incluimos la casilla en el camino
        pause;
        
        mapPlot(newfrontWay)=wayCode;
        plotStartGoal(mapPlot,start,goal);
        pause;
    elseif map(cfrontWayRow,cfrontWayColumn+1)>0 &&  gradright>=0
        
        newfrontWay=sub2ind([filas,columnas],cfrontWayRow,cfrontWayColumn+1);
        way=[way newfrontWay];
        
        
        mapPlot(newfrontWay)=wayCode;
        plotStartGoal(mapPlot,start,goal);
        pause;
    elseif map(cfrontWayRow-1,cfrontWayColumn)>0 &&  graddown>=0
        
        newfrontWay=sub2ind([filas,columnas],cfrontWayRow-1,cfrontWayColumn);
        way=[way newfrontWay];
        
        
        mapPlot(newfrontWay)=wayCode;
        plotStartGoal(mapPlot,start,goal);
        pause;
    elseif map(cfrontWayRow+1,cfrontWayColumn)>0 &&  gradup>=0
        
        newfrontWay=sub2ind([filas,columnas],cfrontWayRow+1,cfrontWayColumn);
        way=[way newfrontWay];
        
        
        mapPlot(newfrontWay)=wayCode;
        plotStartGoal(mapPlot,start,goal);
        pause;
    else
        disp('Finish')
        finish=1;
        
    end
end
way(1)=[];
end

%%%%%%%%%%%%%%PEQUEÑA FUNCION PARA PLOTEAR CON COMODIAD%%%%%%%%%%%%%%%
function plotStartGoal(map,start,goal)
imagesc(map)
% Coloca en el mapa Start y goal
[rows,columns]=size(map);
[startRow,startColumn] = ind2sub([rows,columns],start);
[goalRow,goalColumn] = ind2sub([rows,columns],goal);
% Texto que queremos colocar en start y goal
text(startColumn,startRow,'S')
text(goalColumn,goalRow,'G')
% Colocamos grid
[nrow,ncolumn]=size(map);
grid on
set(gca,'xtick',1.5:1:ncolumn+0.5);
set(gca,'ytick',1.5:1:nrow+0.5);
end