function isConnectedMyo = connectMyo()
% Función para conectarse al Myo. Utiliza librería Myo Mex. No se realiza
% ninguna acción en el caso de que el dispositivo ya esté
% conectado. La estructura que contiene los datos del Myo se llama
% myoObject; esta es usada como variable global.

global myoObject

isConnectedMyo = 1; % Bandera que indica estado de conexión

try
    % Revisando si existe conexión existente
    isConnectedMyo = myoObject.myoData.isStreaming;
    
    if isnan(myoObject.myoData.rateEMG)
        terminateMyo
        isConnectedMyo = 0;
    end
catch
    % En el caso de que no haya conexión detectada.
    
    try
        % Nueva conexión
        myoObject = MyoMex();
        %         beep
        myoObject.myoData.startStreaming();
        
        % fprintf('Conexión con MYO exitosa!!!\n');
    catch
        % No conexión posible
        isConnectedMyo = 0;
    end
end
end