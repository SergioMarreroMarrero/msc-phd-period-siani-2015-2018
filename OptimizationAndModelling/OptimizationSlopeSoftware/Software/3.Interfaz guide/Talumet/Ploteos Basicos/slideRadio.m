if isnan(handles.B) && isnan(handles.H)
      msgbox('Faltan valores','Error');  
elseif isnan(handles.a) && isnan(handles.b)
      msgbox('Faltan valores','Error');  
else
    
 borradosparaploteos;
 
    handles.R=get(gcbo,'value');
    set(handles.Radio,'String',num2str(handles.R))
    a=handles.a;
    b=handles.b;
    R=handles.R;
    B=handles.B;
    H=handles.H;
    rebanadas=handles.rebanadas;
    
% DESlIZAMIENTO
dibujodeslizamiento
%% Plot Circunferencia
handles.Circunferencia=plot(x_circunfe,y_circunfe,'y','LineWidth',1);
%% Plot centro de circunferencia
handles.CentroCirc=plot(a,b,'*r','LineWidth',2);
%% Plot arco de circunferencia
handles.ArcoCircunf=plot(arco_talud_x,arco_talud_y,'r','LineWidth',2);   

axis equal
  
    
end