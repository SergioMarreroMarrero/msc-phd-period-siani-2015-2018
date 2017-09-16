try 
    delete(handles.grafica)
end
elegirmetodo
ti=tic;
[ FSRMCO,FSRCO,MFSRCO,FSRMFSRCO,MFSRMFSRCO ] = FSRMinConOpt( a,b,PT,C,gd,fi,B,H,rebanadas,Met,Metodo );
tf=toc(ti);
  handles.grafica=figure(2);
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




    