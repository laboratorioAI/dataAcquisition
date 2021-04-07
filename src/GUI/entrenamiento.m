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
    
    if toc(a) > 2*userData.extraInfo.timePerRepetition
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
    uiwait(errordlg('No se recibió datos del dispositivo!', '¡Error!', 'modal'));
    msgbox({'Intente grabar nuevamente la repetición.',...
        '',...
        'De seguir sucediendo el error:',...
        '   1. Reinicie el dispositivo',...
        '   2. Revise la batería',...
        '   3. Reconecte el dongle USB',...
        '   4. Reinicie matlab'},'Conexión','help', 'modal')
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
    uiwait(warndlg('Pocos datos recibidos, por favor repita.', ...
        'Error en la transmisión', 'modal'));
    
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
global userData nombreRecolectorDeDatos isRelease; %
% Validación de datos
[isDataValid, msjPrint] = validacionDatos(handles);
if isDataValid
    % desahabilitar
    bloquearGUI(handles);
    
    drawnow
    
    %-% Get data from GUI
    userData = getUserDataFromHandles(handles);
    
    %-% Start counters
    userData.counterGesture = 0; % debido al infame sync gesture
    userData.counterRepetition = 1;
    
    %-% Recolector de datos
    userData.personWhoRecordedData = nombreRecolectorDeDatos;
    
    %-% save!
    createUserData(userData); % creando archivos
    % saveUserData();
    
    waitingFoto(userData.userInfo.username); % loop that waits until foto
    drawnow
    
    %-% GUI
    if isequal(userData.userInfo.gender,'Mujer')
        handles.bienvenidoText.String = ['Bienvenida ' userData.userInfo.username];
    else
        handles.bienvenidoText.String = ['Bienvenido ' userData.userInfo.username];
    end
    countGesture = 1; % muestro el primer gesto
    firstGesture = userData.gestures.classes{1};
    repXClass = userData.gestures.repXClass;
    handles.repeticionesText.String = [num2str(userData.counterRepetition) '/' num2str(repXClass(countGesture))];
    
    handles.tituloGestoText.String = firstGesture;
    
    %dibujarImagen(handles, firstGesture);
    showGestureGif(handles, firstGesture);
    drawnow
    
    % infame sync
    if isRelease
        %-% Recolectar datos de sincronización
        handles.msjText.String = 'Esperando adquisición de syncs';
        uiwait(sincronizacion); % debe terminar correctamente, si no muere!
        str = 'Continuamos con la adquisición de datos.';
        uiwait(msgbox(str, 'INFORMACIÓN','help'));
        drawnow
    end
    handles.msjText.String = '';
    
    % only enabling buttons
    handles.grabarButton.Enable = 'on';
    handles.repetirButton.Visible = 'on';
    drawnow
else
    handles.msjText.String = {'DATOS NO VÁLIDOS', msjPrint};
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
uiwait(warndlg({'La conexión con GForce Pro todavía está en versión beta.', ...
    '¡Permanezca atento!', 'Es posible que la comunicación se interrumpa.', ...
    '', 'Se recomienda usar el dispositivo completamente cargado.'},...
    'ADVERTENCIA', 'modal'));

global deviceType gForceObject
handles.msjText.String = {'Conectando con GForce.', ...
    'Este proceso puede tardar unos minutos.', ...
    'Por favor, espere...'};
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
    
    %-% battery
    bat = gForceObject.getBattery();
    gForceObject.vibrate();
    drawnow
    handles.bat_txt.String = sprintf('%d %%',bat);
    
    if bat >= 80
        handles.bat_txt.ForegroundColor = [0.39 0.83 0.07];
    elseif bat > 60
        handles.bat_txt.ForegroundColor = [0.93 0.69 0.13];
    elseif bat > 0
        handles.bat_txt.ForegroundColor = 'red';
    else
        handles.bat_txt.ForegroundColor = 'black';
    end
    
    
    %-% parámetros de inicio!
    handles.msjText.String = 'Configure los parámetros de adquisición y pulse EMPEZAR';
    handles.empezarEntrenamientoButton.Enable = 'on';
    handles.restaurarButton.Enable = 'on';
    
    %-% disabling myo button
    handles.connectGForce_Button.Enable = 'off';
    handles.connectMyo_Button.Enable = 'off';
    
    %-% devices
    handles.listOfMyos.String = devices(deviceType);
else
    handles.msjText.String = '¡No se pudo conectar GForce con Matlab!';
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
handles.msjText.String = 'CONECTANDO, ESPERE...';
% isConnectedMyo = connectFakeMyo();
isConnectedMyo = connectMyo();

if isConnectedMyo
    deviceType = DeviceName.myo;
    ledConexion(handles, true);
    
    %-% parámetros de inicio!
    handles.msjText.String = 'Configure los parámetros de adquisición y pulse EMPEZAR';
    handles.empezarEntrenamientoButton.Enable = 'on';
    handles.restaurarButton.Enable = 'on';
    
    %-% disabling gForce_ button
    handles.connectGForce_Button.Enable = 'off';
    handles.connectMyo_Button.Enable = 'off';
    handles.bat_txt.String = '-';
    
    %-% devices
    handles.listOfMyos.String = devices(deviceType);
