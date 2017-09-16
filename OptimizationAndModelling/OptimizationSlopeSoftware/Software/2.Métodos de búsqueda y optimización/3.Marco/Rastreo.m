function [FSRabmin,FSRmab,FS3D,i,j] = Rastreo(a1,a2,b1,b2,pa,pb,C,PT,gd,fi,B,H,rebanadas,Met,Metodo )
% Esta función permite calcular el mínimo FS asociado a un talud. Necesita
% ser usada por otra función que la utilice, como por ejemplo la funcion
% marcosoptimos
% Inputs
% a1,a2,b1,b2: Son las esquinas del marco de búsqueda
% pa,pb: Pasos con los que se quiere rastrear dicho marco
% resto de variables: ver funcion FSP
% Outputs
% FSRabmin: Es el factor de seguridad mínimo global.
% Resto de variable: Ver memoria descriptiva


    cFSRmab=0;
        j=0;            % Este contador permite crear la matriz FS3D
    for a=linspace(a1,a2,pa+1)
        j=j+1;
        i=0;    % Este contador permite crear la matriz FS3D
        for b=linspace(b1,b2,pb+1)
            i=i+1;
            cFSRmab=cFSRmab+1; 
                [D,R2max,D1,D2,D3,zona]=distminR1(B,H,a,b);
                
                % Parche de proteccion
                    if b<=0 || D2<=0 || (a>=B && b<=H)
                        FSRmab(cFSRmab,:)=[nan nan a b]; %FSRmab=[FSmin R(FSmin) a  b]
                        FS3D(i,j)=nan;  
                        continue
                    end       
            [FSminR]=FSRMinConOpt( a,b,PT,C,gd,fi,B,H,rebanadas,Met,Metodo );
            FSRmab(cFSRmab,:)=[FSminR a b]; %FSRmab=[FSmin R(FSmin) a  b]
            FS3D(i,j)=FSminR(1,1);          % Matriz FSmin en 3D
        end
    end
    %        Buscamos la pareja FSmin,R
            [FSmin,pFSmin] = min(FSRmab(:,1)); %Buscamos FSmin
            FSRabmin=[FSmin FSRmab(pFSmin,2:end)]; % FSRabmin=[FSmin R]

end
