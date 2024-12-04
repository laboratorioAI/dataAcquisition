function []= setUserDataFromRestauration(handles,userData)
% function gestureData = setUserDataFromRestauration(handles,userData)
%% Username
handles.nameUserText.String = userData.userInfo.username;

%% User info
userInfo = userData.userInfo;
handles.edadText.String = num2str(userInfo.age);
%handles.etniaText.String = userInfo.ethnicGroup;
%handles.emailText.String = userInfo.email;


handles.lesionCheck.Value = userInfo.hasSufferedArmDamage;
handles.bienvenidoText.String = ['Welcome ' userData.userInfo.username];


%% Measures
handles.codMyoText.String = num2str(userInfo.fromElbowToMyo);
handles.cubCodoText.String = num2str(userInfo.fromElbowToUlna);
handles.perimetroText.String = num2str(userInfo.armPerimeter);

%% Extra information
% dice myo, pero es myo y gforce
extraInfo = userData.extraInfo;
myoName = userData.deviceInfo.deviceName;

    disp('Valor actual de listOfMyos.String:');
    disp(get(handles.listOfMyos, 'String'));
    disp(handles.listOfMyos)
    selectedValue = 1;
     set(handles.listOfMyos, 'Value', selectedValue);
if ischar(myoName)
    myoName = {myoName};  % Convertir de string a celda
elseif ~iscell(myoName)
    myoName = {myoName};  % Convertir en celda si no lo es
end
set(handles.listOfMyos,'String',myoName);

global deviceType
deviceType = userData.deviceInfo.DeviceType;

handles.timeGestureText.String = num2str(extraInfo.timePerRepetition);
handles.numRepText.String = num2str(extraInfo.repetitions);
handles.numRepRelaxText.String = num2str(extraInfo.repetitionsRelax);

end
