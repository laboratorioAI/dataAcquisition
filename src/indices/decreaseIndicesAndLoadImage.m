function decreaseIndicesAndLoadImage(handles)
global userData
countGesture = userData.counterGesture;
countRepetition = userData.counterRepetition;

if countRepetition > 1
    % reducing in 1 the repetition
    countRepetition = countRepetition - 1;
    
elseif countGesture  > 1
    % previous gesture
    
    %-- delete the other gesture
    countGesture = countGesture - 1;
    countRepetition = userData.gestures.repXClass(countGesture);
    % dibujarImagen(handles, userData.gestures.classes{countGesture});
    gestureName = userData.gestures.classes{countGesture};
    handles.repetirButton.Enable = 'off';
    handles.grabarButton.Enable = 'off';
    drawnow
    showGestureGif(handles, gestureName);
    drawnow
end
handles.repetirButton.Enable = 'on';
handles.grabarButton.Enable = 'on';

%% updating
userData.counterGesture = countGesture;
userData.counterRepetition = countRepetition;

userData = loadUserData(userData); %loading reps

gestureName = userData.gestures.classes{countGesture};

% removing reps
userData.gestures.(gestureName).data = ...
    userData.gestures.(gestureName).data(1:countRepetition);


%% Set gesture and repetition in GUI
repXClass = userData.gestures.repXClass;
handles.tituloGestoText.String = gestureName;
handles.repeticionesText.String = [num2str(userData.counterRepetition) ...
    '/' num2str(repXClass(countGesture))]; % rep: 2/3
% dibujarImagen(handles,gestureName);

saveUserData();
drawnow
end