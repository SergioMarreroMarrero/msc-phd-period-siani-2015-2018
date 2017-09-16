try 
    delete(handles.grafica)
end
elegirmetodo

 hadnles.grafica=figure(2);
for j=0:1
optimizar=j;
% Decidimos si queremos el mínimo optimizando o sin optimizar
switch optimizar
    case 1
        ti=tic;
        [ FSRMCO,FSRCO,MFSRCO,FSRMFSRCO,MFSRMFSRCO ] = FSRMinConOpt( a,b,PT,C,gd,fi,B,H,rebanadas,Met,Metodo );
        tfc=toc(ti);
    case 0
        tis=tic;
[FSRMSO,FSRSO]=FSRMinSinOpt(a,b,C,gd,fi,B,H,rebanadas,Met,Metodo);
        tfs=toc(tis);
end

switch optimizar
    case 0
    subplot(2,1,1)
 hold on
%% Ploteos Sin optimo 
if ~isnan(FSmax)
% Rectificamos el vector FSRSO quitando los valores FS>n
vmn=find(FSRSO(:,1)>=FSmax);
FSRSO(vmn,:)=[];
end
%Ploteamos vector
plot(FSRSO(:,2),FSRSO(:,1),'*k')
% Ploteamos mínimo
plot(FSRMSO(:,2),FSRMSO(:,1),'*r')
% Ploteamos vértices
[Dmin,R2max,Dv1,~,Dv2,~]=distminR1(B,H,a,b);
i=FSRMSO(1,1):0.01:FSRSO(1,1);
plot(Dv1+i-i,i,'-y','linewidth',1)
plot(Dv2+i-i,i,'-y','linewidth',1)
xlabel('Radios (m)','FontName','Arial','FontSize', 14);
ylabel('FS ','FontName','Arial','FontSize', 14);
hold off
    case 1
     subplot(2,1,2)
     hold on
%% Ploteos Con optimo 
if ~isnan(FSmax)
% Rectificamos el vector FSRSO quitando los valores FS>n
vmn=find(FSRCO(:,1)>=FSmax);
FSRCO(vmn,:)=[];
end
%Ploteo la cata inicial
plot(FSRCO(:,2),FSRCO(:,1),'*k')
%Ploteo los mínimos por zonas de la cata inicial
plot(MFSRCO(:,2),MFSRCO(:,1),'*g')
%Ploteo la especialización en torno a los mínimos
plot(FSRMFSRCO(:,2),FSRMFSRCO(:,1),'-b')
%Ploteo el mínimo 
plot(FSRMCO(:,2),FSRMCO(:,1),'*r')
% Ploteamos vértices
[Dmin,R2max,Dv1,~,Dv2,~]=distminR1(B,H,a,b);
i=FSRMCO(1,1):0.01:FSRCO(1,1);
plot(Dv1+i-i,i,'-y','linewidth',1)
plot(Dv2+i-i,i,'-y','linewidth',1)
xlabel('Radios (m)','FontName','Arial','FontSize', 14);
ylabel('FS ','FontName','Arial','FontSize', 14);
hold off
end
end