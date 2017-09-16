cla % limpiamos pantalla
box on
axis on
% set(gca,'YTickLabel',[],'XTickLabel',[])
% legend('off')
% Reiniciamos las variables visibles
limpio='';

set(handles.coordenadax,'String',limpio)
set(handles.coordenaday,'String',limpio)
set(handles.Radio,'String',limpio)
set(handles.Base,'String',limpio)
set(handles.Altura,'String',limpio)
set(handles.Cohesion,'String',limpio)
set(handles.Especifico,'String',limpio)
set(handles.angulorozamiento,'String',limpio)
set(handles.reb,'String',limpio)
set(handles.rgeometricos,'String',limpio)
set(handles.rtalud,'String',limpio)
set(handles.rfactor,'String',limpio)
set(handles.limiteFS,'String',limpio)
set(handles.PuntosR,'String',limpio)

set(handles.entorno,'String',limpio)
set(handles.puntospormetro,'String',limpio)
set(handles.puntospormetro2,'String',limpio)
set(handles.limiteFS,'String',limpio)
set(handles.PuntosR,'String',limpio)

set(handles.pinicialx,'String',limpio)
set(handles.pinicialy,'String',limpio)


set(handles.pfinalx,'String',limpio)
set(handles.pfinaly,'String',limpio)

% Reiniciamos las variables internas
handles.a=nan;
handles.b=nan;
handles.R=nan;
handles.H=nan;
handles.B=nan;
handles.C=nan;
handles.gd=nan;
handles.fi=nan;
handles.rebanadas=nan;

handles.s=nan;
handles.limFS=nan;
handles.PTR=5;

handles.ppm1=nan;
handles.ppm2=nan;
handles.ampl=nan;

handles.vpx=nan;
handles.vpy=nan;

handles.vhx=nan;
handles.vhy=nan;

handles.vbx=nan;
handles.vby=nan;

handles.vfx=nan;
handles.vfy=nan;



% handles.s=nan;

% Activamos los pulsadores por si acaso
%    desbloquearpantalla
% Reiniciamos los pop-up

% set(handles.Metodousado,'Value',1)
% handles.Metodo='mFelle';
% handles.frasemetodo='Fellenius';
% guidata(hObject, handles);


% set(handles.tipodeanalisis,'Value',1)
% handles.Analisiselegido='Standard';
% handles.fraseanalisis='Standard';
% guidata(hObject, handles);

% set(handles.simulaciones,'Value',1)
% handles.num='nan';

