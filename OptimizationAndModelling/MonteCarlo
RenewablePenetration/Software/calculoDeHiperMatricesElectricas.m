function [vField,vFieldPU,iField,iFieldLoad,potenciasActiva,potenciasReactiva]=calculoDeHiperMatricesElectricas(DSSMonitors)
%% Calculo de tensiones en puntos
nudosylineas;
%
electricParameter='v';
tensionNames=stringNodesGenerate(points2Tension);% Definicion de nombres
[vField,vFieldPU]=parameterPhaseTimeNodesConcatenation(tensionNames,electricParameter,DSSMonitors,faseNudo);

%% Calculo de Intensidades en linea
electricParameter='i';
intensityNames=stringNodesGenerate(points2Intensity);
[iField,iFieldLoad]=parameterPhaseTimeNodesConcatenation(intensityNames,electricParameter,DSSMonitors,caractLoad);

%% Calculo de Potencias (activa y reactiva)
electricParameter='p';
potNames='TR1PQ';
potenciasActivaYReactiva=parameterPhaseTimeNodesConcatenation(potNames,electricParameter,DSSMonitors,caractLoad);
potenciasActiva=squeeze(-potenciasActivaYReactiva(:,:,1));
potenciasReactiva=squeeze(-potenciasActivaYReactiva(:,:,2));
end