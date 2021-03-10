function finishTraining = increaseIndicesAndLoadImage(handles)
global userData
finishTraining = false;
%% Get Data from userData
countGesture = userData.counterGesture;
countRepetition = userData.counterRepetition;
% repetitions = userData.extraInfo.repetitions;
% repetitionsRelax = userData.extraInfo.repetitionsRelax;
numGestures = length(userData.gestures.classes);
% currentGesture = userData.gestures.classes{countGesture};
repXClass = userData.gestures.repXClass;

%% Update counters
if countRepetition >= repXClass(countGesture)
    % se excede el número lim de repeticiones del gesto
    
    if countGesture >= numGestures
        % lim de número de gestos. Fin de la rutina.  GRACIAS!
        finishTraining = true;
        
        return
    else
        % cambio de gesto!
        countGesture = countGesture + 1;
        countRepetition = 1;
        
        % GUI
        beep
        handles.repetirButton.Enable = 'off';
        handles.grabarButton.Enable = 'off';
        
        gestureNext = userData.gestures.classes{countGesture};
        handles.msjText.String = 'cargando...';
        cla(handles.gestoAxes)
        drawnow
        
        uiwait(msgbox(['Siguiente gesto: ' upper(gestureNext)],...
            '¡ATENTO! CAMBIO DE GESTO','help', 'modal'));
        
        % dibujarImagen(handles,gestureNext);
        % initGestureGif(handles, gestureNext);
        handles.tituloGestoText.String = gestureNext;
        showGestureGif(handles, gestureNext);
        beep
        drawnow
        handles.repetirButton.Enable = 'on';
        handles.grabarButton.Enable = 'on';
    end
else
    % otra común y silvestre repetición!
    countRepetition = countRepetition + 1;
end

userData.counterGesture = countGesture;
userData.counterRepetition = countRepetition;

%% Set gesture and repetition in GUI
gestureName = userData.gestures.classes{countGesture};
handles.tituloGestoText.String = gestureName;
handles.repeticionesText.String = [num2str(userData.counterRepetition) '/' num2str(repXClass(countGesture))]; % rep: 2/3
drawnow
end
