function [FS3D,i,j,fitness,fitnessmin] = minimoexhaustivo(a1,a2,b1,b2,pa,pb)
r=0;
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
            r=r+1;
            fitness(r,:)=[FSminR a b];
 
            FS3D(i,j)=FSminR;          % Matriz Fitness en 3D
        end
    end

[fitnessmin,I]=min(fitness(:,1));
fitnessmin=fitness(I,:);
end