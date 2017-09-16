[FILENAME, PATHNAME] = uigetfile;
load([PATHNAME FILENAME]);

set(handles.Base,'String',num2str(B))
set(handles.Altura,'String',num2str(H))

set(handles.Cohesion,'String',num2str(C))
set(handles.Especifico,'String',num2str(gd))
set(handles.angulorozamiento,'String',num2str(angulorozamiento))



handles.H=H;
handles.B=B;
handles.C=C;
handles.fi=angulorozamiento;
handles.gd=gd;

try
handles.rebanadas=rebanadas;
set(handles.reb,'String',num2str(rebanadas))
end

try
set(handles.coordenadax,'String',num2str(a))
set(handles.coordenaday,'String',num2str(b))
set(handles.Radio,'String',num2str(R))

handles.a=a;
handles.b=b;
handles.R=R;
end   