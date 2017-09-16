function [ x,x_medio,y_talud_med ,y_circ_med,alfa,pasovector,y_talud,y_circ ] = parametros( rebanadas,xti,xtd,B,H,a,b,R,r)
% Esta función calcula valores asociados a las rebanadas
% Inputs
% rebanadas: Número de rebanadas
% xti,xtd: Puntos de corte entre la superficie de rotura y el talud
% B,H: Base y altura del talud
% a,b,R: Centro y radio de la circunferencia
% r: Vector que informa de las rectas sobre las que se encuentran los
% puntos de corte pti,ptd

% Outputs
% x,x_medio,pasovector: Outputs de la funcion divisorderebanadas
% y_talud_med: Ordenada del talud en los puntos del vector x_med
% y_circ_med: Ordenada de la circunferencia en los puntos del vector x_med
% alfa: Angulo respecto de la horizontal de la linea inferior de cada
% rebanada.
% y_talud: Ordenada del talud en los puntos del vector x
% y_circ: Ordenada de la circunferencia en los puntos del vector x
%
%
%

% Llamamos al divisor de rebanadas   
[ x,x_medio,pasovector ] = divisorderebanadas( xti,xtd,rebanadas,r,B);   

% Talud 
y_talud = taludgeometria( B,x,H);
y_talud_med = taludgeometria( B,x_medio,H);


% Calculo de ordenada de los puntos M
y_circ=real(-sqrt(R^2-(x-a).^2)+b);
% y_circ=(round(y_circ*precisiondecimal)/precisiondecimal);


y_circ_sinpri=y_circ;y_circ_sinpri(1)=[];
y_circ_sinfin=y_circ;y_circ_sinfin(end)=[];
x_sinpri=x;x_sinpri(1)=[];x_sinfin=x;x_sinfin(end)=[];

% Altura rebanadas punto medio
y_circ_med=(y_circ_sinpri+y_circ_sinfin)./2;
% y_circ_med=(round(y_circ_med*masprecision)/masprecision);


% Angulo de cada rebanada
pendiente=(y_circ_sinpri-y_circ_sinfin)./(x_sinpri-x_sinfin);
alfa=real(atand(pendiente));
% alfa=(round(alfa*precisiondecimal)/precisiondecimal);


 end

