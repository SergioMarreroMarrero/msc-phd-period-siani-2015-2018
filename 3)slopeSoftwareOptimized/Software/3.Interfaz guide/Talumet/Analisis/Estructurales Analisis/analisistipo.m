
Analisiselegido=get(hObject,'Value');
switch Analisiselegido   
    case 1 
%         Sobre un punto
        
    handles.Analisiselegido=1;
    handles.fraseanalisis='Sobre un punto';
    

    case 2
%         Radios sin optimizar
  
    handles.Analisiselegido=2;
    handles.fraseanalisis='Radios.Sin optimizar';

    
    case 3
%         Radios optimizando

    handles.Analisiselegido=3;
    handles.fraseanalisis='Radios.Optimizando';

        
    case 4
%         Radios Comparacion
        
    handles.Analisiselegido=4;
    handles.fraseanalisis='Radios.Comparacion';

    case 5   
%         Marco sin optimizar

    handles.Analisiselegido=5;
    handles.fraseanalisis='Marco.Sin optimizar';

    case 6 
%         Marco optimizando
    handles.Analisiselegido=6;
    handles.fraseanalisis='Marco.Optimizando';
        
    case 7
%         Marco comparacion
    handles.Analisiselegido=7;
    handles.fraseanalisis='Marco.Comparación';
        
    case 8
%         Busqueda automatica
    handles.Analisiselegido=7;
    handles.fraseanalisis='Búsqueda optimizada automática';
end










