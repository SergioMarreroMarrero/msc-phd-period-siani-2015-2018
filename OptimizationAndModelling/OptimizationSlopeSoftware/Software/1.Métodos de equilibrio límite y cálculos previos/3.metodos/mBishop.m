function [FS,num,den] = mBishop( y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi )
% Esta función calcula el FS por el método de Bishop simplificado
% Inputs
% y_talud_med,y_circ_med,alfa,pasovector: Outputs función parametros
% Outputs
% gd: Peso especifico del terreno
% C: Cohesión efectica del terreno
% fi: Angulo de rozamiento del terreno
% Outputs
% FS: Factor de seguridad por el método de Bishop simplificado
% num: Numerador del cociente FS=num/den
% den: Denominador del cociente FS=num/den
%
%
%

% 1) Peso de cada rebanada
altura=y_talud_med-y_circ_med;
area=pasovector.*altura;
W=gd*area;

% 2) Calculamos Denominador (fuerzas desestabilizadoras (Stress))
T=W.*sind(alfa);
den=sum(T);
                           
% 3) Calculamos Numerador (fuerzas estabilizadoras (Strength))y FSB 
B1=C*pasovector;B2=W*tand(fi);B3=cosd(alfa);B4=tand(fi)*sind(alfa);
% Contador i=0 % Primer FS=1 % definimos toleranciaB1=1>0.001 para entrar
i=0;FS(1)=1;toleranciaB=1; 
    while toleranciaB>0.0001   
        i=i+1 ;
        B5=B3+B4./FS(i) ;B6=1./B5;
    	num=sum((B1+B2).*B6);  
        FSB=abs(num/den);          
% 4) Guardamos el FSB en un vector y calculamos el error
        FS(i+1)=FSB; %#ok<AGROW> % Guardamos cada valor de FSB en el vector FS(i)
        toleranciaB=abs(FS(i+1)-FS(i)); % Calculamos el error
    end
% 5) Escogemos el último puesto como representante
        FS=FS(end); % Nos quedamos con el último FS
end






