%% OpenDSS:Interfaz
[DSSStartOK, DSSObj, DSSText] = DSSStartup;
if DSSStartOK  
    % Set up the interface variables
    DSSCircuit=DSSObj.ActiveCircuit;
    DSSSolution=DSSCircuit.Solution;
    DSSMonitors = DSSCircuit.Monitors;
%     DSSText.Command = 'compile C:\Users\aargu\Dropbox\andrea\SIMULACIONES\matlab\Master_IEEE_LV.dss';
    DSSText.Command = 'compile C:\Users\aargu\Desktop\Proyecto\OpenDSS\Master_IEEE_LV.dss';
    DSSText.Command = 'Redirect aerogeneradores.dss';
%     % Incorporamos Aerogeneradores
%     for nodo=1:55
%         DSSText.Command = ['generator.Aeros',num2str(nodo),'.kw=',num2str(matrizDePotencias(nodo))];
%     end
%     DSSSolution.Solve;
%     DSSText.Command = 'export meters';
else
    disp('Ha habido un error iniciando la interfaz');
end
