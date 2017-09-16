% Desarrollamos el metodo sobre un punto
FSenPunto
% Guardamos el factor de seguridad
factordeseguridad=num2str(FS);
% Creamos el resultado a mostrar por pantalla
set(handles.rfactor,'String','')
pantalla=['Análisis: ' handles.fraseanalisis '\nMétodo: ' handles.frasemetodo '\nRebanadas= ' num2str(rebanadas) '\nFS=' factordeseguridad '\n'] ;
s=sprintf(pantalla);
handles.res=s;
set(handles.rfactor,'String',s)

