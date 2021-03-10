function [gesturesWithData, numRepsXGesture, numGestures, isComplete] = ...
    checkGestos(usuario)
% extrae el número de repeticiones realizadas correctamente por gesto!


%% loading principal base file
filepath = ['.\data\' usuario '\'];
loadedFile = load([ filepath 'userData.mat']);
userData = loadedFile.userData;

%% settings
numRep = userData.gestures.repXClass;

classes = userData.gestures.classes;
numGestures = length(classes);
gesturesWithData = {};
numRepsXGesture = [];
isComplete = false; % assuming data is incomplete. prealloc
%%
for idGesto = 1:numGestures
    nameGesture = classes{idGesto};
    
    % loading gesture data!
    gestureFile = [filepath nameGesture '.mat'];
    if ~isfile(gestureFile)
        % no data of this gesture, check next file!
        % continue
        
        return;
        % assumes that the gestures are recorded in order! so next files
        % are not checked
    end
    
    %--- else, thre is some data
    dataReps = load(gestureFile, 'reps');
    userData.gestures.(nameGesture) = dataReps.reps.(nameGesture);
    gesturesWithData = [gesturesWithData nameGesture];
    numRepsXGesture = [numRepsXGesture 0]; % starting in 0 reps
    
    for kRep = 1:numel(userData.gestures.(nameGesture).data)
        if isempty(userData.gestures.(nameGesture).data{kRep})
            return;
        else
            numRepsXGesture(end) = kRep;
        end
    end
end

% if reaching this point, data is complete
isComplete = true;