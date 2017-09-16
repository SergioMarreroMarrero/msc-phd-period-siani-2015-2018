function [parameterField,parameterFieldPU]=parameterPhaseTimeNodesConcatenation(nodeNames,electricParameter,DSSMonitors,caract)

switch electricParameter
    
    case 'v'
        
        node=0;
        for currentNode=nodeNames
            node=node+1;
            DSSMonitors.Name =cell2mat(currentNode);
            parameterField(node,:)=DSSMonitors.Channel(caract(node));
%             parameterField(2,:,node)=DSSMonitors.Channel(3);
%             parameterField(3,:,node)=DSSMonitors.Channel(5);
            
        end
        
        parameterFieldPU=parameterField/(400/sqrt(3));
        
    case 'i'
        
        node=0;
        for currentNode=nodeNames
            node=node+1;
            DSSMonitors.Name =cell2mat(currentNode);
            parameterField(1,:,node)=DSSMonitors.Channel(7);
            parameterField(2,:,node)=DSSMonitors.Channel(9);
            parameterField(3,:,node)=DSSMonitors.Channel(11);
            
            parameterFieldPU(:,:,node)=parameterField(:,:,node)/caract(node);
        end
        
    case 'p'
        
        DSSMonitors.Name =nodeNames;
        parameterField(1,:,1)=DSSMonitors.Channel(1); %Fase 1
        parameterField(2,:,1)=DSSMonitors.Channel(3); %Fase 2
        parameterField(3,:,1)=DSSMonitors.Channel(5); %Fase 3
        
        parameterField(1,:,2)=DSSMonitors.Channel(2);
        parameterField(2,:,2)=DSSMonitors.Channel(4);
        parameterField(3,:,2)=DSSMonitors.Channel(6);
        
end
end