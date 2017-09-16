function [ FS,num,den ] = mFelle( y_talud_med,y_circ_med,alfa ,pasovector,gd,C,fi )
% Esta función calcula el FS por el método de Fellenius
% Inputs
% y_talud_med,y_circ_med,alfa,pasovector: Outputs función parametros
% Outputs
% gd: Peso especifico del terreno
% C: Cohesión efectica del terreno
% fi: Angulo de rozamiento del terreno
% Outputs
% FS: Factor de seguridad por el método de Fellenius
% num: Numerador del cociente FS=num/den
% den: Denominador del cociente FS=num/den
%
%
% 1) Calculamos la superficie inferior de la rebanada
l=pasovector./cosd(alfa);
% 2) Peso de cada rebanada
altura=y_talud_med-y_circ_med;
area=pasovector.*altura;
W=gd*area;
% 3) Calculamos Denominador (fuerzas desesestabilizadoras (Stress))
T=W.*sind(alfa);    % descomposicion del peso(W) en la tangencial
den=sum(T); 
% 4) Calculamos Numerador (fuerzas estabilizadoras (Strength))
cohesion=C*l;       
N=W.*cosd(alfa);    % descomposicion del peso(W) en la normal
rozamiento=N*tand(fi);
num=sum(cohesion+rozamiento);
% 5) Calculamos el factor de seguridad (FS)
FS=abs(num/den);
end

