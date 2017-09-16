function [ FS,xti,xtd,k4,lambda] = FSP( a,b,R,C,gd,fi,B,H,rebanadas,Met,Metodo) %#ok<INUSL>
% Esta función permite calcular el FS en un punto.
% Inputs
% a,b,R: Centro y radio de la circunferencia
% C,gd,fi: Cohesión, Peso específico y angulo de rozamiento del terreno
% B,H: Base y altura del terreno
% rebanadas: Numero de rebanadas
% Met,Metodo: Cadenas de caracteres que informa del método elegido
% Outputs
% FS: Factor de seguridad por el metodo que aparezca en la variable Met
% xti,xtd: Abscisas de los puntos de corte de la circunferencia con el
% talud.
% k4: Variable que informa si la superficie de deslizamiento es valida o
% no.
% lambda: Factor de corrección calculado en la funcion ZhuLeeChen.
[ xti,xtd,k4,r] = calculoextremos(a,b,B,H,R);
    if  k4==0 % No hay superficie de deslizamiento válida
        FS=nan;
        lambda=nan;
    else 
      [ x,x_medio,y_talud_med ,y_circ_med,alfa,...
      pasovector,y_talud,y_circ ] = parametros( rebanadas,... 
      xti,xtd,B,H,a,b,R,r); %#ok<*ASGLU,*NASGU>
          switch Metodo
              case 'mMorgPri'
                   eval(Met);
              case {'mFelle','mBishop'}
                   eval(Met);lambda=nan;        
          end
    end
 end



