clear
clc
%1) Cargamos mapa
load mapWorld1 
map=mapWorld1;
%% 2) Elegimos metodo
option=input('random(r) or manual with mouse(m) or manual for only Localization(ml)','s');
% Esta funcion genera START y GOAl
[start,goal] =startAndGoal(map,option); 
%% 3) PLANNING %% 
[findWay] = waveFrontPlan( mapWorld1,start,goal );

%% 4) LOCALIZATION %%
[whereTheRobotIs] = localizationFunction( map,start);

%% 5) INTEGRATION %%
[whereTheRobotIs] = localizationFunction( map,start);
[findWay] = waveFrontPlan( map,whereTheRobotIs,goal );

