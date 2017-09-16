%    Propiedades del talud
H=handles.H;
B=handles.B;
C=handles.C;
fi=handles.fi;
gd=handles.gd;

LaAltura=num2str(H);
LaBase=num2str(B);
LaCohesion=num2str(C);
ElAnguloderozamientointerno=num2str(fi);
Elpesoescifico=num2str(gd);

frase2=['Característica del Talud\nAltura= ' LaAltura ' (m)\nBase= ' LaBase ' (m)\nCohesion= ' LaCohesion ' (kPa)\nFi = ' ElAnguloderozamientointerno ' (º)\nPeso Unitario= ' Elpesoescifico ' (kN/m³)\n'];
% handles.frasebox3=sprintf(frase3);    

s=sprintf(frase2);
handles.tal=s;
set(handles.rtalud,'String',s)
 
handles.output = hObject;
guidata(hObject, handles);