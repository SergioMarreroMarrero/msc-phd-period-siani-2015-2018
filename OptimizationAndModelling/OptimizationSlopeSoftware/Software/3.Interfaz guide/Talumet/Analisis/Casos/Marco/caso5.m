% Traemos los vértices y los transformamos en límites
verticesx=sort([vp(1) vf(1)]);
verticesy=sort([vp(2) vf(2)]);
a1=verticesx(1);a2=verticesx(2);
b1=verticesy(1);b2=verticesy(2);
pantalla3=['\nVértices del marco\nv1= (' num2str(vp(1)) ',' num2str(vp(2)) ');\nv2= (' num2str(vf(1)) ',' num2str(vf(2)) ')'];


% Calculamos los puntos inidicados
ppm=handles.ppm1;
dx=a2-a1;
dy=b2-b1;
pa=round(dx*ppm);
pb=round(dy*ppm);


%%
% Desarrollamos el metodo Rastreo
elegirmetodo;
ti=tic;
[FSRabmin,FSRmab,FS3D,i,j] = Rastreo(a1,a2,b1,b2,pa,pb,C,PT,gd,fi,B,H,rebanadas,Met,Metodo );
tf=toc(ti);
%%

%% Texto y figuras
factordeseguridad=num2str(FSRabmin(1,1));
Rmin=num2str(FSRabmin(1,2));
amin=num2str(FSRabmin(1,3));
bmin=num2str(FSRabmin(1,4));

%% Mandamos el Radio y el centro mínimo a marcadores y al box1
set(handles.Radio,'String',Rmin);
handles.R=FSRabmin(1,2);
set(handles.coordenadax,'String',amin);
handles.a=FSRabmin(1,3);
set(handles.coordenaday,'String',bmin);
handles.b=FSRabmin(1,4);



%% Escribimos en box 3
if tf>=60
    tiempo= [num2str(tf/60) 'min'];
else
    tiempo= [num2str(tf) 'seg'];
end
    
set(handles.rfactor,'String','')
pantalla1=['Análisis: ' handles.fraseanalisis '\nMétodo: ' handles.frasemetodo '\nRebanadas=' num2str(rebanadas)];
pantalla2= ['\nFSminimo=' factordeseguridad '\nRmin=' Rmin '\namin=' amin '\nbmin=' bmin '\ntiempo=' tiempo ] ;
s=sprintf([pantalla1 pantalla2 pantalla3] );
handles.res=s;
set(handles.rfactor,'String',s)

% Ploteamos gráfica en 3d
graficos3d
