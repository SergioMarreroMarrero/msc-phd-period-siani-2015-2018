function [ whereTheRobotIs] = localizationFunction( map,posStart )
% 1) Definicion de algunas variables iniciales
blockCode=-5;positionRobotcode=-10;posWhereRobotCouldBecode=-15;
map(map==1)=blockCode;
originalMap=map;mapPosition=map;
pathThatRobotHaveDone=[]; % Store the path walked

%2)
pathThatRobotHaveDone=[pathThatRobotHaveDone posStart]; % Iniciamos el camino hecho con la posicion de partida

%3)
%%%%%%%%%%%%%%%PLOT%%%%%%%%%%%%%%%%%
mapPosition(pathThatRobotHaveDone)=positionRobotcode; % Actualizamos el camino hecho, incorporando en el mapa la la variable pathThatRobotHaveDone
plotMap(mapPosition);
pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%4)
%%%%%%%%%%%%%%%%WHERE IS THE ROBOT%%%%%%%%%%%%%%%%%%%%%%%
[currentEnvMatrix]=whatRobotSee(map,posStart);
[numMapRow,numMapColumn]=size(map);

%5)
%%%%Con este algoritmo creamos inicialmente los puntos en los que el robot
%%%%podria estar, es decir, todos los puntos del mapa (en los que haya un cero)
l=0;
for i=2:numMapRow-1 % i,j=1 el borde del mapa es un muro
    for j= 2:numMapColumn-1
        l=l+1;
        pointsWhereRobotCouldBe(l)=sub2ind(size(map),i,j);
    end
end

%6)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[pointsWhereRobotCouldBe]=matchingMapEnviromentMatrix(map,currentEnvMatrix,pointsWhereRobotCouldBe);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%7)
%%%%%%%%%%%%%%%PLOT%%%%%%%%%%%%%%%%%
mapPosition(pathThatRobotHaveDone)=positionRobotcode;
plotMap(mapPosition);
putPoints(pointsWhereRobotCouldBe,map,'r*');
pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%8)
while length(pointsWhereRobotCouldBe)>1
    %8)
    %%%%%%%%%%%%%%%%MOVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    direction=selectDirection2Move(map,pathThatRobotHaveDone,blockCode);
    [pointsWhereRobotCouldBeAfterMove]=robotMove(direction,pointsWhereRobotCouldBe,map); % Averiguamos donde esta robot despues de moverse
    pathThatRobotHaveDone=[pathThatRobotHaveDone pointsWhereRobotCouldBeAfterMove(pointsWhereRobotCouldBe==pathThatRobotHaveDone(end))]; % Actualizamos la nueva posicion del robot
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %9)
    %%%%%%%%%%%%%%%PLOT%%%%%%%%%%%%%%%%%
    mapPosition(pathThatRobotHaveDone)=positionRobotcode;
    plotMap(mapPosition);
    putPoints(pointsWhereRobotCouldBe,map,'r*');
    putPoints(pointsWhereRobotCouldBeAfterMove,map,'y*');
    pause;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %10)
    %%%%%%%%%%%%%%%%WHERE IS THE ROBOT%%%%%%%%%%%%%%%%%%%%%%%
    [currentEnvMatrix]=whatRobotSee(map,pathThatRobotHaveDone(end));
    [pointsWhereRobotCouldBe]=matchingMapEnviromentMatrix(map,currentEnvMatrix,pointsWhereRobotCouldBeAfterMove);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%PLOT%%%%%%%%%%%%%%%%%
    mapPosition(pathThatRobotHaveDone)=positionRobotcode;
    plotMap(mapPosition);
    putPoints(pointsWhereRobotCouldBe,map,'r*');
    pause;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

whereTheRobotIs=pointsWhereRobotCouldBe;

end



function enviromentMatrix=whatRobotSee(map,pos)
[posRow,posColumn]=ind2sub(size(map),pos);
enviromentMatrix=nan(3); % iniciamos la variable
j=0;
for i=[-1 0 1] %1)
    j=j+1;
    enviromentMatrix(j,:)=map(posRow+i,posColumn-1:posColumn+1); %2)
end

end

function pointsWhereRobotCouldBe=matchingMapEnviromentMatrix(map,enviromentMatrix,candidates)
j=0;
for matchPos=candidates %1)Para cada punto posible en que el robot se encuentre
    enviromentMatrixMatching=whatRobotSee(map,matchPos);%2) Sacamos la matriz del entorno de cada punto del mapa
    prob2behere=sum(sum(enviromentMatrixMatching==enviromentMatrix))==length(enviromentMatrix)^2; %2)Sumamos el numero de aciertos. Se suma dos veces porque sum() suma solo por columnas 
    if prob2behere %3) Almacenamos el resultado en la lista pointsWhereRobotCouldBe
        j=j+1;
        pointsWhereRobotCouldBe(j)=matchPos;
    end
end
end

function direction=selectDirection2Move(map,pathThatRobotHaveDone,blockCode)
map(pathThatRobotHaveDone)=blockCode;
[enviromentMatrix]=whatRobotSee(map,pathThatRobotHaveDone(end));

if enviromentMatrix(4)==0
    direction=4;
elseif enviromentMatrix(6)==0
    direction=6;
elseif enviromentMatrix(8)==0
    direction=8;
elseif enviromentMatrix(2)==0
    direction=2;
else
    disp('Something wrong')
end


end

function pointsWhereRobotCouldBeAfterMove=robotMove(direction,pointsWhereRobotCouldBe,map)
[currentRow,currentColumn]=ind2sub(size(map),pointsWhereRobotCouldBe);
if direction==4 % Up resto 1 a fila
    refreshRow=currentRow-1;
    refreshtColumn=currentColumn;
elseif direction==6 % Down sumo 1 a fila
    refreshRow=currentRow+1;
    refreshtColumn=currentColumn;
elseif direction==2 % Left resto 1 a columna
    refreshRow=currentRow;
    refreshtColumn=currentColumn-1;
elseif direction==8 % Right sumo 1  a columna
    refreshRow=currentRow;
    refreshtColumn=currentColumn+1;
else
    disp('Something wrong inside robotMove')
end
pointsWhereRobotCouldBeAfterMove=sub2ind(size(map),refreshRow,refreshtColumn);
end

function putPoints(pointsWhereRobotCouldBe,map,codePlot)
[pointColumn,pointRow]=ind2sub(size(map),pointsWhereRobotCouldBe);
hold on
plot(pointRow,pointColumn,codePlot);
end







