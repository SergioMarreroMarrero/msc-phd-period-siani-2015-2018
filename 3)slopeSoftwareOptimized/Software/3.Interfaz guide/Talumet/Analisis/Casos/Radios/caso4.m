% Desarrollamos el metodo sobre un punto
RadiosScriptcomparacion


% SIN
factordeseguridadsin=num2str(FSRMSO(1,1));
Rsin=num2str(FSRMSO(1,2));
% CON

factordeseguridadcon=num2str(FSRMCO(1,1));
Rcon=num2str(FSRMCO(1,2));

%% Escribimos en box 3
rt=['\n rt=' num2str(tfs/tfc)];

if tfc>=60
    tiempocon= [num2str(tfc/60) 'min'];
else
    tiempocon= [num2str(tfc) 'seg'];
end

if tfs>=60
    tiemposin= [num2str(tfs/60) 'min'];
else
    tiemposin= [num2str(tfs) 'seg'];
end

   
set(handles.rfactor,'String','')
pantalla1=['Análisis: ' handles.fraseanalisis '\nMétodo: ' handles.frasemetodo '\nRebanadas=' num2str(rebanadas)];
pantallasin=['\nSin optimización:\n FS=' factordeseguridadsin '; R=' Rsin '(m); t= ' tiemposin ];
pantallacon=['\nCon optimización:\n FS=' factordeseguridadcon '; R=' Rcon '(m); t= ' tiempocon ];

s=sprintf([pantalla1 pantallasin pantallacon rt]);
handles.res=s;
set(handles.rfactor,'String',s)