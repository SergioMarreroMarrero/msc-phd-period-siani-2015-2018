 

vp=round(vp*1000)/1000;
% Punto final

vf=round(vf*1000)/1000;
% Vertice de altura. Altura
vh=[vp(1) vf(2)];
% Vertice de longitud. Base
vb=[vf(1) vp(2)];

verticesx=sort([vp(1) vf(1)]);
verticesy=sort([vp(2) vf(2)]);
a1=verticesx(1);a2=verticesx(2);
b1=verticesy(1);b2=verticesy(2);


% axes(handles.axes1)









