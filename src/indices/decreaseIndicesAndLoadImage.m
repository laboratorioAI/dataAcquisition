function decreaseIndicesAndLoadImage(handles)
global userData
countGesture = userData.counterGesture;
countRepetition = userData.counterRepetition;

if countRepetition > 1
    
    countRepetition = countRepetition - 1;
    
else
    % previous gesture
    countGesture = countGesture - 1;
    countRepetition = userData.gestures.repXClass(countGesture);
    % dibujarImagen(handles, userData.gestures.classes{countGesture});
    gestureName = userData.gestures.classes{countGesture};
    handles.repetirButton.Enable = 'off';
    handles.grabarButton.Enable = 'off';
    drawnow
    showGestureGif(handles, gestureName);
    drawnow
    handles.repetirButton.Enable = 'on';
    handles.grabarButton.Enable = 'on';
end

userData.counterGesture = countGesture;
userData.counterRepetition = countRepetition;

%% Set gesture and repetition in GUI
gestureName = userData.gestures.classes{countGesture};
repXClass = userData.gestures.repXClass;
handles.tituloGestoText.String = gestureName;
handles.repeticionesText.String = [num2str(userData.counterRepetition) '/' num2str(repXClass(countGesture))]; % rep: 2/3
% dibujarImagen(handles,gestureName);

saveUserData();
drawnow
end