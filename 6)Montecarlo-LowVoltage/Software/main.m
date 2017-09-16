clear
clc
mainpath=pwd;
PotenciaContratada=[3 6 5 3 3 10 3 4 ...
    9 3 12 10 4 7 4 2 ...
    10 10 4 13 9 2 11 ...
    9 4 9 6 10 9 11 3 ...
    5 13 4 6 4 3 6 3 3 ...
    13 8 2 9 4 4 3 4 9 ...
    11 4 3 3 3 8];

nodosTotales=length(PotenciaContratada);
PotenciaMaximaDeAeroGenerador=5;
PotenciaMaximaDeAeroGeneradorVector=5*ones(1,nodosTotales);
% for experimento=1:2
cd(mainpath);

    experimento=1;
% potenciInicial=140;
% potenciaFinal=95;
incremento=-2;
iter=100;
switch experimento
    
    case 1
        PotenciaMaximaAInstalarPorUsuario=PotenciaContratada;
        
    case 2
        PotenciaMaximaAInstalarPorUsuario= ...
            min([PotenciaContratada;PotenciaMaximaDeAeroGeneradorVector]);
        
    case 3
        % Caso: sin potencia inyectada
        iteracion=1;
        PotenciaMaximaAInstalarPorUsuario=zeros(1,55);
        matrizDePotencias= PotenciaMaximaAInstalarPorUsuario;
    case 4
        % Caso: sin potencia inyectada
        iteracion=1;
        PotenciaMaximaAInstalarPorUsuario= ...
            PotenciaMaximaDeAeroGeneradorVector;
        matrizDePotencias= PotenciaMaximaAInstalarPorUsuario;
end

if experimento==1 || experimento==2
    emp=tic;
    distribucionNumero=0;
    maxVpuInEachPotDistr=2;maxIloadInEachPotDistr=2;
    potenciaARepartir=122;
    %     for potenciaARepartir=potenciInicial:incremento:potenciaFinal
    while maxVpuInEachPotDistr(end)>1.07 || maxIloadInEachPotDistr(end)>1
        
        distribucionNumero=distribucionNumero+1;
        potenciaARepartir=potenciaARepartir+incremento;
        
        %% Montecarlo
        
        if ~(sum(PotenciaMaximaAInstalarPorUsuario)<=potenciaARepartir)
            [matrizDePotencias]=monteCarloMetodo(iter,PotenciaMaximaAInstalarPorUsuario,potenciaARepartir,PotenciaMaximaDeAeroGenerador);
        else
            fprintf('Es absurdo. No se puede repartir %f si la capacidad maxima es %f',sum(PotenciaMaximaAInstalarPorUsuario),potenciaARepartir);
        end
        %% Calculo de parametros
        for iteracion=1:iter
            fprintf('Experimento%i Potencia=%i, iter=%i\n',experimento,potenciaARepartir,iteracion);
            
            makeProject;
            
            % Incorporamos Aerogeneradores
            for nodo=1:55
                DSSText.Command = ['generator.Aeros',num2str(nodo),'.kw=',num2str(matrizDePotencias(iteracion,nodo))];
            end
            DSSSolution.Solve;
            DSSText.Command = 'export meters';
            
            %      [~,vFieldPU,~,iFieldLoad]=calculoDeHiperMatricesElectricas(DSSMonitors);
            [~,vFieldPU,~,iFieldLoad,potenciasActiva,potenciasReactiva]=calculoDeHiperMatricesElectricas(DSSMonitors);
            vFieldPU(:,:,iteracion)=vFieldPU;
            iFieldLoad(:,:,:,iteracion)=iFieldLoad;
            potenciasActiva(:,:,iteracion)=potenciasActiva;
            potenciasReactiva(:,:,iteracion)=potenciasReactiva;
        end
        %% Tensiones maximas de la iteracion X
        maxVpuInEachPotDistr(distribucionNumero)=squeeze(max(max(max(vFieldPU))));
        maxIloadInEachPotDistr(distribucionNumero)=squeeze(max(max(max(max(iFieldLoad)))));
        fprintf('Tension%f Carga=%f\n',maxVpuInEachPotDistr(end),maxIloadInEachPotDistr(end));
        
        %         if (any(maxVpuInEachPotDistr<1.07) && any(maxIloadInEachPotDistr<1))
        %             fprintf('La potencia maxima que se puede distribuir es: %f',potenciaARepartir)
        %             break;
        %         end
        
        
    end
    
    fin=toc(emp);
    %% Extraemos los valores correspondientes a la iteracion en la que se produjeron los valores maximos
    [~,iterDondeEstaLaVmax]=max(max(max(vFieldPU)));
    vFieldPU=vFieldPU(:,:,iterDondeEstaLaVmax);
    iFieldLoad=iFieldLoad(:,:,:,iterDondeEstaLaVmax);
    potenciasActiva=potenciasActiva(:,:,iterDondeEstaLaVmax);
    potenciasReactiva=potenciasReactiva(:,:,iterDondeEstaLaVmax);
    
    
elseif experimento==3
    makeProject;
    DSSText.Command = 'set mode=daily stepsize=1m number=1440';
    DSSSolution.Solve;
    DSSText.Command = 'export meters';
    [~,vFieldPU,~,iFieldLoad,potenciasActiva,potenciasReactiva]=calculoDeHiperMatricesElectricas(DSSMonitors);
elseif experimento==4
    
    makeProject;
    
    % Incorporamos Aerogeneradores
    for nodo=1:55
        DSSText.Command = ['generator.Aeros',num2str(nodo),'.kw=',num2str(matrizDePotencias(iteracion,nodo))];
    end
    DSSSolution.Solve;
    DSSText.Command = 'export meters';
    [~,vFieldPU,~,iFieldLoad,potenciasActiva,potenciasReactiva]=calculoDeHiperMatricesElectricas(DSSMonitors);
    
    
    
    
end
%% Visualizamos resultados
switch experimento
    case 1
        plotAndSaveExp1;
    case 2
        plotAndSaveExp2;
    case 3
        plotAndSaveExp3;
    case 4
        plotAndSaveExp4;
end
% end
