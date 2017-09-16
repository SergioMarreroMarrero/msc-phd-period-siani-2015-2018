figure(3)
 % TALUD
 hold on
H=handles.H;
B=handles.B;
try
   
    [x_talud,y_talud]=dibujotalud(H,B);
    handles.SuperficieTalud=plot(x_talud,y_talud,'k','LineWidth',3);
    axis equal
    hold on
catch
     errordlg('Faltan datos por introducir','ERROR');   
end

% Circunferencia y rebanadas

a=handles.a;
b=handles.b;
R=handles.R;
rebanadas=handles.rebanadas;

try
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

% Marco

vp=[handles.vpx handles.vpy];
vh=[handles.vhx handles.vhy];
vb=[handles.vbx handles.vby];
vf=[handles.vfx handles.vfy];

try 
% Lineas
handles.lynea1=line([vp(1) vh(1)],[vp(2) vh(2)]);
handles.lynea2=line([vh(1) vf(1)],[vh(2) vf(2)]);
handles.lynea3=line([vf(1) vb(1)],[vf(2) vb(2)]);
handles.lynea4=line([vb(1) vp(1)],[vb(2) vp(2)]);

% Puntos
handles.punto1=plot(vp(1),vp(2),'b*');
handles.punto2=plot(vh(1),vh(2),'b*');
handles.punto3=plot(vb(1),vb(2),'b*');
handles.punto4=plot(vf(1),vf(2),'b*');

end
try
% Box1
annotation('textbox',...
    [0.147291361639824 0.54275092936803 0.256808199121523 0.368773234200738],...
    'String',handles.res,...
    'FontSize',10,...
    'FontName','Arial',...
    'LineStyle','--',...
    'EdgeColor','b',...
    'LineWidth',2,...
    'BackgroundColor',[0.9  0.9 0.9],...
    'Color','b');
end

try
annotation('textbox',...
    [0.649487554904833 0.685873605947953 0.249487554904832 0.220074349442378],...
    'String',handles.tal,...
    'FontSize',10,...
    'FontName','Arial',...
    'LineStyle','--',...
    'EdgeColor','b',...
    'LineWidth',2,...
    'BackgroundColor',[0.9  0.9 0.9],...
    'Color','b');
end

try
annotation('textbox',...
    [0.4 0.5 0.249487554904832 0.3],...
    'String',handles.geo,...
    'FontSize',10,...
    'FontName','Arial',...
    'LineStyle','--',...
    'EdgeColor','b',...
    'LineWidth',2,...
    'BackgroundColor',[0.9  0.9 0.9],...
    'Color','b');
end

hold off


    handles.output = hObject;
    guidata(hObject, handles);