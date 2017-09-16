box on
axis on
% set(gca,'YTickLabel',[],'XTickLabel',[])
%Iniciamos todos
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







% % Pop-up
% set(handles.Metodousado,'Value',1)
% 
% handles.Metodo='mFelle';
% handles.frasemetodo='Fellenius';
% guidata(hObject, handles);
% 
% 
% set(handles.tipodeanalisis,'Value',1)
% handles.Analisiselegido='Standard';
% handles.fraseanalisis='Standard';
% guidata(hObject, handles);
% 
% set(handles.simulaciones,'Value',1)
% handles.num=nan;


handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
