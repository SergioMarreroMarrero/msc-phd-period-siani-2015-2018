clear 
clc
%% Definicion de variables del algoritmo de busqueda gravitacional
epsilon=0.001; 
h=0.1;
alpha=0.01;
poblacionfinal=1;
Ninicial=50;
N=Ninicial;
dimension=3; % Espacio 
Go=100;betagravedad=20;
tmax=100;

% Datos del talud
B=5;
H=10;
gd=21;
C=25;
fi=15;
rebanadas=50;
Metodo='mFelle';
Met=['[ FS ] =' Metodo '( y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi );'];

%Espacio de busqueda y variables iniciales
amax=20;
amin=-20;
bmax=30;
bmin=5;
xx=(amax-amin)*rand(N,1)+amin;
yy=(bmax-bmin)*rand(N,1)+bmin;
rmax=zeros(1,N);rmin=zeros(1,N);R=zeros(N,1);
for i=1:N
    D=distminR1(B,H,xx(i),yy(i));
    rmax(i,1)=2*D;
    rmin(i,1)=1.2*D;
    R(i,1)=(rmax(i,1)-rmin(i,1))*rand(1,1)+rmin(i,1);
end
X=[xx yy R];
% Velocidades de las masas
velocidad=zeros(N,dimension);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:tmax
    %% 1) Actualizamos la constante gravitatoria
    G=Go*exp(-betagravedad*(t/tmax));
    %% 2) Sesgo de la poblacion
    Nold=N;
    N=round(Ninicial-((Ninicial-poblacionfinal)/(tmax-1))*(t-1));
    quitar=Nold-N;
    X(end-quitar+1:end,:)=[];     
    velocidad(end-quitar+1:end,:)=[]; 
    
     %% 3) Calculamos el fitness
    fit=zeros(N,1);
    for i=1:N
          [FS] = FSP( X(i,1),X(i,2),X(i,3),C,gd,fi,B,H,rebanadas,Met,Metodo); 
           FS(isnan(FS)==1)=10;
           fit(i,1)=FS;
    end
    
    %% 4)Best y Worst
     [best,b]=min(fit);
     [worst,w]=max(fit);   
     if best==worst
          display('best=worst')
         break       
     end   
    
    %% 5) Calculo de masa intercial
     m=zeros(N,1);
     m(1:N,1)=(fit(1:N)-worst)/(best-worst);
     masasproblematicas=find(m==0);  
     X(masasproblematicas(1:length(masasproblematicas)),:)=kron( X(b,:),ones(length(masasproblematicas),1));
     m(masasproblematicas(1:length(masasproblematicas)))= kron( m(b),ones(length(masasproblematicas),1));  
     Sumadem=sum(m);
     M=zeros(N,1);
     M=m(1:N)/Sumadem;
     
   %% 5) Calculo de fuerzas y aceleracion de cada particula
   F=zeros(N,dimension);
   aceleracion=zeros(N,dimension);
    for i=1:N  
        FF=zeros(1,dimension);
        for j=1:N
            a=~(i==j);
            FF=FF+(G*M(i,1)*M(j,1)/(norm(X(i,:)-X(j,:))+epsilon)).*(X(j,:)-X(i,:))*a.*rand(1,dimension);
        end
        F(i,:)=FF;
        % Aceleracion
        aceleracion(i,:)=F(i,:)./M(i); 
    end
    
     %% 6) Velocidad 
    rmax=zeros(N,1);rmin=rmax;vmaxo=zeros(N,dimension);
    velocidad=velocidad.*rand(N,dimension)+aceleracion ; 
    for i=1:N
        D=distminR1(B,H,X(i,1),X(i,2));
        rmax(i,1)=4*D;
        rmin(i,1)=1.2*D;          
        vmaxo(i,:)=alpha*[amax-amin, bmax-bmin,rmax(i,1)-rmin(i,1)];
    end
    % Limites de velocidad   
    vmax=zeros(N,dimension);
    vmax=(1-(t/tmax)^h).*vmaxo(1:N,:);
    velocidad(velocidad(1:N,1)>vmax(1:N,1),1)=vmax(velocidad(1:N,1)>vmax(1:N,1),1);
    velocidad(velocidad(1:N,2)>vmax(1:N,2),2)=vmax(velocidad(1:N,2)>vmax(1:N,2),2);
    velocidad(velocidad(1:N,3)>vmax(1:N,3),3)=vmax(velocidad(1:N,3)>vmax(1:N,3),3);

    velocidad(velocidad(1:N,1)<-vmax(1:N,1),1)=-vmax(velocidad(1:N,1)<-vmax(1:N,1),1);
    velocidad(velocidad(1:N,2)<-vmax(1:N,2),2)=-vmax(velocidad(1:N,2)<-vmax(1:N,2),2); 
    velocidad(velocidad(1:N,3)<-vmax(1:N,3),3)=-vmax(velocidad(1:N,3)<-vmax(1:N,3),3);   
    
    
     %% 7) Nueva posición de la particula
     X=X+velocidad; 
     [masasordenadasdemayoramenor,posiciondemasas]=sort(M,'descend');
     X(1:N,:)= X(posiciondemasas(1:N),:);
     
     %% 8) Obligamos a que esten en el dominio de la solucion
     X(X(1:N,1)<kron(amin,ones(N,1))==1,1)=amin;
     X(X(1:N,1)>kron(amax,ones(N,1))==1,1)=amax;
 
     X(X(1:N,2)<kron(bmin,ones(N,1)),2)=bmin;
     X(X(1:N,2)>kron(bmax,ones(N,1)),2)=bmax;

     X((X(1:N,3)<rmin),3)=rmin((X(1:N,3)<rmin));
     X((X(1:N,3)>rmax),3)=rmax((X(1:N,3)>rmax)); 
    %% Se guarda la solucion para plotearla l
    Valores(t,1)=min(fit); 
     
end
     
    %% Se plotea la solucion
       plot(Valores);
    %% Comprabamos la velocidad   
       profile viewer