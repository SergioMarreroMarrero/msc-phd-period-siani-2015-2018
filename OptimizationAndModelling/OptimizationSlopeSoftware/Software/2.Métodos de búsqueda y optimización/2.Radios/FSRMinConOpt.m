function [ FSRmintotal,FSR,minFSR,FSRminFSR,minFSRminFSR ] = FSRMinConOpt( a,b,PT,C,gd,fi,B,H,rebanadas,Met,Metodo )
% Esta función calcula el FS mínimo asociado a un punto aplicando técnicas
% de optmización.
% Inputs
% Mismos inputs que FSP
% Outputs
% FSRmintotal: El FS minimo asociado al punto
% Solo interesa FSRmintotal.
% El resto de outputs se utilizan para dibujar las gráficas.
%
%
pr=0.01; % Paso con el que avanza el radio
frenarderivada=0.05; % Derivada que se acepta como nula
% Calculamos distancia mínima y tramos
[Dmin,R2max,Dv1,~,Dv2,zona]=distminR1(B,H,a,b);
zona=zona';
if b>H
% % Subproceso R2max
cFSRDf=0;
R=max([Dv1 Dv2]);
while 2<3
        cFSRDf=cFSRDf+1;
         R=R+0.5;
        [ FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);    
        FSRDf(cFSRDf,:)=[FS R]; % contiene [FS; R]
        
        try %#ok<TRYNC>
            [ derivadaprimera] = FSderivada( a,b,R,pr,C,gd,fi,B,H,rebanadas,Met,Metodo );
              if derivadaprimera>0
                Dfin=FSRDf(cFSRDf,2);
              break
              end
        end
end
end
% % fin R2max
%
% %Subproceso: asignacionli 
% Las distintas posibilidades son
if b<=H   
    if isequal(zona,[0 1 0])  %Dmin==Dmc % Se encuentra en la zona central
            if min([Dv1 R2max])==Dv1 % Primero llega a Dv1
                l1=Dmin;l2=Dv1;l3=R2max;l4=0;
            elseif min([Dv1 R2max])==R2max % No llega a Dv1
                l1=Dmin; l2=R2max; l3=0;l4=0;
            end      
    elseif isequal(zona,[1 0 0])%Dmin~=Dmc Se encuentra en la zona exterior       
        l1=Dv1;l2=R2max; l3=0;l4=0;       
    end 
elseif b>H
    if isequal(zona,[0 1 0]) && Dv1~=Dv2                                         
        l1=Dmin;l2=min([Dv1 Dv2]);l3=max([Dv1 Dv2]);l4=Dfin;
    elseif  isequal(zona,[1 0 0]) || isequal(zona,[0 0 1])                       
        l1=Dmin;l2=max([Dv1 Dv2]);l3=Dfin;l4=0;
    elseif isequal(zona,[0 1 0]) && Dv1==Dv2                                                    
        l1=Dmin;l2=Dv1;l3=Dfin;l4=0;
    end
end
% % fin asignacionli
%
% Subproceso reparticionN
tramo1=l2-l1;
tramo2=l3-l2;
if tramo2==-l2
    tramo2=0;
end
tramo3=l4-l3;
if tramo3==-l3
    tramo3=0;
