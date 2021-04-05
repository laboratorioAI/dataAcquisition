function userData = getUserDataFromHandles(handles)
% se creo el userData a partir de la interfaz, y de datos default!

%% Clear spaces Username
tmpUserName = handles.nameUserText.String;
tmpUserName(tmpUserName == ' ') = [];

%% User info
userInfo.username = tmpUserName;
userInfo.age = str2double(handles.edadText.String);
userInfo.gender = handles.genderGroup.SelectedObject.String;
userInfo.handedness = handles.handednessGroup.SelectedObject.String;
userInfo.ethnicGroup = handles.etniaText.String;
userInfo.hasSufferedArmDamage = handles.lesionCheck.Value;
userInfo.email = handles.emailText.String;
userInfo.occupation = handles.ocupacionText.String;

%% Measures
userInfo.fromElbowToMyo = str2double(handles.codMyoText.String);
userInfo.fromElbowToUlna = str2double(handles.cubCodoText.String);
userInfo.armPerimeter = str2double(handles.perimetroText.String);
userData.userInfo = userInfo;

%% Extra information
listOfMyos = handles.listOfMyos.String;
myoNum = handles.listOfMyos.Value;
% extraInfo.myoName = listOfMyos{myoNum};
extraInfo.deviceName = listOfMyos{myoNum};

extraInfo.date = datetime;
extraInfo.timePerRepetition = str2double(handles.timeGestureText.String);
extraInfo.repetitions = str2double(handles.numRepText.String);
extraInfo.repetitionsRelax = str2double(handles.numRepRelaxText.String);

% repetitions sync
options = syncConfigs();

extraInfo.timePerSyncRepetition = options.timeGestureSync;
extraInfo.syncRepetitions = options.numOfRepetitions;


%%
global deviceType
extraInfo.DeviceType = deviceType;

userData.extraInfo = extraInfo;

%% shuffling
% allGestures
relax = {'relax'}; % default!

group1 = {'fist', 'waveIn', 'waveOut', 'open', 'pinch'};
group2 = {'up', 'down', 'forward', 'backward', 'left', 'right'};

idxs1 = randperm(numel(group1));
idxs2 = randperm(numel(group2));

group1NewOrder = group1(idxs1);

group2NewOrder = group2(idxs2);

% de tal forma el relax aparece siempre primero!
allGestures = [relax(1)
    group2NewOrder(1)
    group1NewOrder(1)
    group2NewOrder(2)
    group1NewOrder(2)
    group2NewOrder(3)
    group1NewOrder(3)
    group2NewOrder(4)
    group1NewOrder(4)
    group2NewOrder(5)
    group1NewOrder(5)
    group2NewOrder(6)]';

userData.gestures.classes = allGestures;

%% Empty samples
userData.gestures.repXClass = [extraInfo.repetitionsRelax ...
    extraInfo.repetitions * ones(1, numel(allGestures) - 1)]; % vector con las repeticiones correspondientes a cada gesto!

% loop para crear estructuras!
for idx = 1:length(allGestures)
    %     userData.gestures.(allGestures{idx}).transiciones = [];
    userData.gestures.(allGestures{idx}).gestureName = allGestures{idx};
    userData.gestures.(allGestures{idx}).data = []; % YA NO crea estructura dependiendo del número de rep del gesto
end

end
