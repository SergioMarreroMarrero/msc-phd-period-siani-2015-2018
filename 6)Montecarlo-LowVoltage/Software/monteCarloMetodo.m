function [matrizDePotencias]=monteCarloMetodo(iterTotal,pLim,Pot2Rep,Pmax)
deltaDisminucion=1;
nodosTotales=length(pLim);
matrizDePotencias=zeros(iterTotal,nodosTotales);

for iter=1:iterTotal
    listaNodos=1:nodosTotales;
    sumaP=0;
    while sumaP<Pot2Rep
        
        punteroAListadeNodos=randi(numel(listaNodos));
        nodo=listaNodos(punteroAListadeNodos);
        
        addPotenciaAleatoria=rand*Pmax;
        matrizDePotencias(iter,nodo)= matrizDePotencias(iter,nodo)+ addPotenciaAleatoria;
        matrizDePotencias(iter,nodo)=ceil(matrizDePotencias(iter,nodo));
        
        if matrizDePotencias(iter,nodo)>pLim(1,nodo)
            matrizDePotencias(iter,nodo)=pLim(1,nodo);
            deleteNodo= listaNodos==nodo;
            listaNodos(deleteNodo)=[];
        end
        
        sumaP=sum(matrizDePotencias(iter,:));
       
        
        if isempty(listaNodos)
            disp('Introducir una potencia menor');
            return
        end
        
    end
    
    if sumaP>Pot2Rep
        while sumaP~=Pot2Rep
            listaNodosAQuitar=find(matrizDePotencias(iter,:)>1);
            punteroAListadeNodosaQuitar=randi(numel(listaNodosAQuitar));
            nodo=listaNodosAQuitar(punteroAListadeNodosaQuitar);
            matrizDePotencias(iter,nodo)= matrizDePotencias(iter,nodo)-deltaDisminucion;
            sumaP=sum(matrizDePotencias(iter,:));
            
        end
    end
    
    
end



end