end
% Todo el recorrido
Tramototal=tramo1+tramo2+tramo3;
% Proporcines
prop1=tramo1/Tramototal;
prop2=tramo2/Tramototal;
prop3=tramo3/Tramototal;
% fin reparticionN
%
%  Empezamos con tramo 1
% Numero de puntos
puntostramo1=ceil(prop1*PT)+2;
Rtramo1=linspace(l1+pr,l2,puntostramo1); 
paso1=Rtramo1(2)-Rtramo1(1);
if paso1>2*pr   
        %Primera búsqueda.Matriz FSR
        cFSR=0;
        for R=Rtramo1
            cFSR=cFSR+1;
            [ FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);    
            FSR1(cFSR,:)=[FS R]; %#ok<AGROW>
        end
         % Primer mínimo.minFSR
         [FSmin1,pFSmin1] = min(FSR1(:,1)); %Buscamos FSmin
          minFSR1=[FSmin1 FSR1(pFSmin1,2)]; % contiene [FSmin R]
      if minFSR1(1,2)~=l1+pr && minFSR1(1,2)~=l2
         % Definimos la derivada para saber en que dirección hacemos la búsqueda   
         [derivadaprimera1] = FSderivada( a,b,minFSR1(1,2),pr,C,gd,fi,B,H,rebanadas,Met,Metodo );
         % Si la derivada es cercana a cero, ya se encontró el mínimo.
         if abs(derivadaprimera1)<frenarderivada 
             FSR1minFSR1=[nan nan];
             minFSR1minFSR1=minFSR1;
         else
             FSR1minFSR1(1,:)=minFSR1;
             cFSR=1;
             R=minFSR1(1,2);
             sentido=-derivadaprimera1/abs(derivadaprimera1);
             nuevosentido=sentido;
             while sentido==nuevosentido
                 cFSR=cFSR+1;
                 R=R+pr*sentido;
                  if R>=l2 || R<=l1
                      break
                  end
                 [FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);   
                 FSR1minFSR1(cFSR,:)=[FS R];
                 [derivadaprimera1] = FSderivada( a,b,R,pr,C,gd,fi,B,H,rebanadas,Met,Metodo );
                 nuevosentido=-derivadaprimera1/abs(derivadaprimera1);   
             end   
             % Buscamos el minimo del tramo minFSRminFSR  
             [FSmin1,pFSmin1] = min(FSR1minFSR1(:,1)); 
             minFSR1minFSR1=[FSmin1 FSR1minFSR1(pFSmin1,2)];
             
         end
      else
          FSR1minFSR1=[nan nan];
          minFSR1minFSR1=minFSR1;
      end
else
 % Si el tramo es muy pequeño analizamos tres puntos nada más
     Rtramo1=linspace(l1,l2,3);
         cFSR=0;
     for R=Rtramo1
        cFSR=cFSR+1;
        [FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);
        FSR1(cFSR,:)=[FS R];  
     end
     % Buscamos el minimo total del tramo FSR1 
       [FSmin1,pFSmin1] = min(FSR1(:,1)); 
       minFSR1minFSR1=[FSmin1 FSR1(pFSmin1,2)];
       % Asignamos valores a todas las variables
       FSR1minFSR1=[nan nan];
        minFSR1=[nan nan];
end     

%  pause
             
% Empezamos con tramo 2

if tramo2~=0
    puntostramo2=ceil(prop2*PT)+2;
    Rtramo2=linspace(l2+pr,l3,puntostramo2);
    paso2=Rtramo2(2)-Rtramo2(1);
if paso2>2*pr
        %Primera búsqueda.Matriz FSR
        cFSR=0;
        for R=Rtramo2
        cFSR=cFSR+1;
            [FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);    
            FSR2(cFSR,:)=[FS R] ; %#ok<AGROW>
        end
        %Primer mínimo.minFSR
       [FSmin2,pFSmin2] = min(FSR2(:,1)); 
        minFSR2=[FSmin2 FSR2(pFSmin2,2)] ;
   if minFSR2(1,2)~=l2+pr && minFSR2(1,2)~=l3
        %Definimos la derivada para saber en que dirección hacemos la búsqueda       
         [derivadaprimera2] = FSderivada( a,b,minFSR2(1,2),pr,C,gd,fi,B,H,rebanadas,Met,Metodo );
         if abs(derivadaprimera2)<frenarderivada  
             FSR2minFSR2=[nan nan];
             minFSR2minFSR2=minFSR2;   
         else
             FSR2minFSR2(1,:)=minFSR2;
             cFSR=1;
             R=minFSR2(1,2);
             sentido=-derivadaprimera2/abs(derivadaprimera2);
             nuevosentido=sentido;
             while sentido==nuevosentido
                 cFSR=cFSR+1;
                 R=R+pr*sentido;
                 if R>=l3 || R<=l2
                      break
                  end
                 [ FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);   
                 FSR2minFSR2(cFSR,:)=[FS R];
                 [derivadaprimera2] = FSderivada( a,b,R,pr,C,gd,fi,B,H,rebanadas,Met,Metodo );
                 nuevosentido=-derivadaprimera2/abs(derivadaprimera2);      
             end
             %Buscamos el mínimo del tramo
        [FSmin2,pFSmin2] = min(FSR2minFSR2(:,1)); 
        minFSR2minFSR2=[FSmin2 FSR2minFSR2(pFSmin2,2)];
        
         end 
   else
            FSR2minFSR2=[nan nan];
             minFSR2minFSR2=minFSR2;   
    end 
