
a=handles.a;
b=handles.b;
R=handles.R;
xti=handles.xti;
xtd=handles.xtd;

%   Circunferencia
centrox=num2str(a);
centroy=num2str(b);
elradio=num2str(R);
    
%   Extremos    
extremoizq=num2str(xti);
extremodere=num2str(xtd);
    
frase1=['Circunferencia\nX= ' centrox ' (m)\nY= ' centroy ' (m)\nR= ' elradio ' (m)\nExtremos\nExtI= ' extremoizq ' (m)\nExtD= ' extremodere ' (m)\n'];
% handles.frasebox2=sprintf(frase2);   

s=sprintf(frase1);
handles.geo=s;
set(handles.rgeometricos,'String',s)

 
handles.output = hObject;
guidata(hObject, handles);




