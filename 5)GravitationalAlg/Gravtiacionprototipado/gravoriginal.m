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
    rmax(i)=2*D;
    rmin(i)=1.2*D;
    R(i,1)=(rmax(i)-rmin(i))*rand(1,1)+rmin(i);
end

X=[xx yy R];

% Velocidades de las masas
velocidad=zeros(N,dimension);
%%
for t=1:tmax
    %% 1) Actualizamos la constante gravitatoria
    G=Go*exp(-betagravedad*(t/tmax));
    %% 2) Sesgo de la poblacion
    clear   M m aceleracion fit quitar masasproblematicas rmax rmin vmaxo
    Nold=N;
    N=round(Ninicial-((Ninicial-poblacionfinal)/(tmax-1))*(t-1));
    quitar=Nold-N;
    
    if quitar>0
        
        for i=1:quitar
        X(end,:)=[];     
        velocidad(end,:)=[];
        end
        
    end
    
    %% 3) Calculamos el fitness
    fit=zeros(N,1);
    for i=1:N
        [ FS] = FSP( X(i,1),X(i,2),X(i,3),C,gd,fi,B,H,rebanadas,Met,Metodo);
        
        if isnan(FS)
            FS=10;
        end
        
        fit(i,1)=FS;
    end
   
    %3)Best y Worst
    
     [best,b]=min(fit);
     [worst,w]=max(fit);   
     if best==worst
          display('best=worst')
         break       
     end   
    
    %% 4) Calculo de masa intercial
    m=zeros(N,1);
    j=0;
    for i=1:N
        m(i,1)=(fit(i)-worst)/(best-worst);
        if m(i,1)==0
            j=j+1;
            masasproblematicas(j)=i; %#ok<SAGROW>
        end            
    end
      
    for i=1:length(masasproblematicas)
        X(masasproblematicas(i),:)=X(b,:);
        m(masasproblematicas(i))=m(b);
    end  
    
   Sumadem=sum(m);
   
   M=zeros(N,1);
   for i=1:N
       M(i,1)=m(i,1)/Sumadem;
   end
   if isnan(Sumadem)
       break
   end
 
    %% 5) Calculo de fuerzas y aceleracion de cada particula
   F=zeros(N,dimension);
   aceleracion=zeros(N,dimension);
   
    for i=1:N  
        FF=zeros(1,dimension);
        for j=1:N
            
            if i==j
                a=0;
            else
                a=1;
            end
            
            FF=FF+(G*M(i,1)*M(j,1)/(norm(X(i,:)-X(j,:))+epsilon)).*(X(j,:)-X(i,:))*a.*rand(1,dimension);
        end
        F(i,:)=FF;
        
        % Aceleracion
        aceleracion(i,:)=F(i,:)./M(i); 
    end
    
    %% 6) Velocidad 
    velocidad=velocidad.*rand(N,dimension)+aceleracion ; 
    vmaxo=zeros(N,dimension);
    for i=1:N
        D=distminR1(B,H,X(i,1),X(i,2));
        rmax(i)=4*D;
        rmin(i)=1.2*D;          
        vmaxo(i,:)=alpha*[amax-amin, bmax-bmin,rmax(i)-rmin(i)];
    end
    % Limites de velocidad
    vmax=zeros(N,dimension);
    for i=1:N
        vmax(i,:)=(1-(t/tmax)^h).*vmaxo(i,:);
        for j=1:dimension
            if velocidad(i,j)>vmax(i,j)
                velocidad(i,j)=vmax(i,j);
                
            elseif velocidad(i,j)<-vmax(i,j)             
                velocidad(i,j)=-vmax(i,j);
                
            end
        end
    end
    X=X+velocidad;  
    
    %% 7) Ordenacion segun su masa
    [masasordenadasdemayoramenor,posiciondemasas]=sort(M,'descend');
    
       for i=1:N
           X(i,:)=X(posiciondemasas(i),:);
       end
       %Obligamos a que esten en el dominio de la solucion
       
       for i=1:N
           
           if X(i,1)<amin             
              X(i,1)=amin;            
           elseif X(i,1)>amax 
              X(i,1)=amax;            
           end
           
           if X(i,2)<bmin             
              X(i,2)=bmin;            
           elseif X(i,2)>bmax 
              X(i,2)=bmax;            
           end 
           
           if X(i,3)<rmin(i)             
              X(i,3)=rmin(i);            
           elseif X(i,3)>rmax(i) 
              X(i,3)=rmax(i);            
           end 
           
       end
       
    Valores(t,1)=min(fit); 
       
end
     
       plot(Valores);

