function [puntosposibles] = intersectaludcirc( a,b,H,R,B )
%Recta k1. y=m*x , n=0
m1=H/B;
n1=0;
    %raices
    [ X1 ] = raicircunferecta( a,b,m1,n1,R );
    k1x1=X1(1);k1x2=X1(2);
%     Eliminamos casos de tangencia y complejos
    if  k1x1==k1x2 || imag(k1x1)~=0 
    k1x1=NaN;k1y1=NaN;
    k1x2=NaN;k1y2=NaN;
    else
    %imagen
    k1y1=m1*k1x1;k1y2=m1*k1x2;
    end
    %puntos
    k1p1=[k1x1 k1y1];k1p2=[k1x2 k1y2]; 
%Recta k2. y=0 para todo x
m2=0;
n2=0;
    %raices
    [ X2 ] = raicircunferecta( a,b,m2,n2,R);
    k2x1=X2(1);k2x2=X2(2);
    %     Eliminamos casos de tangencia y complejos
    if k2x1==k2x2 || imag(k2x1)~=0
        k2x1=NaN;k2y1=NaN;
    else
    %Imagen
    k2y1=0;k2y2=0;
    end
    %Puntos
    k2p1=[k2x1 k2y1];
    
%Recta k3. y=H 
m3=0;
n3=H;
    %raices
    [ X3 ] = raicircunferecta( a,b,m3,n3,R );
    k3x1=X3(1);k3x2=X3(2);
%     Eliminamos casos de tangencia y complejos
    if k3x1==k3x2 || imag(k2x1)~=0
    k3x2=NaN;k3y2=NaN;
    else
    %imagen
    k3y1=H;k3y2=H;
    end
     %Puntos
    k3p2=[k3x2 k3y2];
% Se agrupan en la matriz puntosposibles los puntos que pertenecen 
% al conjunto de posibles soluciones
puntosposibles=[k1p1; k1p2;k2p1; k3p2];

% Eliminamos la posibilidad de que dos puntos sean iguales. Nos encontramos
% sobre los vértices del talud. Posible función de vértices si da
% problemas. Posiblidad de usar realmin para esto.
% [~,~,Dv1,~,Dv2,~]=distminR1(B,H,a,b);

if  round(puntosposibles(1,:)*100000)/100000==round(puntosposibles(3,:)*100000)/100000  %R==Dv1 
    puntosposibles(3,:)=nan;
    puntosposibles(1,:)=[0 0];
end

if  round(puntosposibles(2,:)*100000)/100000==round(puntosposibles(4,:)*100000)/100000                            %R==Dv2                   % puntosposibles(2,:)==puntosposibles(4,:)
    puntosposibles(4,:)=nan;
    puntosposibles(2,:)=[B H];
end

end

