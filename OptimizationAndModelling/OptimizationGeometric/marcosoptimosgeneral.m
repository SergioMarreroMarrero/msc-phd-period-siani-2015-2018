function [FSRabmin,FRab,npmt,et,p,npt] = marcosoptimosgeneral(ca,cb,l1,pn,fe )

dibujarmarco=1;

% Calculamos los parámetros de optimización
po=l1/2;
et=round(log(po/pn)); % número de etapas o marcos optimo
% Definimos el vector p=(p1,p2...pet)
p=0*(1:et-1); % Restamos 1 porque el último el primero son dato
    for q=1:et-1
        p(q)=nthroot((pn^q)*po^(et-q),et);
    end
p=[po p pn]; % Conjunto de pasos optimo
npt=round(2*fe*nthroot((po/pn),et)+1);% El número de puntos a repartir en cada tramo será
pa=npt;pb=npt;
%
repeticiones=0; % Esta variable informará las veces que se tuvo que repetir una operación porque el centro quedó en el borde
hold on
for q=1:et
a1=ca-fe*p(q);
a2=ca+fe*p(q);
b1=cb-fe*p(q);
b2=cb+fe*p(q);

                if dibujarmarco==1
                    figure(3)
                    hold on
                    vp=[a1 b1];vf=[a2 b2];
                    rectangulo
                    rectang(q)=plot([a1,a2,a2,a1,a1],[b1,b1,b2,b2,b1]);   
                end    
        
   [FSRabmin] = Rastreo(a1,a2,b1,b2,pa,pb);
       
   % El centro encontrado no puede estar en el borde
   w=0;
  while FSRabmin(2)==a1 || FSRabmin(2)==a2 || FSRabmin(3)==b1 || FSRabmin(3)==b2
      w=w+1;
      if w>10
          break
      end
        a1=FSRabmin(2)-fe*p(q); 
        a2=FSRabmin(2)+fe*p(q);
        b1=FSRabmin(3)-fe*p(q);
        b2=FSRabmin(3)+fe*p(q);
        repeticiones=repeticiones+1;
             if dibujarmarco==1
                 figure(3)
                 hold on
                vp=[a1 b1];vf=[a2 b2];
                rectangulo
                 rectang(q+repeticiones)=plot([a1,a2,a2,a1,a1],[b1,b1,b2,b2,b1],'b');
             end
        [FSRabmin] = Rastreo(a1,a2,b1,b2,pa,pb );
        if isnan(FSRabmin(1,1))        
            continue
        end 
   end
   % Asignamos los nuevos centros sobre los que dibujar el marco
   ca=FSRabmin(2);
   cb=FSRabmin(3); 
 % Guardamos todos los valores en un vector
   FRab(q,:)=FSRabmin;
end
npmt=(et+repeticiones)*(npt+1)^2; % Calculamos el número total de simulaciones


end

