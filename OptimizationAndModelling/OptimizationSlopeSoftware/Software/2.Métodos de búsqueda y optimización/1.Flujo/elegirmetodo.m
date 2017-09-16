% Procedimiento: elegirmetodo
% Este procedimiento adapta una cadena para poder llamar a cada método
if strcmp(Metodo,'mMorgPri')==1
    Met=['[FS,lambda] =' Metodo '( x,y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi);'];
 else
    Met=['[ FS ] =' Metodo '( y_talud_med,y_circ_med,alfa,pasovector,gd,C,fi );'];
 end  