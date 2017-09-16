try
    
   delete(handles.Circunferencia);

   delete(handles.CentroCirc);

   delete( handles.ArcoCircunf);

    for t=1:1:handles.numerorebanadas
         lineas=['delete(handles.linea' num2str(t) ')' ];
        eval(lineas);
    end
end
