try 
    delete(handles.grafica)
end

elegirmetodo
ti=tic;
[FSRMSO,FSRSO]=FSRMinSinOpt(a,b,C,gd,fi,B,H,rebanadas,Met,Metodo);
tf=toc(ti);
handles.grafica=figure(2);
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

    
% title('FS en un punto sin optimizar','FontName','Arial','FontSize', 14);
xlabel('Radios (m)','FontName','Arial','FontSize', 14);
ylabel('FS (m)','FontName','Arial','FontSize', 14);

hold off