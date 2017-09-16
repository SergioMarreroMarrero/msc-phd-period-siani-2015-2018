function [x_talud,y_talud]=dibujotalud(H,B)
x_talud=linspace(-50,50,1000);
y_talud = taludgeometria( B,x_talud,H);
end

