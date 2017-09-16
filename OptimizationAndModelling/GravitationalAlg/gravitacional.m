clear 
clc
epsilon=0.01;
N=50;
kn=1;
Ninicial=50;
dimension=2; % Espacio 
%Limite del espacio de busqueda
xmax=5;
xmin=-5;
ymax=5;
ymin=-5;
LimitesX=[xmin xmax;ymin ymax];
h=0.1;
alpha=0.05;
vmaxo=alpha*[xmax-xmin, ymax-ymin] ;

X=10*rand(N,dimension)-5;
velocidad=10*rand(N,dimension)-5;
tmax=500;
Go=100;betagravedad=20;
format long
for t=1:tmax
    m=[];
    M=[];
    fit=[];
    %Elitismo
    Nold=N;
    N=ceil(Ninicial-((Ninicial-kn)/(tmax-1))*(t-1));
    quitar=Nold-N;
    if quitar==1
    for i=1:quitar
        X(end,:)=[];     
        velocidad(end,:)=[];
    end
    end
    
    %1) Actualizamos la constante gravitatoria
    G=Go*exp(-betagravedad*(t/tmax));
    
    
    %2) Calculamos el fitness
    for i=1:N
    fit(i,1)=exp(-1/((X(i,1))^2+(X(i,2))^2));

%     fit(i,1)=X(i,1)^2+ X(i,2)^2;
    end
    fit
    %3) Calculo del mejor y el peor
     [best,b]=min(fit)
     [worst,w]=max(fit)
     if best==worst
          display('best=worst')
         break
        
        
     end
%     fit(w,1)=rand(1,1)*best;
%     X(w,:)=X(b,:);
    X
    fit
    clear m
    %4) Calculo de masa intercial
    j=0;
    masasproblematicas=[];
    for i=1:N
        diferencia=best-worst;
        m(i,1)=(fit(i,1)-worst)/(best-worst);  
        if m(i,1)==0
            j=j+1;
            masasproblematicas(j)=i;
        end
             
    end
    
    for i=1:length(masasproblematicas)
           X(masasproblematicas(i),:)=rand(1,2).*X(b,:);
           m(masasproblematicas(i))=rand(1,1)*m(b);
    end
    
    
    Sumadem=sum(m)
   if isnan(Sumadem)
        break
    end
    for i=1:N
        M(i,1)=m(i,1)/Sumadem;
        
    end
    
    
 
    
    
  
    % Fuerzas
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
                        
            FF=FF+(G*M(i,1)*M(j,1)/(norm(X(i,:))+epsilon)).*(X(j,:)-X(i,:))*a.*rand(1,dimension);
        end
        F(i,:)=FF;
        % Aceleracion
        aceleracion(i,:)=F(i,:)./M(i);
        
    end 
    
    aceleracionparamedia=aceleracion;
    
    for i=1:N
        for j=1:dimension
           
            if  isnan(aceleracion(i,j))                                  
                            
                aceleracionparamedia(i,j)=zeros(1,1)
               aceleracionmedia=mean(aceleracionparamedia)
               aceleracion(i,j)=aceleracionmedia(1,j)
               
            end
        end
    end

    
    aceleracion
    

        % Velocidad
        velocidad=velocidad.*rand(N,dimension)+aceleracion
        
        % Limites de velocidad
        vmax=(1-(t/tmax)^h).*vmaxo;
        for i=1:N
            for j=1:dimension
                if velocidad(i,j)>vmax(j)
                    velocidad(i,j)=vmax(j);
                end
            end
        end
                     
        vmaxi=alpha*(xmax-xmin)
        
        X=X+velocidad
        % Los ordenamos segun su Masa
        [masasordenadasdemayoramenor,posiciondemasas]=sort(M,'descend');
        
       for i=1:N
           X(i,:)=X(posiciondemasas(i),:);
       end
       %Obligamos a que esten en el dominio de la solucion
       
       for i=1:N
           
           if X(i,1)<xmin             
              X(i,1)=xmin;            
           elseif X(i,j)>xmax 
              X(i,j)=xmax;            
           end
           
           if X(i,2)<ymin             
              X(i,2)=ymin;            
           elseif X(i,j)>ymax 
              X(i,2)=ymax;            
           end 
           
       end
end
       

