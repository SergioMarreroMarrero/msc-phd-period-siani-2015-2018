function [ x,x_medio,pasovector ] = divisorderebanadas( xti,xtd,rebanadas,r,B)
% Esta función divide la superficie de deslizamiento en rebanadas
% Inputs
% xti,xtd: Abscisas de los puntos de corte de la superficie deslizante
% con el talud
% rebanadas: Número de rebanadas en que se quiere dividir la superficie
% r: Vector que informa de las rectas sobre las que se encuentran los
% puntos de corte pti,ptd
% B: Base del talud
% Outputs:
% x: Vector que contiene la abscisa de los puntos sobre los que se dibujan
% las rebanadas.
% x_medio: Vector que contiene la abscisa del punto medio de cada rebanada
% pasovector: Vector que contiene el ancho de cada rebanada.
%
%

% % Subproceso repartoderebanadas
% Definimos el caso en el que estamos
    if isequal(r,[0 1 1])
        l1=xti;l2=0;l3=B;l4=xtd;
    elseif isequal(r,[1 1 0])
        l1=xti;l2=0;l3=xtd;l4=[];
    elseif  isequal(r,[1 0 1])
        l1=xti;l2=B; l3=xtd;l4=[];
    elseif isequal(r,[ 1 0 0])
        l1=xti;l2=xtd; l3=[];l4=[];
    end
%
%     Distancias y proporciones por tramo
    distanciatotal=xtd-xti;
    dist1=l2-l1;
    dist2=l3-l2;
    dist3=l4-l3;
%     Proporciones por tramo
    prop1=dist1/distanciatotal;
    prop2=dist2/distanciatotal;
    prop3=dist3/distanciatotal;
%     Rebanadas enteras por tramo
    reb1=round(prop1*rebanadas);
    reb2=round(prop2*rebanadas);
    reb3=round(prop3*rebanadas);
    
%    Tramos no representados
   if reb1==0; 
       reb1=reb1+1; 
   end;  
   if reb2==0; 
       reb2=reb2+1; 
   end;
   if reb3==0; 
       reb3=reb3+1; 
   end
   
%   Generamos el vector reb 
    reb=[reb1 reb2 reb3];  
    dimensionreb=length(reb);
     
%   Reajuste de rebanadas
    while rebanadas < sum(reb)
        [rebmayor,pos]=max(reb); %#ok<*ASGLU>
        reb(pos)=reb(pos)-1;
    end
    
    while rebanadas > sum(reb)
        [rebmayor,pos]=max(reb);
        reb(pos)=reb(pos)+1;
    end
    
    
    %Se vuelven a construir las variables reb1, reb2 reb3
    if dimensionreb==1
        
            reb1=reb(1);
            reb2=[];
            reb3=[];
                
    elseif dimensionreb==2
            reb1=reb(1);
            reb2=reb(2);
            reb3=[];
            
    elseif dimensionreb==3
            reb1=reb(1);
            reb2=reb(2);
            reb3=reb(3);
    end 
% %
% % Subproceso vectoresrebanada. 
% Calculo del vector x, x_medio, pasovector
%   Numero de total de puntos del vector x:x1,x2,x3
    Mtotal=rebanadas+1; %#ok<NASGU>
    M1=reb1+1;
    M2=reb2+1;
    M3=reb3+1;
    % Tramo 1    
    x1=linspace(l1,l2,M1); % vector x1
    paso1=x1(2)-x1(1);     % Paso1
    x1_medio=x1+paso1/2;x1_medio(end)=[]; % vector x1 medios
    paso1vector=paso1*ones(1,reb1); % Vector de pasos por rebanada 
    % Tramo 2
    if length(dist2)==1
        x2=linspace(l2,l3,M2); % vector x2
        paso2=x2(2)-x2(1);     % Paso2
        x2_medio=x2+paso2/2;x2_medio(end)=[];  % vector x2 medios
        paso2vector=paso2*ones(1,reb2); % Vector de pasos por rebanada
    else
        x2=[];paso2vector=[];x2_medio=[];
    end
    % Tramo 3
    if length(dist3)==1 
        x3=linspace(l3,l4,M3); % Puntos x3
        paso3=x3(2)-x3(1);     % Paso3
        x3_medio=x3+paso3/2;x3_medio(end)=[];% Puntos x3 medios
        paso3vector=paso3*ones(1,reb3);% Vector de pasos por rebanada
    else
        x3=[];paso3vector=[];x3_medio=[];
    end
    %     Juntamos todos los resultados
    pasovector=[paso1vector paso2vector paso3vector];%Pasos vector
    x_medio=[x1_medio x2_medio x3_medio];% Vector x medio
    x= [x1 x2 x3 ];%Vector x. Este vector tiene valores repetidos
    
           % Eliminamos los valores repetidos de x.
            countrep=0;
            repetidos=0;
            for s=2:1:length(x)
                if x(s)== x(s-1)
                    countrep=countrep+1;
                    repetidos(countrep)=s; %#ok<*AGROW>
                end
            end

            if repetidos~=0
            x(repetidos)=[];
            end
end

