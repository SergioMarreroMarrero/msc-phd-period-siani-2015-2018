
borrarelmarco

% handles.prueba=figure;
axes(handles.axes1)

% Vertice primero. Punto de inicio
hold on
[x1,y1]=ginput(1);
vp=[x1 y1];
vp=round(vp*1000)/1000;

handles.punto1=plot(vp(1),vp(2),'b*');

set(handles.pinicialx,'String',num2str(vp(1)));
set(handles.pinicialy,'String',num2str(vp(2)))



% Vertice final. Base
[x2,y2]=ginput(1);
vf=[x2 y2];
vf=round(vf*1000)/1000;
handles.punto4=plot(vf(1),vf(2),'b*');
set(handles.pfinalx,'String',num2str(vf(1)))
set(handles.pfinaly,'String',num2str(vf(2)))


% Vertice de altura. Altura
vh=[vp(1) vf(2)];
handles.punto2=plot(vh(1),vh(2),'b*');
% set(handles.palturax,'String',num2str(vh(1)))
% set(handles.palturay,'String',num2str(vh(2)))



% Vertice de longitud. Base
vb=[vf(1) vp(2)];
handles.punto3=plot(vb(1),vb(2),'b*');
% set(handles.pbasex,'String',num2str(vb(1)))
% set(handles.pbasey,'String',num2str(vb(2)))


handles.lynea1=line([vp(1) vh(1)],[vp(2) vh(2)]);
handles.lynea2=line([vh(1) vf(1)],[vh(2) vf(2)]);
handles.lynea3=line([vf(1) vb(1)],[vf(2) vb(2)]);
handles.lynea4=line([vb(1) vp(1)],[vb(2) vp(2)]);

hold off
%Asignación de handles
handles.vpx=vp(1);
handles.vpy=vp(2);

handles.vhx=vh(1);
handles.vhy=vh(2);

handles.vbx=vb(1);
handles.vby=vb(2);

handles.vfx=vf(1);
handles.vfy=vf(2);









