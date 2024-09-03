function varargout = entrenamiento(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @entrenamiento_OpeningFcn, ...
    'gui_OutputFcn',  @entrenamiento_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


function entrenamiento_OpeningFcn(hObject, eventdata, handles, varargin)
global gesture_set_confs
if configs("select_gesture")
    %------ select gestures
    app = gestureSelector();
    waitfor(app,'configs');
    
    gesture_set_confs = app.configs;
    app.delete
    clear app
else
    % default values from configs,
    gesture_set_confs  = configs("gesture_setup");
end
%----------
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
movegui(hObject,'center'); % mostrando en el centro
initWaitbarPro(handles);

imgBuho = imread('buhoEPN.png');
axes(handles.buhoAxes);
imagesc(imgBuho);
axis off;
% imgEscudo = imread('fisEPN.jpeg');
imgEscudo = imread('labLogo.png');
axes(handles.escudoAxes);
imshow(imgEscudo);
handles.escudoAxes.Color = 'none';
axis off;

% version
handles.txt_version.String = sprintf('ver: %s', configs("version"));

drawnow;



function varargout = entrenamiento_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function grabarButton_Callback(hObject, eventdata, handles)
%% disable GUI  clear EMG axes
drawnow
handles.repetirButton.Enable = 'off';
handles.grabarButton.Enable = 'off';
clearEMG(handles);

%-% Load data
global userData
userData = loadUserData(userData);
% repetitionCount = userData.counterRepetition;

%-% Wait bar
timeRep = userData.extraInfo.timePerRepetition;
nameGesture = userData.gestures.classes{userData.counterGesture};
transitionTime = getStartingTime(nameGesture, timeRep);

myWaitbarTimer = timerWaitbar(handles, transitionTime, userData);
userData.lastTransitionTime = transitionTime;
drawnow
start(myWaitbarTimer);
drawnow

%-% Save data
global errorInData
errorInData = []; % global var that is updated in timerfunc
myTimerColletion = timerCollection(userData);
drawnow
a = tic;
start(myTimerColletion);

% wait(myTimerColletion); % gives error!
while isempty(errorInData)
    % waiting 2 times the rep, or
    
    if toc(a) > 1.5*userData.extraInfo.timePerRepetition %2*userData.extraInfo.timePerRepetition
        % too long, did not return, error!
        errorInData = true;
    end
    
    drawnow
end

%-% Delete timers
stop(myWaitbarTimer);
stop(myTimerColletion);
delete(myTimerColletion);
delete(myWaitbarTimer);
drawnow;

%-% reiniciar waitbar!
moverWaitbar(handles, 0, 0);

if errorInData
    uiwait(errordlg({'No data received!'
        ''
        'Try recording again.'
        ''
        'If the error keeps appearing, try any of the following:'
        '   1. Restart the device'
        '   2. Check the battery'
        '   3. Unplug and plug the dongle USB'
        '   4. Restart matlab'}, 'ERROR!', 'modal'));
    
    handles.repetirButton.Enable = 'on';
    handles.grabarButton.Enable = 'off';
    drawnow
    return;
end
%-% show current emgs! depends on counters!
repetirFlag = plotEMGSaved(handles, userData, transitionTime);

%-% Grabar
saveUserData(); % usa la variable global
drawnow

%-% Update counters && load image
finishTraining = increaseIndicesAndLoadImage(handles);

% flag...
if finishTraining
    combineUserData(userData);
    drawnow
    finTraining(handles);
    return;
end

if repetirFlag
    % debe repetir
    uiwait(warndlg({'Few data received, please record again.' ...
        'Possible reasons are:'...
        '    1. Low battery,'...
        '    2. More than 1 devices trying to connect.'...
        'In the case this error persists, please restart the system.'}, ...
        'Transmission error', 'modal'));
    
    handles.repetirButton.Enable = 'on';
    handles.grabarButton.Enable = 'off';
    
else
    % normal continuation
    handles.repetirButton.Enable = 'on';
    handles.grabarButton.Enable = 'on';
end
drawnow

function empezarEntrenamientoButton_Callback(hObject, eventdata, handles)
%%
global userData nombreRecolectorDeDatos respuestas; %
% Validación de datos
[isDataValid, msjPrint] = validacionDatos(handles);
if isDataValid
    % desahabilitar
    bloquearGUI(handles);
    
    drawnow
    
    %-% Get data from GUI
    userData = getUserDataFromHandles(handles);
    
    %-% Start counters
    userData.counterGesture = 0; % debido al sync gesture
    userData.counterRepetition = 1;
    
    %-% Recolector de datos
    userData.personWhoRecordedData = nombreRecolectorDeDatos;
    
    %-% save!
    createUserData(userData); % creando archivos
    % saveUserData();
    
    waitingFoto(userData.userInfo.username); % loop that waits until foto
    drawnow
    
    %-% GUI
    % not needed anymore!
    handles.bienvenidoText.String = ['Welcome ' userData.userInfo.username];
    
    countGesture = 1; % muestro el primer gesto
    firstGesture = userData.gestures.classes{1};
    repXClass = userData.gestures.repXClass;
    handles.repeticionesText.String = [num2str(...
        userData.counterRepetition) '/' num2str(repXClass(countGesture))];
    
    handles.tituloGestoText.String = firstGesture;
    
    %dibujarImagen(handles, firstGesture);
    showGestureGif(handles, firstGesture);
    drawnow
    
    % infame sync
    global gesture_set_confs
    if gesture_set_confs.include_sync
        %-% Recolectar datos de sincronización
        handles.msjText.String = 'Waiting sync recordings!';
        %waitfor(playGif('sync')) % sync tutorial!

        
        try
        % Aquí va el código que deseas proteger con try/catch
            uiwait(sincronizacion); % Debe terminar correctamente, si no, se captura el error
        catch ME
        % Manejo del error: muestra un mensaje y reanuda la adquisición de datos
            str = 'Error en sincronización. Se reanudará la adquisición de datos.';
            uiwait(msgbox(str, 'Error','error'));
        end


        str = 'Resuming data acquisition.';
        uiwait(msgbox(str, 'Information','help'));
        drawnow
    else
        userData.counterGesture = 1;
    end
    handles.msjText.String = '';
    
    % only enabling buttons
    handles.grabarButton.Enable = 'on';
    handles.repetirButton.Visible = 'on';
    drawnow
else
    handles.msjText.String = {'NOT VALID DATA', msjPrint};
end

function numRepRelaxText_Callback(hObject, eventdata, handles)

function numRepRelaxText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function timeGestureText_Callback(hObject, eventdata, handles)

function timeGestureText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nameUserText_Callback(hObject, eventdata, handles)

function nameUserText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function connectGForce_Button_Callback(hObject, eventdata, handles)
%% Executes on button press in connectGForce_Button.
% -------------------------------------------------------------------------
% Warning!
uiwait(warndlg({'GForce Pro connection is still in beta.', ...
    '¡Be cautious!', 'It is possible that the system crushes.', ...
    '', 'It is recommended to use the device when it is fully charged.'},...
    'WARNING', 'modal'));

global deviceType
handles.msjText.String = {'Connecting with GForce.', ...
    'This can take several minutes.', ...
    'Please wait...'};
bloquearGUI(handles); % pause during connection
ledConexion(handles, 'yellow');
drawnow
isConnectedG = connectGForce();
drawnow
bloquearGUI(handles, true); % reenable!
handles.grabarButton.Enable = 'off';
handles.repetirButton.Enable = 'off';
drawnow

if isConnectedG
    deviceType = DeviceName.gForce;
    ledConexion(handles, true);
    
    updateBattery(handles);
    
    %-% parámetros de inicio!
    handles.msjText.String = 'Fill the user info and press START!';
    handles.empezarEntrenamientoButton.Enable = 'on';
    handles.restaurarButton.Enable = 'on';
    
    %-% disabling myo button
    handles.connectGForce_Button.Enable = 'off';
    handles.connectMyo_Button.Enable = 'off';
    
    %-% devices
    handles.listOfMyos.String = devices(deviceType);
else
    handles.msjText.String = 'Can not connect to gForce!';
    ledConexion(handles, false);
    handles.empezarEntrenamientoButton.Enable = 'off';
    handles.restaurarButton.Enable = 'off';
    
    handles.connectGForce_Button.Enable = 'on';
    handles.connectMyo_Button.Enable = 'on';
end
drawnow


function connectMyo_Button_Callback(hObject, eventdata, handles)
%%
% -------------------------------------------------------------------------
global deviceType
handles.msjText.String = 'CONNECTING, please, wait...';
% isConnectedMyo = connectFakeMyo();
isConnectedMyo = connectMyo();
drawnow
if isConnectedMyo
    deviceType = DeviceName.myo;
    ledConexion(handles, true);
    
    %-% parámetros de inicio!
    handles.msjText.String = 'Fill the user info and press START!';
    handles.empezarEntrenamientoButton.Enable = 'on';
    handles.restaurarButton.Enable = 'on';
    
    %-% disabling gForce_ button
    handles.connectGForce_Button.Enable = 'off';
    handles.connectMyo_Button.Enable = 'off';
    handles.bat_txt.String = '-';
    
    %-% devices
    handles.listOfMyos.String = devices(deviceType);
else
    handles.msjText.String = {'Could not connect Myo with Matlab', 'Try again'};
    ledConexion(handles, false);
    handles.empezarEntrenamientoButton.Enable = 'off';
    handles.restaurarButton.Enable = 'off';
end

function edadText_Callback(hObject, eventdata, handles)
%% Executes on button press in connectGForce_Button.
% -------------------------------------------------------------------------
edad = str2double(handles.edadText.String);
if ~isnumeric(edad)
    handles.edadText.String = '';
    errordlg('Wrong age', 'Error', 'modal')
end

function edadText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function perimetroText_Callback(hObject, eventdata, handles)
perimetro = str2double(handles.perimetroText.String);
if ~isnumeric(perimetro)
    handles.perimetroText.String = '';
    errordlg('Must be number', 'Error', 'modal')
end

function perimetroText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cubCodoText_Callback(hObject, ~, handles)
cubCodo = str2double(handles.cubCodoText.String);
if ~isnumeric(cubCodo)
    handles.cubCodoText.String = '';
    errordlg('must be number', 'Error', 'modal')
end

function cubCodoText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function codMyoText_Callback(hObject, eventdata, handles)
codMyo = str2double(handles.codMyoText.String);
if ~isnumeric(codMyo)
    handles.codMyoText.String = '';
    errordlg('must be number', 'Error', 'modal')
end

function codMyoText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lesionCheck_Callback(hObject, eventdata, handles)

function etniaText_Callback(hObject, eventdata, handles)

function etniaText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function repetirRepButton_Callback(hObject, eventdata, handles)
decreaseIndicesAndLoadImage(handles);


function restaurarButton_Callback(hObject, eventdata, handles)
%%
global isValidRestaurar userData % myoObject
bloquearGUI(handles);
handles.msjText.String = {'Waiting to resume from restauration point'
    'Please, wait...'};
drawnow
uiwait(restaurar); % busca usuario y actualiza punto de grabado!
drawnow
if isValidRestaurar
    setUserDataFromRestauration(handles,userData);
    
    % saveUserData(); % grabando dos veces!
    %-% Dibujar
    countGesture = userData.counterGesture;
    repXClass = userData.gestures.repXClass;
    handles.repeticionesText.String = [num2str(userData.counterRepetition) '/' num2str(repXClass(countGesture))];
    
    currentGesture = userData.gestures.classes{userData.counterGesture};
    handles.tituloGestoText.String = currentGesture;
    % dibujarImagen(handles, currentGesture);
    showGestureGif(handles, currentGesture);
    drawnow
    handles.grabarButton.Enable = 'on';
    handles.repetirButton.Visible = 'on';
    drawnow
else
    handles.grabarButton.Enable = 'off';
    handles.repetirButton.Enable = 'off';
    
    handles.empezarEntrenamientoButton.Enable = 'on';
    handles.restaurarButton.Enable = 'on';
end


function gesturesListBox_Callback(hObject, eventdata, handles)


function gesturesListBox_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function repetitionsListBox_Callback(hObject, eventdata, handles)

function repetitionsListBox_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function numRepText_Callback(hObject, eventdata, handles)

function numRepText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function repetirButton_Callback(hObject, eventdata, handles)
pregunta = questdlg('Are you sure you want to repeat the last recording?', ...
    'CONFIRM','YES', 'NO', 'YES');

if isequal(pregunta,'YES')
    decreaseIndicesAndLoadImage(handles);
end

% --- Executes on selection change in listOfMyos.
function listOfMyos_Callback(hObject, eventdata, handles)
% hObject    handle to listOfMyos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listOfMyos contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listOfMyos

% --- Executes during object creation, after setting all properties.
function listOfMyos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listOfMyos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ocupacionText_Callback(hObject, eventdata, handles)
% Obtener el índice de la opción seleccionada en el popupmenu
    index = get(hObject, 'Value');
    
    % Obtener el texto de la opción seleccionada
    ocupacion = get(hObject, 'String');
    
    % Extraer la opción seleccionada usando el índice
    selectedOcupacion = ocupacion{index};
    
    % Mostrar la opción seleccionada en la ventana de comandos
    disp(['Ocupación seleccionada: ', selectedOcupacion]);

    % Guardar la ocupación seleccionada en handles para uso futuro
    handles.selectedOcupacion = selectedOcupacion;
    
    % Actualizar la estructura handles
    guidata(hObject, handles);

    
% --- Executes during object creation, after setting all properties.
function ocupacionText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ocupacionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function emailText_Callback(hObject, eventdata, handles)
% hObject    handle to emailText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emailText as text
%        str2double(get(hObject,'String')) returns contents of emailText as a double


% --- Executes during object creation, after setting all properties.
function emailText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emailText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function myoFigure_Callback(hObject, eventdata, handles)
% hObject    handle to myoFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imagenMyo();

% --------------------------------------------------------------------
function acercaDe_Callback(hObject, eventdata, handles)
% hObject    handle to acercaDe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = {'Data acquisition of Hand Gesture Emg signals'
    ''
    'Artifical Intelligence and Computer Vision Research Lab "Alan Turing"'
    ''
    'Revisión 1: 09 de julio de 2019'
    'Revisión 2: 20 de julio de 2019'
    'Revisión 3: 20 de agosto de 2019'
    'Revisión 4: 3 de febrero de 2021'
    'Revision 5: April 14 2021 (english version)'
    ''
    'Version 1.5: July 28th, 2021'
    'Version 1.7 by Carlos Ayala and Gabriel Macías: June 21st, 2024'
    ''
    ''
    'Version 1 created by Jonathan Zea and Cristhian Motoche'
    'August 2018'};
msgbox(str,'About...','help');

% --------------------------------------------------------------------
function myoDiagnostics_Callback(hObject, eventdata, handles)
% hObject    handle to myoDiagnostics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = {'Make sure USB dongle is connected to the PC'};
uiwait(msgbox(str, 'Alert', 'help'));
web('http://diagnostics.myo.com/');


% --- Executes when user attempts to close lienzoFig.
function lienzoFig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to lienzoFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
cleaningTimers();
drawnow
delete(gcf);

% --------------------------------------------------------------------
function videosGestures_Callback(hObject, eventdata, handles)
% hObject    handle to videosGestures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function syncGesture_Callback(hObject, eventdata, handles)
% hObject    handle to syncGesture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%playGif('waveOut');
playGif('sync');

% --------------------------------------------------------------------
function relaxGesture_Callback(hObject, eventdata, handles)
% hObject    handle to relaxGesture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('relax');

% --------------------------------------------------------------------
function fistGesture_Callback(hObject, eventdata, handles)
% hObject    handle to fistGesture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('fist');

% --------------------------------------------------------------------
function openGesture_Callback(hObject, eventdata, handles)
% hObject    handle to openGesture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('open');

% --------------------------------------------------------------------
function waveInGesture_Callback(hObject, eventdata, handles)
% hObject    handle to waveInGesture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('waveIn');

% --------------------------------------------------------------------
function waveOutGesture_Callback(hObject, eventdata, handles)
% hObject    handle to waveOutGesture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('waveOut');


% --------------------------------------------------------------------
function instructionsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to instructionsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function dataAdquisitionInstructions_Callback(hObject, eventdata, handles)
% hObject    handle to dataAdquisitionInstructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = {'DATA ACQUISITION INSTRUCTIONS '
    ''
    '1. Check the battery level of the device.'
    '2. Clean foream with alcohol.'
    '3. Wear the device in the right foream.'
    '4. Sync the device.'
    '5. Do “Web diagnostics” (in case of using Myo armband).'
    '6. Connect with Maltab.'
    '7. Fill user info.'
    '8. Take photography of the foream when wearing the device.'
    '9. Do the whole data acquisition.'
    '10. Turn off the device.'
    '11. Clean electrodes with alcohol.'
    ''
    'In the case of an error, restart matlab, restart device.'};
msgbox(str, 'INSTRUCTIONS','help');

% --------------------------------------------------------------------
function contactInformation_Callback(hObject, eventdata, handles)
% hObject    handle to contactInformation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = {'CONTACT INFORMATION'
    ''
    'In case you detect an error in this software'
    'please report it by email to:'
    ''
    'Subject: HGR - Data acquistion Software'
    ''
    'Email address:'
    'LABORATORIO DE INVESTIGACION EN INTELIGENCIA Y VISION ARTIFICIAL'
    'laboratorio.ia@epn.edu.ec'
    ''
    'With the screenshot of the error.'
    'Thank you.'};

msgbox(str, 'CONTACT','help');


% --------------------------------------------------------------------
function myoMenu_Callback(hObject, eventdata, handles)
% hObject    handle to myoMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gForceMenu_Callback(hObject, eventdata, handles)
% hObject    handle to gForceMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gForceFigure_Callback(hObject, eventdata, handles)
% hObject    handle to gForceFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imagenGForce();

% --------------------------------------------------------------------
function upG_Callback(hObject, eventdata, handles)
% hObject    handle to upG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('up');

% --------------------------------------------------------------------
function downG_Callback(hObject, eventdata, handles)
% hObject    handle to downG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('down');

% --------------------------------------------------------------------
function leftG_Callback(hObject, eventdata, handles)
% hObject    handle to leftG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('left');

% --------------------------------------------------------------------
function rightG_Callback(hObject, eventdata, handles)
% hObject    handle to rightG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('right');

% --------------------------------------------------------------------
function forwardG_Callback(hObject, eventdata, handles)
% hObject    handle to forwardG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('forward');

% --------------------------------------------------------------------
function backG_Callback(hObject, eventdata, handles)
% hObject    handle to backG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playGif('backward');


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function TempUserText_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function TempUserText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function bloodPressureUserText_Callback(hObject, eventdata, handles)
% hObject    handle to bloodPressureUserText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bloodPressureUserText as text
%        str2double(get(hObject,'String')) returns contents of bloodPressureUserText as a double


% --- Executes during object creation, after setting all properties.
function bloodPressureUserText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bloodPressureUserText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spoUserText_Callback(hObject, eventdata, handles)
% hObject    handle to spoUserText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spoUserText as text
%        str2double(get(hObject,'String')) returns contents of spoUserText as a double


% --- Executes during object creation, after setting all properties.
function spoUserText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spoUserText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wtUserText_Callback(hObject, eventdata, handles)
% hObject    handle to wtUserText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wtUserText as text
%        str2double(get(hObject,'String')) returns contents of wtUserText as a double


% --- Executes during object creation, after setting all properties.
function wtUserText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wtUserText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function htUserText_Callback(hObject, eventdata, handles)

function htUserText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function gestoAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to gestoAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in surveyButton.
function surveyButton_Callback(hObject, eventdata, handles)
% hObject    handle to surveyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    survey;
catch ME
    errordlg(['Error opening application: ' ME.message], 'Application Error');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listOfMyos.
function listOfMyos_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listOfMyos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
