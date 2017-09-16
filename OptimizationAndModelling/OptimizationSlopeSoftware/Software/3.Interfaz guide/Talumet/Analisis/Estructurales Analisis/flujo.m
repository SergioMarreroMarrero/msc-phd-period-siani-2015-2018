% Traemos el metodo que vamos a usar
Metodo=handles.Metodo;
Analisiselegido=handles.Analisiselegido;
% Traemos todas las variables necesarias
a=handles.a;
b=handles.b;
R=handles.R;
H=handles.H;
B=handles.B;
C=handles.C;
gd=handles.gd;
fi=handles.fi;
rebanadas=handles.rebanadas;
FSmax=handles.limFS;
PT=handles.PTR;
vp=[handles.vpx handles.vpy];
vh=[handles.vhx handles.vhy];
vb=[handles.vbx handles.vby];
vf=[handles.vfx handles.vfy];
      
  

% Comenzamos
if ~strcmp(Metodo,'Todos')
    switch  Analisiselegido
        
        case 1
            if isnan(a) || isnan(b) || isnan(R) || isnan(H) || isnan(B) || isnan(C) || isnan(gd) || isnan(fi) || isnan(rebanadas)  
                errordlg('Faltan datos por introducir','ERROR');
            else
                caso1
                msgbox('Se ha terminado con éxito. Pulse Ok para continuar','TaludMet')
            end

        case 2
            if isnan(a) || isnan(b) || isnan(H) || isnan(B) || isnan(C) || isnan(gd) || isnan(fi) || isnan(rebanadas)  
                errordlg('Faltan datos por introducir','ERROR');
            else
                caso2
                msgbox('Se ha terminado con éxito. Pulse Ok para continuar','TaludMet')
            end
        case 3
        if isnan(a) || isnan(b) || isnan(H) || isnan(B) || isnan(C) || isnan(gd) || isnan(fi) || isnan(rebanadas)  
            errordlg('Faltan datos por introducir','ERROR');
        else
            caso3
            msgbox('Se ha terminado con éxito. Pulse Ok para continuar','TaludMet')
        end
        
        case 4
        if isnan(a) || isnan(b) || isnan(H) || isnan(B) || isnan(C) || isnan(gd) || isnan(fi) || isnan(rebanadas)  
            errordlg('Faltan datos por introducir','ERROR');
        else
            caso4
            msgbox('Se ha terminado con éxito. Pulse Ok para continuar','TaludMet')
        end
        
        case 5
        if  isnan(H) || isnan(B) || isnan(C) || isnan(gd) || isnan(fi) || isnan(rebanadas) || isnan(vp(1)) || isnan(vp(2))|| isnan(vf(1)) || isnan(vf(2)) || isnan(handles.ppm1)  
            errordlg('Faltan datos por introducir','ERROR');
        else
            caso5
            msgbox('Se ha terminado con éxito. Pulse Ok para continuar','TaludMet')
        end
        
        case 6
        if  isnan(H) || isnan(B) || isnan(C) || isnan(gd) || isnan(fi) || isnan(rebanadas) || isnan(handles.ppm2) || isnan(handles.ampl)
            errordlg('Faltan datos por introducir','ERROR');
        else
            caso6
            msgbox('Se ha terminado con éxito. Pulse Ok para continuar','TaludMet')
        end

    end    
end
    
            
       

            
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
   

           

             

       


