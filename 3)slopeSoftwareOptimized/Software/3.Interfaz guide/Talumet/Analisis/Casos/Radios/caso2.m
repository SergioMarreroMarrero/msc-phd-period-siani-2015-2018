% Desarrollamos el metodo sobre un punto

RadiosScriptSinOpt

% Guardamos el factor de seguridad
%;
% % Creamos el resultado a mostrar por pantalla
% pantalla=['Tipo de Análisis\n' handles.fraseanalisis '\nMétodo\n' handles.frasemetodo '\nrebanadas=' num2str(rebanadas) '\nFS=' factordeseguridad '\n'] ;
% s=sprintf(pantalla);
% set(handles.rfactor,'String',s)
factordeseguridad=num2str(FSRMSO(1,1));
R=FSRMSO(1,2);

%% Mandamos el Radio mínimo a Radio y al box1
set(handles.Radio,'String',num2str(R));
handles.R=R;
%% Escribimos en box 3
if tf>=60
    tiempo= [num2str(tf/60) 'min'];
else
    tiempo= [num2str(tf) 'seg'];
end
    
set(handles.rfactor,'String','')
pantalla=['Análisis: ' handles.fraseanalisis '\nMétodo: ' handles.frasemetodo '\nRebanadas=' num2str(rebanadas) '\nFSminimo=' factordeseguridad '\ntiempo=' tiempo ] ;
s=sprintf(pantalla);
handles.res=s;
set(handles.rfactor,'String',s)

