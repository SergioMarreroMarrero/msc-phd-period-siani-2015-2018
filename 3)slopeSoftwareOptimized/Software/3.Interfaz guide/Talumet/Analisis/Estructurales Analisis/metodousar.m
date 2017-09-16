metodoelegido=get(hObject,'Value');
switch metodoelegido
case 1
handles.Metodo='mFelle';
handles.frasemetodo='Fellenius';
case 2
handles.Metodo='mBishop';
handles.frasemetodo='Bishop simplificado';
guidata(hObject, handles);
case 3
handles.Metodo='mMorgPri';
handles.frasemetodo='Morgenstern-Price';
guidata(hObject, handles);
case 4
handles.Metodo='Todos';
guidata(hObject, handles);
end


