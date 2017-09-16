function [FSRmin,FSR]=FSRMinSinOpt(a,b,C,gd,fi,B,H,rebanadas,Met,Metodo)
% Esta función calcula el FS mínimo asociado a un punto sin aplicar técnicas
% de optmización.
pr=0.01;
% Calculamos distancias
[Dmin,R2max,Dv1,~,Dv2,~]=distminR1(B,H,a,b);
Dfin=0;
% Distancia final
if b>H
cFSRDf=0;
R=max([Dv1 Dv2]);
while 2<3
        cFSRDf=cFSRDf+1;
         R=R+0.5;
        [ FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);    
        FSRDf(cFSRDf,:)=[FS R]; %#ok<AGROW> % contiene [FS R]
        try %#ok<TRYNC>
            [ derivadaprimera] = FSderivada( a,b,R,pr,C,gd,fi,B,H,rebanadas,Met,Metodo );
              if derivadaprimera>0
                Dfin=FSRDf(cFSRDf,2);
              break
              end
        end
end
end
%
l1=Dmin+pr;
l2=R2max*(b<=H)+Dfin*(b>H);
cFSR=0;
for R=l1:pr:l2
    cFSR=cFSR+1;
    [ FS] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo);    
    FSR(cFSR,:)=[FS(end) R]; %#ok<AGROW> % contiene [FS; R]
    R=R+pr;  %#ok<FXSET>
end
% Buscamos la pareja FSmin,R
 [FSmin,pFSmin] = min(FSR(:,1)); % Buscamos FSmin
 FSRmin=[FSmin FSR(pFSmin,2)]; % contiene [FSmin R]
end

