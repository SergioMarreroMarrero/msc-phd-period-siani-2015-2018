
%% Calculamos Puntos de Corte
[ xti,xtd,k4,r] = calculoextremos(a,b,B,H,R);
handles.xti=xti;
handles.xtd=xtd;

       
%% Circunferencia 
circulo=linspace(0,360,1000);
x_circunfe=R*cosd(circulo)+a;
y_circunfe=R*sind(circulo)+b;

%% Arco de circunferencia
dibujararco=~isnan(xtd);
if dibujararco==1
    teta_circ_der=asind((xtd-a)/R);
    teta_circ_izq=asind(-(xti-a)/R);% Se usa signo negativo porque se requiere el valor absoluto
    dominio_izq=(270-teta_circ_izq);
    dominio_der=(270+teta_circ_der);
    dominio_talud=linspace((dominio_izq),(dominio_der),1000);
    arco_talud_x=R*cosd(dominio_talud)+a;
    arco_talud_y=R*sind(dominio_talud)+b;
else
    arco_talud_x=R*cosd(circulo)+a;
    arco_talud_y=R*sind(circulo)+b;
end
%%  Rebanadas
try
 dibujarrebanadas=~isnan(xtd);
if isnan(rebanadas)==0
      [ x,x_medio,y_talud_med ,y_circ_med,alfa,pasovector,y_talud,y_circ ] = parametros( rebanadas,xti,xtd,B,H,a,b,R,r);
      
      
    for t=1:1:length(x)
        hold on
         lineas=['handles.linea' num2str(t) '= plot(reba,rebay)'];
        reba=[x(t) x(t)];
        rebay=[y_circ(t) y_talud(t)];
        eval(lineas);
%         plot(reba,rebay);
    end
    handles.numerorebanadas=t;
end
end
     



        


        