clear all;
close all;
clc;
th0=0;
[path, obs,nScans,nPath,rangerDataOut] = ExtractPathScans('securityupVFH.log', th0);

%% Modulo de imagenes
figure(1)
%Velocidad
subplot(2,1,1)
v=sqrt(path.vx.^2+path.vy.^2);
plot(v)
%     axis ([ 0  length(v) 0 max(v)+0.3*max(v)]);
axis ([ 0  250 0 max(v)+0.3*max(v)]);
title('Velocidad translacional')
xlabel('t(medidas tomadas)')
ylabel('m/s')
%Aceleracion
subplot(2,1,2)
a=diff(v);
plot(a)
%     axis ([ 0  length(path.vx) 0 max(a)+0.3 ]);
axis ([ 0  250 0 max(a)+0.3 ]);
title('Aceleracion translacional')
xlabel('t(medidas tomadas)')
ylabel('m/s^2')
figure(2)
%Theta/S
subplot(2,1,1)
plot(path.th)
%     axis ([ 0  length(path.th) 0 max(path.th)*1.3 ]);
axis ([ 0  250 0 max(path.th)*1.3 ]);
title('Velocidad angular')
xlabel('t(medidas tomadas)')
ylabel('deg/s')

%Aceleracion angular
subplot(2,1,2)
ath=diff(path.th);
plot(ath)
%     axis ([ 0  length(path.vx) 0 max(ath)*1.3 ]);
axis ([ 0  250 0 max(ath)*1.3 ]);
title('Aceleración angular')
xlabel('t(medidas tomadas)')
ylabel('deg/s^2')

% Puntos mas cercanos
figure(3)
%  [rangerRow,rangerColumn]=size(rangerDataOut);
mindist=min(rangerDataOut);
plot(mindist,'r')
%     axis ([ 0  length(mindist) 0 max(mindist)*1.3 ]);
axis ([ 0  250 0 max(mindist)*1.3 ]);
title('Distancia mínima a objeto')
xlabel('t(medidas tomadas)')
ylabel('m')







%% Modulo de video


[rangerRow,rangerColumn]=size(rangerDataOut);
v=sqrt(path.vx.^2+path.vy.^2);
a=diff(v);ath=diff(path.th);
maxv=max(v);maxth=max(path.th);
maxa=max(a);maxath=max(ath);
clear v a ath

for j=1:1:rangerColumn
    
    figure(4)
    %Velocidad
    subplot(2,2,1)
    v(j)=sqrt((path.vx(j))^2+(path.vy(j))^2);
    plot(v)
    axis ([ 0  length(path.vx) 0 maxv*1.3 ]);
    title('Velocidad translacional')
    xlabel('t(medidas tomadas)')
    ylabel('m/s')
    %Aceleracion
    %     a(1)=0;
    subplot(2,2,3)
    a=diff(v);
    plot(a)
    axis ([ 0  length(path.vx) 0 maxa*1.3 ]);
    title('Aceleracion translacional')
    xlabel('t(medidas tomadas)')
    ylabel('m/s^2')
    
    %Theta
    subplot(2,2,2)
    th(j)=path.th(j);
    plot(th)
    axis ([ 0  length(path.vx) 0 maxth*1.3 ]);
    title('Velocidad angular')
    xlabel('t(medidas tomadas)')
    ylabel('deg/s')
    
    %Aceleracion angular
    subplot(2,2,4)
    ath=diff(th);
    plot(ath)
    axis ([ 0  length(path.vx) 0 maxth*1.3 ]);
    title('Aceleración angular')
    xlabel('t(medidas tomadas)')
    ylabel('deg/s^2')
    
    
    figure(5)
    t=0:pi/360:pi;
    x=rangerDataOut(:,j)'.*cos(t);
    y=rangerDataOut(:,j)'.*sin(t);
    hold off
    %      subplot(3,1,3)
    plot(0,0,'r*')
    hold on
    %      subplot(3,1,3)
    plot(x,y,'*')
    axis ([ -6  6 0 max(y) ])
    
    threshold=0.5;
    % Los puntos mas cercarnos
    nearer=find(rangerDataOut(:,j)<threshold);
    ceros=zeros(length(nearer),1);
    xpoints=[ceros x(nearer)'];
    ypoints=[ceros y(nearer)'];
    line(xpoints',ypoints','Color','r');
    
    % Los puntos mas lejanos
    farer=find(rangerDataOut(:,j)>threshold);
    ceros=zeros(length(farer),1);
    xpoints=[ceros x(farer)'];
    ypoints=[ceros y(farer)'];
    line(xpoints',ypoints','Color','y');
    
    pause(0.01);
end