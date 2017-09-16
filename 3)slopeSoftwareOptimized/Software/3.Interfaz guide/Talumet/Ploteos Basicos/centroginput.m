if isnan(handles.B) && isnan(handles.H)
 msgbox('Debe introducir valores geometricos del talud','Error');  
else
[x,y]=ginput(1);

 borradosparaploteos;
 
handles.a=x;
handles.b=y;
set(handles.coordenadax,'String',num2str(handles.a));
set(handles.coordenaday,'String',num2str(handles.b));

a=handles.a;
b=handles.b;
R=handles.R;
H=handles.H;
B=handles.B;
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