else
%Si el tramo es muy pequeño se analizan tres puntos
        cFSR=0;
    for Rtramo2=linspace(l2,l3,3)
        cFSR=cFSR+1;
        [ FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);    
        FSR2(cFSR,:)=[FS R];  %#ok<AGROW>
    end
    % Buscamos el minimo total del tramo FSR1 
       [FSmin2,pFSmin2] = min(FSR2(:,1)); 
       minFSR2minFSR2=[FSmin2 FSR2(pFSmin2,2)];
       % Asignamos valor a todas las variables
       FSR2minFSR2=FSR2;
       minFSR2=[nan nan];
end 
end
% pause
%    Tramo 3 
if tramo3~=0
puntostramo3=ceil(prop3*PT)+2;
Rtramo3=linspace(l3+pr,l4,puntostramo3);
paso3=Rtramo3(2)-Rtramo3(1);
if paso3>2*pr
    %Primera búsqueda.Matriz FSR
        cFSR=0;
    for R=Rtramo3
        cFSR=cFSR+1;
        [FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);    
        FSR3(cFSR,:)=[FS R];  %#ok<AGROW>
    end
    %Buscamos el primer mínimo minFSR
    [FSmin3,pFSmin3] = min(FSR3(:,1)); 
    minFSR3=[FSmin3 FSR3(pFSmin3,2)]; 
  if minFSR3(1,2)~=l3+pr && minFSR3(1,2)~=l4
    %Definimos la derivada para saber en que dirección hacemos la búsqueda
    [derivadaprimera3] = FSderivada( a,b,minFSR3(1,2),pr,C,gd,fi,B,H,rebanadas,Met,Metodo);
    if abs(derivadaprimera3)<frenarderivada  
        FSR3minFSR3=[nan nan];
        minFSR3minFSR3= minFSR3;    
    else
    FSR3minFSR3(1,:)=minFSR3;
    cFSR=1;
    R=minFSR3(1,2);
    sentido=-derivadaprimera3/abs(derivadaprimera3);
    nuevosentido=sentido;
         while sentido==nuevosentido
             cFSR=cFSR+1;
             R=R+pr*sentido;
              if R>=l4 || R<=l3
                      break
              end
            [ FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);   
            FSR3minFSR3(cFSR,:)=[FS R];
            [derivadaprimera3] = FSderivada( a,b,R,pr,C,gd,fi,B,H,rebanadas,Met,Metodo );
            nuevosentido=-derivadaprimera3/abs(derivadaprimera3);      
         end
         %Buscamos el minimo del tramo  minFSR3minFSR3
    [FSmin3,pFSmin3] = min(FSR3minFSR3(:,1)); %Buscamos FSmin
     minFSR3minFSR3=[FSmin3 FSR3minFSR3(pFSmin3,2)]; % contiene [FSmin R] 
    end 
  else
        FSR3minFSR3=[nan nan];
        minFSR3minFSR3= minFSR3; 
  end
else
         cFSR=0;
     for Rtramo3=linspace(l3,l4,3)
        cFSR=cFSR+1;
        [ FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);    
        FSR3(cFSR,:)=[FS R];    %#ok<AGROW>
     end
     % Buscamos el minimo total del tramo FSR1 
       [FSmin3,pFSmin3] = min(FSR3(:,1)); 
       minFSR3minFSR3=[FSmin3 FSR3(pFSmin3,2)];
       % Asignamos valor a todas las variables
       FSR3minFSR3=FSR3;
       minFSR3=[nan nan];
end    
end
% pause
%     
% Se unen aquí todos los vectores
FSR=FSR1;
FSRminFSR=FSR1minFSR1;
minFSR=minFSR1;
minFSRminFSR=minFSR1minFSR1;

if tramo2~=0
    FSR=[FSR1;nan nan; FSR2];
    FSRminFSR=[FSR1minFSR1; nan nan; FSR2minFSR2];
    minFSR=[minFSR1; minFSR2];
    minFSRminFSR=[minFSR1minFSR1; minFSR2minFSR2];
end
if tramo3~=0
    FSR=[FSR1;nan nan; FSR2;nan nan; FSR3];
    FSRminFSR=[FSR1minFSR1;nan nan; FSR2minFSR2; nan nan;FSR3minFSR3];
    minFSR=[minFSR1; minFSR2; minFSR3];
    minFSRminFSR=[minFSR1minFSR1; minFSR2minFSR2; minFSR3minFSR3];
end

%Elegimos el mínimo total  
[FSmin,pFSmin] = min(minFSRminFSR(:,1)); %Buscamos FSmin
FSRmintotal=[FSmin minFSRminFSR(pFSmin,2)]; % contiene [FSmin R]    

end

