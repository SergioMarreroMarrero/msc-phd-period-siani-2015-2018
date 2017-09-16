% path=uigetdir;
cd(mainpath);
cd('..\')
currentpath=pwd;
path=[currentpath,'\experimentos\experimento2'];
save(path);
cd(mainpath)
formatoPoint='.fig';
formato='fig';

% Experimento 2

                    %====================================================================%
                                         %% Parametros Maximos y minimos
                    %====================================================================%
%% Tensiones ( maximas y minimas)
vFieldPUMax=squeeze(max(vFieldPU,[],2)); % Un valor por cada nudo
vFieldPUMin=squeeze(min(vFieldPU,[],2)); % Un valor por cada nud
%%Table
nodos=1:55;
vFieldMaxMINTable=[nodos',vFieldPUMax,vFieldPUMin];
%Save Table
name='vFieldMaxMINTable';
filename=[path,'\',name,'.csv'];
csvwrite(filename,vFieldMaxMINTable,size(vFieldMaxMINTable));
%%PLOT
fig1=figure(1);
plot(nodos,vFieldPUMax,'-*b','linewidth',1,'markersize',2,'markeredgecolor','b','markerfacecolor','b')
hold on
plot(nodos,vFieldPUMin,'-*r','linewidth',1,'markersize',2,'markeredgecolor','r','markerfacecolor','r')
refline(0,1.07) % añadimos linea de referencia en tension maxima
ejeslimites=[0 55 0.95 1.15];
%axis(ejeslimites)
legend('Tensiones Máximas','Tensiones Mínimas','Tensión máxima admisible=1.07')
title('Tensión máxima y mínima alcanzada en el experimento 2')
xlabel('Nodos')
ylabel('Tensiones(pu)')
grid on
hold off
% Save plot
name='vFieldMaxMINPU';
filename=[path,'\',name,formatoPoint];
saveas(fig1,filename,formato);

                %=========================================================================%
%%Cargas Maximas y minimas
iFieldLoadMax=squeeze(max(max(iFieldLoad))); % Un valor por cada nudo
iFieldLoadMin=squeeze(min(min(iFieldLoad))); % Un valor por cada nudo
% Table
lineas=1:39;
iFieldMaxMINTable=[lineas',iFieldLoadMax,iFieldLoadMin];
%Save Table
name='iFieldMaxMINTable';
filename=[path,'\',name,'.csv'];
csvwrite(filename,iFieldMaxMINTable,size(iFieldMaxMINTable));
%%PLOT
fig2=figure(2);
plot(lineas,iFieldLoadMax,'-*b','linewidth',1,'markersize',2,'markeredgecolor','b','markerfacecolor','b')
hold on
plot(lineas,iFieldLoadMin,'-*r','linewidth',1,'markersize',2,'markeredgecolor','r','markerfacecolor','r')
refline(0,1) % añadimos linea de referencia en tension maxima
ejeslimites=[0 39 0  1.3];
%axis(ejeslimites)
legend('Cargas Máximas ','Cargas  Mínimas','Carga Maxima Admisible=1')
title('Cargas máxima y mínima alcanzada en el experimento 2)')
xlabel('Linea')
ylabel('Carga')
grid on
hold off
% Save plot
name='iFieldMaxMINPU';
filename=[path,'\',name,formatoPoint];
saveas(fig2,filename,formato);




                %====================================================================%
                       %% Tensiones en nodo 35 (fase 2), nodo 24 (fase 3), nodo 1 (fase 1)
                %====================================================================%
                
                
                
% Tension Plot
nodoFase1=1;nodoFase2=35;nodoFase3=24;
tiempo=length(vFieldPU);
fig3=figure(3);
plot((1:tiempo)',vFieldPU(nodoFase1,:),'-b','linewidth',0.5,'markersize',2,'markeredgecolor','b','markerfacecolor','b')
hold on
plot((1:tiempo)',vFieldPU(nodoFase2,:),'-r','linewidth',0.5,'markersize',2,'markeredgecolor','r','markerfacecolor','r')
plot((1:tiempo)',vFieldPU(nodoFase3,:),'-g','linewidth',0.5,'markersize',2,'markeredgecolor','g','markerfacecolor','g')
refline(0,1.07) % añadimos linea de referencia en tension maxima
ejeslimites=[0 length(vFieldPU) 0.95 1.15];
%axis(ejeslimites)
legend('Carga 1(fase 1)','Carga 35(fase 2)','Carga 24(fase 3)','Tensión máxima admisible=1.07')
title('Tensiones en las cargas 1,35,24 a lo largo de un año.')
xlabel('Horas(anual)')
ylabel('Tensiones(pu)')
grid on
hold off
% Save plot
name='v3enNudos1y35y24';
filename=[path,'\',name,formatoPoint];
saveas(fig3,filename,formato);





                %====================================================================%
                                 %% Cargas en la linea 1
                %====================================================================%



% tiempo=length(vFieldPU);
fig4=figure(4);
plot((1:tiempo)',iFieldLoad(1,:,1),'-b','linewidth',0.5,'markersize',2,'markeredgecolor','b','markerfacecolor','b')
hold on
plot((1:tiempo)',iFieldLoad(2,:,1),'-r','linewidth',0.5,'markersize',2,'markeredgecolor','r','markerfacecolor','r')
plot((1:tiempo)',iFieldLoad(3,:,1),'-g','linewidth',0.5,'markersize',2,'markeredgecolor','g','markerfacecolor','g')
refline(0,1) % añadimos linea de referencia en tension maxima
ejeslimites=[0 length(vFieldPU) 0 1.4];
%axis(ejeslimites)
legend('Fase 1','Fase 2','Fase 3','Carga máxima admisible=1')
title('Carga en la linea 1 (experimento 2)')
xlabel('Horas (anual)')
ylabel('Carga')
grid on
hold off
% Save plot
name='cargasEnLinea1';
filename=[path,'\',name,formatoPoint];
saveas(fig4,filename,formato);





                %====================================================================%
                                 %% Potencia  Activa y Reactiva en la linea 1
                %====================================================================%
                
                
                


potenciasActivaSum=sum(potenciasActiva); % La suma de las tres fases
potenciasReactivaSum=sum(potenciasReactiva); % La suma de las tres fases
% Tabla energia activa y reactiva
energiaActivaDiaria=mean(potenciasActivaSum)*8760;
energiaReactivaDiaria=mean(potenciasReactivaSum)*8760;
energiaConsumidaActivaReactivaTable=[energiaActivaDiaria , energiaReactivaDiaria];
%Save Table
name='energiaConsumidaActivaReactivaTable';
filename=[path,'\',name,'.csv'];
csvwrite(filename,energiaConsumidaActivaReactivaTable,size(energiaConsumidaActivaReactivaTable));
% Plot
fig5=figure(5);
plot((1:tiempo)',potenciasActivaSum,'-b','linewidth',0.5,'markersize',2,'markeredgecolor','b','markerfacecolor','b')
hold on
plot((1:tiempo)',potenciasReactivaSum,'-r','linewidth',0.5,'markersize',2,'markeredgecolor','r','markerfacecolor','r')
% refline(0,1) 
ejeslimites=[0 length(vFieldPU) 0 60];
%axis(ejeslimites)
legend('P(kW)','Q(kVAr)')
title('Potencias en el centro de transformación (experimento 2)')
xlabel('Horas (anual))')
ylabel('Potencia')
grid on
hold off
% Save plot
name='potenciasEnLinea1';
filename=[path,'\',name,formatoPoint];
saveas(fig5,filename,formato);





                %====================================================================%
                                 %% Tensiones e Intensidades frente a Potencia
                %====================================================================%

% Plot
fig6=figure(6);
plot(1:distribucionNumero, maxVpuInEachPotDistr,'-b*','linewidth',0.5,'markersize',2,'markeredgecolor','b','markerfacecolor','b')
hold on
plot(1:distribucionNumero,maxIloadInEachPotDistr,'-r*','linewidth',0.5,'markersize',2,'markeredgecolor','r','markerfacecolor','r')
refline(0,1.07) 
refline(0,1) 
% ejeslimites=[0 length(vFieldPU) 0 60];
%axis(ejeslimites)
legend('Tension','Intensidad','Tension máxima admisible=1.07','Carga máxima admisible=1')
title('Evolucion de las tensiones e intensidades maximas en el algoritmo de descenso (experimento 2)')
xlabel('Iteracion')
ylabel('V,I (pu)')
grid on
hold off
% Save plot
name='evolucion';
filename=[path,'\',name,formatoPoint];
saveas(fig6,filename,formato);