else
    handles.msjText.String = '¡CONECTE EL MYO CON MATLAB!';
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
    errordlg('Edad Incorrecta', 'Error', 'modal')
end

function edadText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function perimetroText_Callback(hObject, eventdata, handles)
perimetro = str2double(handles.perimetroText.String);
if ~isnumeric(perimetro)
    handles.perimetroText.String = '';
    errordlg('núm Incorrecto', 'Error', 'modal')
end

function perimetroText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cubCodoText_Callback(hObject, ~, handles)
cubCodo = str2double(handles.cubCodoText.String);
if ~isnumeric(cubCodo)
    handles.cubCodoText.String = '';
    errordlg('núm Incorrecto', 'Error', 'modal')
end

function cubCodoText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function codMyoText_Callback(hObject, eventdata, handles)
codMyo = str2double(handles.codMyoText.String);
if ~isnumeric(codMyo)
    handles.codMyoText.String = '';
    errordlg('núm Incorrecto', 'Error', 'modal')
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
handles.msjText.String = {'Esperando continuar desde punto de restauración'
    'Por favor, espere...'};
drawnow
uiwait(restaurar); % busca usuario y actualiza punto de grabado!

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
pregunta = questdlg('¿Está seguro que quiere repetir la última muestra?', ...
    'CONFIRMAR','SI', 'NO', 'SI');

if isequal(pregunta,'SI')
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
% hObject    handle to ocupacionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ocupacionText as text
%        str2double(get(hObject,'String')) returns contents of ocupacionText as a double


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
str(1) = {'Adquisición de Señales Electromiográficas (EMG) del Brazo Humano'};
str(2) = {''};
str(3) = {'Versión 3 atualizada por Jonathan Zea'};
str(4) = {'Reconocimiento de Gestos'};
str(5) = {'Laboratorio de Investigación en Inteligencia y Visión Artificial'};
str(6) = {'Revisión 1: 09 de julio de 2019'};
str(7) = {'Revisión 2: 20 de julio de 2019'};
str(8) = {'Revisión 3: 20 de agosto de 2019'};
str(8) = {'Revisión 4: 3 de febrero de 2021'};
str(9) = {''};
str(10) = {'Versión 1 creada por el Ing. Jonathan Zea y el Ing. Cristhian Motoche'};
str(11) = {'Agosto de 2018'};
msgbox(str,'ACERCA DE...','help');

% --------------------------------------------------------------------
function myoDiagnostics_Callback(hObject, eventdata, handles)
% hObject    handle to myoDiagnostics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = {'Asegúrese que el receptor bluetooth del Myo esté conectado al PC.'};
uiwait(msgbox(str,'AVISO','help'));
web('http://diagnostics.myo.com/');


% --------------------------------------------------------------------
function internetBrowser_Callback(hObject, eventdata, handles)
% hObject    handle to internetBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = {'Asegúrese de tener conexión a Internet.'};
uiwait(msgbox(str,'AVISO','help'));
web('https://www.google.com/');

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
playGif('waveOut');

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
str{1} = 'INSTRUCCIONES PARA LA ADQUISICIÓN DE DATOS';
str{2} = '';
str{3} = '1. Revisar el nivel de batería del brazalete seleccionado.';
str{4} = '2. Limpiar el antebrazo del usuario con alcohol.';
str{5} = '3. Colocar el brazalete en el antebrazo derecho del usuario.';
str{6} = '4. Sincronizar el brazalete.';
str{7} = '5. Realizar el “Diagnóstico del Myo en la Web.” (en caso de usar brazalete Myo).';
str{8} = '6. Conectar con Maltab.';
str{9} = '7. Ingresar los datos del usuario.';
str{10} = '8. Tomar una fotografía del antebrazo vistiendo el brazalete.';
str{11} = '9. Realizar la adquisición de datos.';
str{12} = '10. Apagar el brazalete.';
str{13} = '11. Limpiar los electrodos del brazalete con alcohol y algodón.';

str{14} = '';
str{15} = 'En caso de error, se debe reiniciar matlab, apagar y prender nuevamente el brazalete.';
msgbox(str, 'INSTRUCCIONES','help');

% --------------------------------------------------------------------
function contactInformation_Callback(hObject, eventdata, handles)
% hObject    handle to contactInformation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str{1} = 'INFORMACIÓN PARA CONTACTO';
str{2} = '';
str{3} = 'En el que caso que detecte algún error en este programa';
str{4} = 'por favor repórtelo vía email con los siguientes datos:';
str{5} = '';
str{6} = 'Asunto: HGR - Software Adquisición Datos';
% str{6} = 'Asunto: CEPRA2019 - Software Adquisición Datos';
str{7} = '';
str{8} = 'Direcciones de email:';
str{9} = 'marco.benalcazar@epn.edu.ec';
str{10} = 'lorena.barona@epn.edu.ec';
str{11} = 'angel.valdivieso@epn.edu.ec';
str{12} = '';
str{13} = 'Por favor, no olvide identificarse e indicar su institución.';
str{14} = '';
str{15} = 'Finalmente, recomendamos enviar una captura de pantalla que';
str{16} = 'permita visualizar el error o problema en cuestión.';
msgbox(str, 'CONTACTO','help');


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
