
% Generamos una grafica 3D para ver la distribución de los minimos
puntosa=linspace(a1,a2,pa+1);
puntosb=linspace(b1,b2,pb+1);
for i=1:length(puntosb)
    A3D(i,:)=puntosa;
end

for j=1:length(puntosa)
    B3D(:,j)=puntosb;
end

figure(2)
surfc(A3D,B3D,FS3D)
title('Funcion fitness ','FontName','Arial','FontSize', 14);
xlabel(' x','FontName','Arial','FontSize', 14);
ylabel(' y','FontName','Arial','FontSize', 14);
zlabel('f(x,y)','FontName','Arial','FontSize', 14);

figure(3)
contourf(A3D,B3D,FS3D)
colormap pink
title('Lineas de contorno de la funcion fitness ','FontName','Arial','FontSize', 14);
xlabel(' x','FontName','Arial','FontSize', 14);
ylabel(' y','FontName','Arial','FontSize', 14);

% figure(4)
% pcolor(A3D,B3D,FS3D)
% title('Distribución en color del FS  ','FontName','Arial','FontSize', 14);
% xlabel('Centro a(m)','FontName','Arial','FontSize', 14);
% ylabel('Centro b(m)','FontName','Arial','FontSize', 14);


