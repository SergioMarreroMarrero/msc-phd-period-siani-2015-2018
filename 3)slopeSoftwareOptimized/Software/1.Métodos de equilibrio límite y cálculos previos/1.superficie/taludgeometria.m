function    y_talud = taludgeometria( B,x,H )
%  Devuelve la superficie del talud 
% Inputs
% B (m):Base del talud 
% H (m):Altura del talud 
% x:Puntos del eje x sobre los que se quiere saber su ordenada en
% en el eje y 
% Outputs
% y_talud: Ordenada de los puntos x sobre la superficie del talud
m=H/B; % Se calcula pendiente de la recta inclinada
y1=m.*x;
y2=0; % El talud siempre arranca en y=0;x=0. 
y3=H;
y_talud=y2.*(x<=0)+y1.*((x>0)&(x<B))+y3.*(x>=B);
end

