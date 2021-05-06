function repetirFlag = plotEMGSaved(handles, userData, transicion)
% returns true when too few samples in the input data.
% Transition is time in seconds

repetirFlag = false; % default
global deviceType gForceObject
%-% current
gestureCount = userData.counterGesture;
repetition = userData.counterRepetition;
gestureName = userData.gestures.classes{gestureCount};
emgs = userData.gestures.(gestureName).data{repetition,1}.emg;
timeGesture = userData.extraInfo.timePerRepetition;


%% data
yMin = -1;
yMax = 1;
if deviceType == DeviceName.gForce
    freq = gForceObject.emgFreq;
else
    optionsRecording = recordingConfigs();
    freq = optionsRecording.myo.emgSamplingRate;
end

xlimit = timeGesture * freq;

transSTR = transicion * freq;

%% textos emg
muestrasAq = length(emgs);
handles.muestrasText.String = num2str(muestrasAq);
options = recordingConfigs();
minSignalLength = options.recording.minSignalLength;
if muestrasAq < minSignalLength/100 * timeGesture * freq
    % pocas muestras!
    handles.muestrasText.ForegroundColor = [1 0 0];
    % forzamos a repetir
    repetirFlag  = true;
else
    % muestras correctas
    handles.muestrasText.ForegroundColor = [0 0 1];
end



%% Plot EMg
for cidx = 1:8
    idxSTR = num2str(cidx);
    ax = ['handles.emg' idxSTR 'Axes'];
    cmd = ['plot(' ax ', emgs(:,' idxSTR '));'];
    cmd = [cmd 'xlim(' ax ', [0 xlimit]);'];
    cmd = [cmd 'ylim(' ax ', [yMin yMax]);'];
    cmd = [cmd ax '.YTick = [];']; %YTick
    
    cmd = [cmd 'line([transSTR transSTR],[yMin yMax],''LineWidth'',2'...
        ',''Color'',[1 0.8043 0],''Parent'',' ax ');'];
    cmd = [cmd ax '.XTick = [];'];
    eval(cmd);
end

%% plot quats
optionsRecording = recordingConfigs();
freqQuat = optionsRecording.quaternionsSamplingRate;

quats = userData.gestures.(gestureName).data{repetition,1}.quaternions;
plot(handles.rotAxes, quats)

xlim(handles.rotAxes, [1, size(quats, 1)])
ylim(handles.rotAxes, [-1 1])
hold(handles.rotAxes, 'on')
line(transicion*freqQuat*[1 1],[-1 1], 'LineWidth', 2 ...
    ,'Color', [1 0.8043 0],'Parent',handles.rotAxes);

legend(handles.rotAxes, 'w', 'x','y','z', 'Location', 'best')
handles.rotAxes.XTick = '';
% quats!
muestrasQ = length(quats);
handles.muestrasQuat_txt.String = num2str(muestrasQ);

if muestrasQ < minSignalLength/100 * timeGesture * freqQuat
    % pocas muestras!
    handles.muestrasQuat_txt.ForegroundColor = [1 0 0];
    repetirFlag  = true;
else
    % muestras correctas
    handles.muestrasQuat_txt.ForegroundColor = [0 0 1];
end
end


