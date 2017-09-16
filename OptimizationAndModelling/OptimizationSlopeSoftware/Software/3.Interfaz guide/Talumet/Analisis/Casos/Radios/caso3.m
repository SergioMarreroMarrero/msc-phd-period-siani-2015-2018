% Desarrollamos el metodo sobre un punto
RadiosScriptConOpt

factordeseguridad=num2str(FSRMCO(1,1));
R=FSRMCO(1,2);

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