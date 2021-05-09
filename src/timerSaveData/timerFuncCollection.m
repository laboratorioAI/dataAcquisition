function timerFuncCollection(~, ~)
%% Stop myo streaming
global myoObject userData deviceType gForceObject;
global errorInData;
global isSync repetitionNum gestureNameSync; % vars to unify with sync

 % checking if the fnction is for sync or not
if isempty(isSync) || ~isSync
    % not sync, normal gestures
    gestureCount = userData.counterGesture;
    repetition = userData.counterRepetition;

    gestureName = userData.gestures.classes{gestureCount};
else
    % sync
    repetition = repetitionNum;
    gestureName = gestureNameSync;
end

%% Get data from device
sample = struct('emg', [], 'gestureDevicePredicted', [], 'quaternions', [], 'gyro', [],...
    'accel', [], 'pointGestureBegins', []);

switch deviceType
    case DeviceName.myo
        % # ----- Myo
        emgs = myoObject.myoData.emg_log;
        sample.emg = emgs;
        sample.gestureDevicePredicted = myoObject.myoData.pose_log;
        
        if isempty(sample.emg)
            errorInData = true;
            return;
            % errordlg('¡El Myo no está conectado!','¡ERROR DE CONEXIÓN!');
        end
        
        if any(sample.gestureDevicePredicted == 65535)
            errorInData = true;
            return;
        end
        
        sample.quaternions = myoObject.myoData.quat_log();% w,x,y,z
        sample.gyro = myoObject.myoData.gyro_log();
        sample.accel =  myoObject.myoData.accel_log();
        
        if ~isequal(gestureName, 'relax')
            sample.pointGestureBegins = round( userData.lastTransitionTime*200 );
        end
        
    case DeviceName.gForce
        % # ----- GForce
        try
            emgData = gForceObject.getEmg(); %8bits
        catch
            emgData = [];
        end
        
        % sample.emg = (double(gForceObject.getEmg())'- 127)/128;
        
        if isempty(emgData)
            errorInData = true;
            return;
            % NOTA: el errordlg no funciona con el wait.timer
            % errordlg('¡GForce no está conectado!','¡ERROR DE CONEXIÓN!');
        end
        
        
        % --- emg channels Rotation
        % to map Myo Armband!
        emgData = circshift(emgData', 3, 2);
        emgData = emgRangeConversion(emgData);
        sample.emg = emgData;
        
        % if gForceObject.enabledPredictions. FUTURE!
        %     sample.gestureDevicePredicted = gForceObject.getPredictions();
        % else
        %     sample.gestureDevicePredicted = [];
        % end
        
        if gForceObject.enabledQuats
            sample.quaternions = gForceObject.getOrientation()'; % (4-by-m)'
        else
            sample.quaternions = [];
        end
        
        if ~isequal(gestureName, 'relax')
            sample.pointGestureBegins = round(...
                userData.lastTransitionTime*gForceObject.emgFreq);
        end
end


%% Update sample
userData.gestures.(gestureName).data{repetition,1} = sample;

errorInData = false;
end