
metodoelegido= input('Seleccionar opción:\n1) Fellenius\n2) Bishop simplificado\n3) Morgenstern-Price\n','s'); %mFelle mBishop mMorgPri

    switch metodoelegido
        case {'Fellenius','Felle','1','F'}
                Metodo='mFelle'; 
                Met=['[ FS ] =' Metodo '( y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi );'];
        case {'Bishop simplificado','Bishop','2','B'}
                Metodo='mBishop';
                Met=['[ FS ] =' Metodo '( y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi );'];
        case {'Morgenstern-Price','MP','3'}
                Metodo='mMorgPri';
                Met=['[FS,lambda] =' Metodo '( x,y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi);'];
        otherwise
            disp('Elija un método correctamente')
            return
    end           
% Metodo='mFelle'; 
%                 Met=['[ FS ] =' Metodo '( y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi );'];