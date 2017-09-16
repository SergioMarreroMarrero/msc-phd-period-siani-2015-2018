function [ X ] = raicircunferecta( a,b,m,n,R )
% Calcula los puntos de corte entre una circunferencia y una y una recta 
% Devuelve las soluciones en el vector X
% ordenados de menor a mayor.
% Inputs
% a:Posición de el centro sobre el eje x
% b:Desplazamiento del centro sobre el eje y
% m:Pendiente de la recta
% n:Ordenada en el origen
% R:Radio de la circunferencia
% Outputs
% X:Puntos de corte de la circunferencia ordenados de menor a mayor.
A=m^2+1;
B=2*m*(n-b)-2*a;
C=(a^2)-(R^2)+(n-b)^2;
coeficientes=[A B C];
[X] = segundogrado( coeficientes);
end
