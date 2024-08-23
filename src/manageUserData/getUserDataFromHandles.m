function userData = getUserDataFromHandles(handles)
% se creo el userData a partir de la interfaz, y de datos default!

%% Username
tmpUserName = handles.nameUserText.String;

% clear whitespaces
tmpUserName(tmpUserName == ' ') = [];

% removing ñs, tildes, etc
options = configs();
for i = options.replaces
    tmpUserName = strrep(tmpUserName, i{1},i{2});
end


%% User info
global userData;
userInfo.username = tmpUserName;
userInfo.age = str2double(handles.edadText.String);
userInfo.gender = handles.genderGroup.SelectedObject.String;
userInfo.handedness = handles.handednessGroup.SelectedObject.String;
%userInfo.ethnicGroup = handles.etniaText.String;
userInfo.hasSufferedArmDamage = handles.lesionCheck.Value;
%userInfo.email = handles.emailText.String;
userInfo.occupation = handles.ocupacionText.String;
userInfo.temperature = handles.TempUserText.String;
userInfo.oxygenSaturation = handles.spoUserText.String;
userInfo.bloodPressure = handles.bloodPressureUserText.String;
userInfo.weight  = handles.wtUserText.String;
userInfo.height  = handles.htUserText.String;

if isfield(userData, 'userInfo') && isfield(userData.userInfo, 'answers')
    userInfo.answers = userData.userInfo.answers;
else
    fields = {'Question1', 'Question2', 'Question3', 'Question4', 'Question5', 'Question6', 'Question7'};
    values = repmat({'NaN'}, size(fields));
    userInfo.answers = cell2struct(values, fields, 2);
end


%% Measures
userInfo.fromElbowToMyo = str2double(handles.codMyoText.String);
userInfo.fromElbowToUlna = str2double(handles.cubCodoText.String);
userInfo.armPerimeter = str2double(handles.perimetroText.String);
userData.userInfo = userInfo;

%% Extra information
extraInfo.date = datetime;
extraInfo.timePerRepetition = str2double(handles.timeGestureText.String);
extraInfo.repetitions = str2double(handles.numRepText.String);
extraInfo.repetitionsRelax = str2double(handles.numRepRelaxText.String);

% repetitions sync
options = syncConfigs();

extraInfo.timePerSyncRepetition = options.timeGestureSync;
extraInfo.syncRepetitions = options.numOfRepetitions;

% -- software version
options = configs();
extraInfo.softwareVersion = options.version;

%
userData.extraInfo = extraInfo;

%% device!
% type
global deviceType gForceObject
deviceInfo.DeviceType = char(deviceType);

% name
listOfDevices = handles.listOfMyos.String;
myoNum = handles.listOfMyos.Value;
% extraInfo.myoName = listOfMyos{myoNum};
deviceInfo.deviceName = listOfDevices{myoNum};

% sampling frequency!
optionsRecording = recordingConfigs();
if deviceType == DeviceName.myo
    deviceInfo.emgSamplingRate = optionsRecording.myo.emgSamplingRate;
else
    deviceInfo.emgSamplingRate = gForceObject.emgFreq;
end

% --
userData.deviceInfo = deviceInfo;
%% gesture arrangement
global gesture_set_confs
if gesture_set_confs.gesture_set == GestureSet.G11
    % %%%%%%%%%%%%%%% G11
    % Do G11 shuffling
    gDir = GestureSet.G11;
    gMyo = GestureSet.G5;

    gMyo = gMyo.gestures;
    %gMyo = {'fist', 'waveIn', 'waveOut', 'open', 'pinch'};

    gDir = gDir.gestures;
    %gDir = {'up', 'down', 'forward', 'backward', 'left', 'right'};

    idxs1 = randperm(numel(gMyo));
    idxs2 = randperm(numel(gDir));

    group1NewOrder = gMyo(idxs1);
    group2NewOrder = gDir(idxs2);

    % de tal forma el relax aparece siempre primero!
    gesture_set = [{'relax'}
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
else
    % %%%%%%%%%%%%%%% G5
    gMyo = GestureSet.G5;
    gMyo = gMyo.gestures;

    idxs = randperm(numel(gMyo));
    gesture_set = [ {'relax'} gMyo(idxs)];
end


userData.gestures.classes = gesture_set;

%% Empty samples
userData.gestures.repXClass = [extraInfo.repetitionsRelax ...
    extraInfo.repetitions * ones(1, numel(gesture_set) - 1)]; % vector con las repeticiones correspondientes a cada gesto!

% loop para crear estructuras!
for idx = 1:length(gesture_set)
    userData.gestures.(gesture_set{idx}).gestureName = gesture_set{idx};
    userData.gestures.(gesture_set{idx}).data = []; % YA NO crea estructura dependiendo del número de rep del gesto
end

end
