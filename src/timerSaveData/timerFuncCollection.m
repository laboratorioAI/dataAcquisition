function timerFuncCollection(~, ~)
%% Stop myo streaming
global myoObject userData deviceType gForceObject;
global errorInData;

gestureCount = userData.counterGesture;
repetition = userData.counterRepetition;

gestureName = userData.gestures.classes{gestureCount};

%% Get data from device
switch deviceType
    case DeviceName.myo
        % # ----- Myo
        sample = struct('emg', [], 'pose_myo', [], 'rot', [], 'gyro', [],...
            'accel', [], 'pointGestureBegins', []);
        
        emgs = myoObject.myoData.emg_log;
        sample.emg = emgs;
        sample.pose_myo = myoObject.myoData.pose_log;
        
        if isempty(sample.emg)
            errorInData = true;
            return;
            % errordlg('¡El Myo no está conectado!','¡ERROR DE CONEXIÓN!');
        end
        
        if any(sample.pose_myo == 65535)
            errorInData = true;
            return;
        end
        
        sample.rot = myoObject.myoData.rot_log();
        sample.gyro = myoObject.myoData.gyro_log();
        sample.accel =  myoObject.myoData.accel_log();
        
        if ~isequal(gestureName, 'relax')
            sample.pointGestureBegins = round( userData.lastTransitionTime*200 );
        end
        
    case DeviceName.gForce
        % # ----- GForce
        sample = struct('emg', [], 'quaternions',...
            [], 'pointGestureBegins', []);
        % sample.emg = (double(gForceObject.getEmg())'- 127)/128;
        try
        sample.emg = gForceObject.getEmg()'; %8bits
        catch
            sample.emg = [];
        end
        if isempty(sample.emg)
            errorInData = true;
            return;
            % NOTA: el errordlg no funciona con el wait.timer
            % errordlg('¡GForce no está conectado!','¡ERROR DE CONEXIÓN!');
        end
        
        
        % if gForceObject.enabledPredictions
        %     sample.pose_myo = gForceObject.getPredictions();
        % else
        %     sample.pose_myo = [];
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