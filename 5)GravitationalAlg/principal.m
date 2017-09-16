clear all
clc
% Definicion del talud

Metodo='mFelle';
Met=['[ FS ] =' Metodo '( y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi );'];

a=0;
b=10;
R=4;
B=5;
H=10;
gd=20;
C=3;
fi=19.6;
rebanadas=30;
%% Se define nuestra variable
[ xti,xtd,k4,r] = calculoextremos(a,b,B,H,R);
[ masax ] = divisorderebanadas( xti,xtd,rebanadas,r,B);
y_talud = taludgeometria( B, masax([1 end]),H);
y_circ=real(-sqrt(R^2-(masax-a).^2)+b);
masay=[y_talud(1) y_circ(2:end-1)  y_talud(end)];

% masa=[];
% for j=1:length(masax)
%     masa=[masa masax(j) masay(j)];
% end
%% Bloque de mutacion fijando x inicial.




%% Definimos los limites factibles de cada variable
%% xleft,xright
m32=(masay(3)-masay(2))/(masax(3)-masax(2));
xmaxleft(1)=(masay(1)-masay(3)+m32*masax(3))/m32;

for j=2:length(masax)
    xmaxleft(j)=masax(j)-(masax(j)-masax(j-1))/2;
end

for j=1:length(masax)-1
    xmaxright(j)=masax(j)+(masax(j+1)-masax(j))/2;
end

mend=(masay(end-1)-masay(end-2))/(masax(end-1)-masax(end-2));
xmaxright(end+1)=(masay(end)-masay(end-2)+mend*masax(end-2))/mend;

%% %%%%%%%%%%%%%%%%%
%ydown,yup
% yup
yup(1)=masay(1);
for j=2:length(masax)-1
    myup(j)=(masay(j+1)-masay(j-1))/(masax(j+1)-masax(j-1));
    yup(j)=masay(j-1)+myup(j)*(masax(j)-masax(j-1));
end
yup(end+1)=masay(end);

% ydown
ydown(1)=masay(1);

mydownnodo2=(masay(4)-masay(3))/(masax(4)-masax(3));
ydown(2)=masay(3)+mydownnodo2*(masax(2)-masax(3));

for j=3:length(masax)-2
   mydown1(j)=(masay(j-2)-masay(j-1))/(masax(j-2)-masax(j-1));
   ydown1(j)=masay(j-1)+mydown1(j)*(masax(j)-masax(j-1));
   
   mydown2(j)=(masay(j+2)-masay(j+1))/(masax(j+2)-masax(j+1));
   ydown2(j)=masay(j+1)+mydown2(j)*(masax(j)-masax(j+1));
   
   ydown(j)=max([ydown1(j),ydown2(j)]);
end

mydownnodopenultimo=(masay(end-3)-masay(end-2))/(masax(end-3)-masax(end-2));
ydown(end+1)=masay(end-2)+mydownnodopenultimo*(masax(end-1)-masax(end-2));
ydown(end+1)=masay(end);

limites=[xmaxleft; xmaxright; yup; ydown];

%%%%%%%%%%%%%%%%%%%%%%
%% Acoplamiento con el programa. Tenemos x,y y limites
rebanadas=10;
[ x,x_medio,pasovector ] = divisorderebanadas( xti,xtd,rebanadas,r,B);
% Para superior de integracion. Superficie del Talud 
y_talud = taludgeometria( B,x,H);
y_talud_med = taludgeometria( B,x_medio,H);
%%Calculamos los puntos usando una funcion Spline
y_circ=interp1(masax,masay,x);
y_circ_med=interp1(masax,masay,x_medio);

%% Calculamos la pendiente
for j=1:length(y_circ)-1
    p(:,j)=polyfit(x(j:j+1),y_circ(j:j+1),1);
end
%
% Angulo de cada rebanada
alfa=real(atand(p(1,:)));
    
%%
[ FS] = mFelle( y_talud_med,y_circ_med,alfa ,pasovector,gd,C,fi );

%% Incorporamos el algoritmo gravitacional






 
% 





