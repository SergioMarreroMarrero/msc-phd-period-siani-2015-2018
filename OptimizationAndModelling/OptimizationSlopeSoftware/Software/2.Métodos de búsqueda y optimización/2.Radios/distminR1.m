function [D,R2max,D1,D2,D3,zona]=distminR1(B,H,a,b)
% Esta función calcula algunos parámetros útiles para reducir el número de
% iteraciones inútiles.
% Inputs
% B,H: Base y altura del talud.
% a,b: Centro de la circunferencia.
% Outputs
% D: Distancia mas corta entre el centro y el talud.
% R2max: Radio máximo cuando b<H.
% D1: Distancia del centro al vértice izquierdo
% D2: Distancia perpendicular entre el centro y la recta k1
% D3: Distancia del centro al vértice derecho
% zona: Vector que contiene la zona en la que se encuentra el centro
%
%
%
% Variables necesarias
m=H/B;
beta=atand(m);
% 1) Matriz de transformación de coordenadas
MTC=[cosd(beta) sind(beta);-sind(beta) cosd(beta)];
% 2) Vertice superior 
Vs=[sqrt(B^2+H^2); 0];
L=Vs(1,1);
% 3) Centro C'(a',b') en coordenadas OX'Y'
Cp=MTC*[a b]';
ap=Cp(1,1);
bp=Cp(2,1);
% 4) Localización de zonas (zona=[zona izquierda zona central zona derecha])
zona=[ap<=0 ap>0 && ap<L ap>=L]'; 
% 5)Calculo de distancias
D1=sqrt(a^2+b^2);
D2=bp;
D3=sqrt(((a-B)^2)+((b-H)^2));
Dvect=[D1 D2 D3];
% 6) Asignación de la distancia segun la zona
D=Dvect*zona;
%7) Radio mazimo si b<H
R2max=-a+(b/m);
end