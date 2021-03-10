function ledConexion(handles, flagLed)
% pintando de verde led
% cuando flagLed es boolean es o verde o rojo, sino yellow'

if isequal(flagLed, 'yellow')
    scatter(handles.connectLedAxes,0,0,60,'y','filled');
    axis(handles.connectLedAxes,'off');
    return;
end

% --else

if flagLed
    scatter(handles.connectLedAxes,0,0,60,'g','filled');
else
    scatter(handles.connectLedAxes,0,0,60,'r','filled');
end

axis(handles.connectLedAxes,'off');
end