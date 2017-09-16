function [X ] = segundogrado( coeficientes )

A=coeficientes(1);
B=coeficientes(2);
C=coeficientes(3);

x1=(-B-(sqrt((B^2)-4*A*C)))/(2*A);
x2=(-B+(sqrt((B^2)-4*A*C)))/(2*A);
X=[x1 x2];
X=sort(X);
end

