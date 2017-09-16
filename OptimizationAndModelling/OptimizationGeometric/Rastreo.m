function [FSRabmin,FSRmab,FS3D,i,j] = Rastreo(a1,a2,b1,b2,pa,pb)
% Esta función permite calcular el mínimo FS asociado a un talud. Necesita
    cFSRmab=0;
        j=0;            % Este contador permite crear la matriz FS3D
    for a=linspace(a1,a2,pa+1)
        j=j+1;
        i=0;    % Este contador permite crear la matriz FS3D
        for b=linspace(b1,b2,pb+1)
            i=i+1;
            cFSRmab=cFSRmab+1; 
      
            [FSminR]=funcionfitness(a,b);
            
            FSRmab(cFSRmab,:)=[FSminR a b]; %FSRmab=[fitness a  b]
            FS3D(i,j)=FSminR(1,1);          % Matriz Fitness en 3D
        end
    end
    %        Buscamos la pareja FSmin,R
            [FSmin,pFSmin] = min(FSRmab(:,1)); %Buscamos FSmin
            FSRabmin=[FSmin FSRmab(pFSmin,2:end)]; % FSRabmin=[FSmin a b ]

end
