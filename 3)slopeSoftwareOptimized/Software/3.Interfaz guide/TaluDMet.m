function varargout = TaluDMet(varargin)
% TALUDMET MATLAB code for TaluDMet.fig
%      TALUDMET, by itself, creates coordenadax new TALUDMET or raises the existing
%      singleton*.
%
%      Altura = TALUDMET returns the handle to coordenadax new TALUDMET or the handle to
%      the existing singleton*.
%
%      TALUDMET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TALUDMET.M with the given input arguments.
%
%      TALUDMET('Property','Value',...) creates coordenadax new TALUDMET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TaluDMet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TaluDMet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TaluDMet

% Last Modified by GUIDE v2.5 21-Jul-2015 12:58:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TaluDMet_OpeningFcn, ...
                   'gui_OutputFcn',  @TaluDMet_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TaluDMet is made visible.
function TaluDMet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TaluDMet (see VARARGIN)
inicio
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TaluDMet wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TaluDMet_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in dibujar.
function dibujar_Callback(hObject, eventdata, handles)
% hObject    handle to dibujar (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Cambio de valores
% Borrados
try
delete(handles.SuperficieTalud)
end
borradosparaploteos;
borrarelmarco


H=handles.H;
B=handles.B;


try
    axes(handles.axes1);
    % TALUD
    [x_talud,y_talud]=dibujotalud(H,B);
    handles.SuperficieTalud=plot(x_talud,y_talud,'k','LineWidth',3);
    axis equal
    hold on
catch
     errordlg('Faltan datos por introducir','ERROR');   
end

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


vp=[handles.vpx handles.vpy];
vf=[handles.vfx handles.vfy];
vh=[handles.vpx handles.vfy];
vb=[handles.vfx handles.vpy];


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

    handles.output = hObject;
    guidata(hObject, handles);

     

% --- Executes on button press in limpiar.
function limpiar_Callback(hObject, eventdata, handles)
% hObject    handle to limpiar (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla;
% set(gca,'YTickLabel',[],'XTickLabel',[])
% legend('off')

set(handles.rgeometricos,'String','')
set(handles.rtalud,'String','')

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in RESET.
function RESET_Callback(hObject, eventdata, handles)
% hObject    handle to RESET (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reseteo
handles.output = hObject;
guidata(hObject, handles);

function coordenadax_Callback(hObject, eventdata, handles)
% hObject    handle to coordenadax (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of coordenadax as text
%        str2double(get(hObject,'String')) returns contents of coordenadax as coordenadax double
handles.a=str2double(get(hObject,'String'));
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function coordenadax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coordenadax (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have coordenadax white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function coordenaday_Callback(hObject, eventdata, handles)
% hObject    handle to coordenaday (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of coordenaday as text
%        str2double(get(hObject,'String')) returns contents of coordenaday as coordenadax double
handles.b=str2double(get(hObject,'String'));
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function coordenaday_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coordenaday (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have coordenadax white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Radio_Callback(hObject, eventdata, handles)
% hObject    handle to Radio (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Radio as text
%        str2double(get(hObject,'String')) returns contents of Radio as coordenadax double
handles.R=str2double(get(hObject,'String'));
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Radio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radio (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have coordenadax white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Base_Callback(hObject, eventdata, handles)
% hObject    handle to COORDENADAY (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of COORDENADAY as text
%        str2double(get(hObject,'String')) returns contents of COORDENADAY as coordenadax double

handles.B=str2double(get(hObject,'String'));
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function Base_CreateFcn(hObject, eventdata, handles)
% hObject    handle to COORDENADAY (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have coordenadax white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Altura_Callback(hObject, eventdata, handles)
% hObject    handle to Altura (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Altura as text
%        str2double(get(hObject,'String')) returns contents of Altura as coordenadax double

handles.H=str2double(get(hObject,'String'));
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function Altura_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Altura (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have coordenadax white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angulorozamiento_Callback(hObject, eventdata, handles)
% hObject    handle to angulorozamiento (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angulorozamiento as text
%        str2double(get(hObject,'String')) returns contents of angulorozamiento as coordenadax double
handles.fi=str2double(get(hObject,'String'));
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function angulorozamiento_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angulorozamiento (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have coordenadax white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Especifico_Callback(hObject, eventdata, handles)
% hObject    handle to Especifico (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Especifico as text
%        str2double(get(hObject,'String')) returns contents of Especifico as coordenadax double

handles.gd=str2double(get(hObject,'String'));
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function Especifico_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Especifico (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have coordenadax white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Cohesion_Callback(hObject, eventdata, handles)
% hObject    handle to Cohesion (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cohesion as text
%        str2double(get(hObject,'String')) returns contents of Cohesion as coordenadax double
handles.C=str2double(get(hObject,'String'));
% Choose default command line output for TaluDMet
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Cohesion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cohesion (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have coordenadax white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

slideRadio;
handles.output = hObject;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have coordenadax light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in centromanual.
function centromanual_Callback(hObject, eventdata, handles)
% hObject    handle to centromanual (see GCBO)
% eventdata  reserved - to be defined in coordenadax future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
centroginput
%% Plot centro de circunferencia
 handles.output = hObject;
 guidata(hObject, handles);


% --- Executes on button press in geometria.
function geometria_Callback(hObject, eventdata, handles)
% hObject    handle to geometria (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

geometricos;


% --- Executes on button press in Talud.
function Talud_Callback(hObject, eventdata, handles)
% hObject    handle to Talud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
propiedadestalud

% --- Executes on button press in Factor.
function Factor_Callback(hObject, eventdata, handles)
% hObject    handle to Factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rejas.
function rejas_Callback(hObject, eventdata, handles)
% hObject    handle to rejas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rejas
if (get(hObject,'Value') == get(hObject,'Max'))
	axes(handles.axes1);
    grid on
else
	axes(handles.axes1);
    grid off
end

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in analizar.
function analizar_Callback(hObject, eventdata, handles)
% hObject    handle to analizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

flujo

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on selection change in tipodeanalisis.
function tipodeanalisis_Callback(hObject, eventdata, handles)
% hObject    handle to tipodeanalisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tipodeanalisis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tipodeanalisis

analisistipo

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tipodeanalisis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tipodeanalisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function puntospormetro_Callback(hObject, eventdata, handles)
% hObject    handle to puntospormetro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of puntospormetro as text
%        str2double(get(hObject,'String')) returns contents of puntospormetro as a double
precision=str2double(get(hObject,'String'));
handles.ppm1=round(1/precision);
handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function puntospormetro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puntospormetro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in marco.
function marco_Callback(hObject, eventdata, handles)
% hObject    handle to marco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dibujarelmarco

handles.output = hObject;
guidata(hObject, handles);



% --- Executes on selection change in metodousado.
function metodousado_Callback(hObject, eventdata, handles)
% hObject    handle to metodousado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns metodousado contents as cell array
%        contents{get(hObject,'Value')} returns selected item from metodousado

metodousar
handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function metodousado_CreateFcn(hObject, eventdata, handles)
% hObject    handle to metodousado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reb_Callback(hObject, eventdata, handles)
% hObject    handle to reb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reb as text
%        str2double(get(hObject,'String')) returns contents of reb as a double

handles.rebanadas=str2double(get(hObject,'String'));
handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function reb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cargardatos;
 
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in LIMPIARPANTALLA.
function LIMPIARPANTALLA_Callback(hObject, eventdata, handles)
% hObject    handle to LIMPIARPANTALLA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
set(gca,'YTickLabel',[],'XTickLabel',[])
legend('off')



function limiteFS_Callback(hObject, eventdata, handles)
% hObject    handle to limiteFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of limiteFS as text
%        str2double(get(hObject,'String')) returns contents of limiteFS as a double

handles.limFS=str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function limiteFS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limiteFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PuntosR_Callback(hObject, eventdata, handles)
% hObject    handle to PuntosR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PuntosR as text
%        str2double(get(hObject,'String')) returns contents of PuntosR as a double
handles.PTR=str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function PuntosR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PuntosR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pbasex_Callback(hObject, eventdata, handles)
% hObject    handle to pbasex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pbasex as text
%        str2double(get(hObject,'String')) returns contents of pbasex as a double

handles.vbx=str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pbasex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pbasex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function palturax_Callback(hObject, eventdata, handles)
% hObject    handle to palturax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of palturax as text
%        str2double(get(hObject,'String')) returns contents of palturax as a double

handles.vhx=str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function palturax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to palturax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pinicialx_Callback(hObject, eventdata, handles)
% hObject    handle to pinicialx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pinicialx as text
%        str2double(get(hObject,'String')) returns contents of pinicialx as a double
handles.vpx=str2double(get(hObject,'String'));
% handles.vhx=handles.vpx;

% set(handles.palturax,'String',num2str(handles.vpx))


handles.output = hObject;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function pinicialx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pinicialx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pfinalx_Callback(hObject, eventdata, handles)
% hObject    handle to pfinalx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pfinalx as text
%        str2double(get(hObject,'String')) returns contents of pfinalx as a double

handles.vfx=str2double(get(hObject,'String'));

% handles.vbx=handles.vfx;
% set(handles.pbasex,'String',num2str(handles.vbx))



handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pfinalx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pfinalx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in borramarco.
function borramarco_Callback(hObject, eventdata, handles)
% hObject    handle to borramarco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
limpio='';
set(handles.pinicialx,'String',limpio)
set(handles.pinicialy,'String',limpio)

% set(handles.palturax,'String',limpio)
% set(handles.palturay,'String',limpio)

% set(handles.pbasex,'String',limpio)
% set(handles.pbasey,'String',limpio)

set(handles.pfinalx,'String',limpio)
set(handles.pfinaly,'String',limpio)

handles.vpx=nan;
handles.vpy=nan;

handles.vhx=nan;
handles.vhy=nan;

handles.vbx=nan;
handles.vby=nan;

handles.vfx=nan;
handles.vfy=nan;




borrarelmarco

handles.output = hObject;
guidata(hObject, handles);



function pinicialy_Callback(hObject, eventdata, handles)
% hObject    handle to pinicialy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pinicialy as text
%        str2double(get(hObject,'String')) returns contents of pinicialy as a double
vpy=str2double(get(hObject,'String'));

handles.vpy=vpy;
% handles.vby=vpy;
% set(handles.pbasey,'String',num2str(vpy));
handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pinicialy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pinicialy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function palturay_Callback(hObject, eventdata, handles)
% hObject    handle to palturay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of palturay as text
%        str2double(get(hObject,'String')) returns contents of palturay as a double
handles.vhy=str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function palturay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to palturay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pbasey_Callback(hObject, eventdata, handles)
% hObject    handle to pbasey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pbasey as text
%        str2double(get(hObject,'String')) returns contents of pbasey as a double

handles.vby=str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function pbasey_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pbasey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pfinaly_Callback(hObject, eventdata, handles)
% hObject    handle to pfinaly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pfinaly as text
%        str2double(get(hObject,'String')) returns contents of pfinaly as a double
vfy=str2double(get(hObject,'String'));
handles.vfy=vfy;
% handles.vhy=handles.vfy;
% set(handles.palturay,'String',num2str(vfy))


handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pfinaly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pfinaly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function puntospormetro2_Callback(hObject, eventdata, handles)
% hObject    handle to puntospormetro2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of puntospormetro2 as text
%        str2double(get(hObject,'String')) returns contents of puntospormetro2 as a double

handles.ppm2=str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function puntospormetro2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puntospormetro2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function entorno_Callback(hObject, eventdata, handles)
% hObject    handle to entorno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of entorno as text
%        str2double(get(hObject,'String')) returns contents of entorno as a double
handles.ampl=str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function entorno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to entorno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guardardatos


% --- Executes on button press in marcopt.
function marcopt_Callback(hObject, eventdata, handles)
% hObject    handle to marcopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ca,cb] = ginput(1);
handles.ca=ca;
handles.cb=cb;
l1=handles.ampl;
% Punto inicial
vp=[ca cb]-l1/2;
vp=round(vp*1000)/1000;
% Punto final
vf=[ca cb]+l1/2;
vf=round(vf*1000)/1000;
% Vertice de altura. Altura
vh=[vp(1) vf(2)];
% Vertice de longitud. Base
vb=[vf(1) vp(2)];
axes(handles.axes1)

verticesx=sort([vp(1) vf(1)]);
verticesy=sort([vp(2) vf(2)]);
a1=verticesx(1);a2=verticesx(2);
b1=verticesy(1);b2=verticesy(2);

handles.rectangulo31 =plot([a1,a2,a2,a1,a1],[b1,b1,b2,b2,b1]);

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in marcoborro.
function marcoborro_Callback(hObject, eventdata, handles)
% hObject    handle to marcoborro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    delete(handles.rectangulo31);
   
end
