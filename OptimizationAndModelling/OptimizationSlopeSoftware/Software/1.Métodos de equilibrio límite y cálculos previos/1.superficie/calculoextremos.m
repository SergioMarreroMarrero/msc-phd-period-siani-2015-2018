function [ xti,xtd,k4,r] = calculoextremos(a,b,B,H,R)
% B=H/tand(beta); % Base del talud
[puntosposibles] = intersectaludcirc( a,b,H,R,B );            % Puntos de corte circunferencia-talud
% Corte con la recta k1. Si no corta con k1 la solucion no es valida.k4=0
k1x1=puntosposibles(1,1); 
Q1=~isnan(k1x1);

if Q1==1
 %   Eliminamos las ordenadas mayores a b (centro de la circunferencia)
        ordmayqueb= puntosposibles(:,2)>b;
        puntosposibles(ordmayqueb,:)=nan;

% Comprobamos que los valores de las ordenadas de las rectas coinciden
% con los valores del talud
        y_t =taludgeometria( B,puntosposibles(:,1),H );
        d_t=find(y_t==puntosposibles(:,2));
        % Minimo dos puntos en comun        
        if length(d_t)<2
        k4=0;r=[0 0 0];xti=NaN;xtd=NaN;
        else 
%       Extraemos de la matriz puntosposibles la solucion
        puntosextremos=puntosposibles(d_t,:); %pares extremos
        raicesextremas=puntosextremos(:,1); %extraemos las raices extremas y ordenamos
        raicesextremas=sort(raicesextremas); 
%       Eliminamos la situacion "doble entrada" escogiendo el ultimo y 
%       el penultimo valor despues de ordenar
        xti=raicesextremas(end-1); 
        xtd=raicesextremas(end);
%       Buscamos en la matriz puntosextremos la imagen de xti,xtd  
        reunimos1=find(xti==puntosextremos(:,1));
        reunimos2=find(xtd==puntosextremos(:,1));
        yti=puntosextremos(reunimos1(1),2);
        ytd=puntosextremos(reunimos2(1),2);
% %       Redondeamos

%       Eliminamos los casos limite en los que k1x1=k2x1 etc. Un talud
%       formado en la misma altura.
            if yti==ytd;
                k4=0;r=[0 0 0];xti=NaN;xtd=NaN; 
            else
            k4=1;
            r=[ ((xti>=0 & xti<=B )|(xtd>=0 & xtd<=B))  xti<0   xtd>B];   
            end

        end 
        
else
k4=0;xti=NaN;xtd=NaN;r=[0 0 0]; 
end
end