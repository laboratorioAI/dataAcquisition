function varargout = sincronizacion(varargin)
% SINCRONIZACION MATLAB code for sincronizacion.fig
%      SINCRONIZACION, by itself, creates a new SINCRONIZACION or raises the existing
%      singleton*.
%
%      H = SINCRONIZACION returns the handle to a new SINCRONIZACION or the handle to
%      the existing singleton*.
%
%      SINCRONIZACION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINCRONIZACION.M with the given input arguments.
%
%      SINCRONIZACION('Property','Value',...) creates a new SINCRONIZACION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sincronizacion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sincronizacion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sincronizacion

% Last Modified by GUIDE v2.5 19-Jul-2019 13:14:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @sincronizacion_OpeningFcn, ...
    'gui_OutputFcn',  @sincronizacion_OutputFcn, ...
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

% --- Executes just before sincronizacion is made visible.
function sincronizacion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sincronizacion (see VARARGIN)

% Choose default command line output for sincronizacion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

movegui(hObject,'center'); % mostrando en el centro
initWaitbarProSync(handles);


drawnow;


% UIWAIT makes sincronizacion wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sincronizacion_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ...
global isRelease;
global gestureNameSync timeGestureSync numOfRepetitions repetitionNum;


% config
options = syncConfigs(); % configuration now in specified file
gestureNameSync = options.gestureNameSync;
timeGestureSync = options.timeGestureSync;
numOfRepetitions = options.numOfRepetitions;
repetitionNum = 1;


%... debug!
if ~isRelease
    figure1_CloseRequestFcn(hObject, eventdata, handles);
else
    str = 'First, the sync gesture...';
    uiwait(msgbox(str, 'INFORMATION','help'));
    
    handles.sampleNumberText.String = [num2str(repetitionNum) ' / ' num2str(numOfRepetitions)];
end



% --- Executes on button press in recordPushbutton.
function recordPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to recordPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global userData numOfRepetitions repetitionNum;
% userData = loadUserData(userData); % ya no leemos pues todo se graba en
% userData, y no se puede restaurar el proceso
options = syncConfigs();

handles.recordPushbutton.Enable = 'off';
handles.replayPushbutton.Enable = 'off';

%-% Iniciar los timers
%2 + 3*rand;
timeToStartRecording = options.deadTime + options.windowTime*rand;
userData.lastTransitionTime = timeToStartRecording;
timerWaitbar = timerWaitbarSync(handles, timeToStartRecording);
start(timerWaitbar);

%-% Adquirir datos del Myo
timerEMGRecording = timerCollectionSync();
start(timerEMGRecording);
wait(timerEMGRecording);

%-% Desactivar los timers
stop(timerWaitbar);
stop(timerEMGRecording);
delete(timerWaitbar);
delete(timerEMGRecording);
drawnow;

%-% Graficar la señal EMG
plotEMGSync(handles, userData, timeToStartRecording);
drawnow;

%-% Grabar
saveUserData(); % aw graba en el archivo principal userData
drawnow;

%-% Reiniciar el waitbar!
moverWaitbarSync(handles, 0, 0);
repetitionNum = repetitionNum + 1;
if repetitionNum > numOfRepetitions
    % the end
    handles.recordPushbutton.Enable = 'off';
    handles.replayPushbutton.Enable = 'on';
else
    handles.recordPushbutton.Enable = 'on';
    handles.replayPushbutton.Enable = 'on';
    handles.sampleNumberText.String = ...
        [num2str(repetitionNum) ' / ' num2str(numOfRepetitions)];
end

% --- Executes on button press in replayPushbutton.
function replayPushbutton_Callback(hObject, eventdata, handles)
%% hObject    handle to replayPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numOfRepetitions repetitionNum;
repetitionNum = repetitionNum - 1;
if repetitionNum <= 0
    repetitionNum = 1;
end
handles.sampleNumberText.String = ...
    [num2str(repetitionNum) ' / ' num2str(numOfRepetitions)];
handles.recordPushbutton.Enable = 'on';


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
%%
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global numOfRepetitions repetitionNum isRelease;
global userData
if repetitionNum <= numOfRepetitions && isRelease
    str{1} = 'Can"t leave this interface.';
    str{2} = 'Please, complete the samples!';
    msgbox(str,'WARNING','warn');
else
    clearvars -global -except myoObject deviceType gForceObject ...
        userData isRelease;
    userData.counterGesture = 1;
    drawnow
    delete(gcf);
end

function initWaitbarProSync(handles)
%%
waitbarAxesSync = handles.waitbarAxesSync;

% wait bar características!
esfera = scatter(waitbarAxesSync, 0, 0, 'LineWidth', 1);
esfera.MarkerFaceColor = [0 0.25 0.25];
esfera.MarkerEdgeColor = [0 0.5 0.5];
waitbarAxesSync.YLim = [0 1];
waitbarAxesSync.XLim = [0 1];
waitbarAxesSync.XLim = [0 1];
waitbarAxesSync.XMinorGrid = 'on';
waitbarAxesSync.XTickLabel = {};
waitbarAxesSync.XMinorTick = 'on';
waitbarAxesSync.YColor = [1 1 1];
hold(waitbarAxesSync, 'on')
% area
x = [0; 0.001];
Y = [0.5;0.5];
area(waitbarAxesSync, x,Y,...
    'FaceColor', [102, 205, 170] / 255, 'EdgeColor', [32, 178, 170] / 255); % low

function myTimer = timerWaitbarSync(handles, transicion)
%%
global timeGestureSync;

myTimer = timer;
myTimer.ExecutionMode = 'fixedRate';
myTimer.Period = 0.1;

numExecutions = floor(timeGestureSync / 0.1); % depende del tiempo del gesto
myTimer.TasksToExecute = numExecutions;

myTimer.TimerFcn = @(timer, evnt)moverWaitbarSync(handles,timer.TasksExecuted/numExecutions,transicion/timeGestureSync);

function moverWaitbarSync(handles, porcentaje, transicion)
%% porcentaje: 0 a 1
% transicion: valor entre 0 y 1
barra = handles.waitbarAxesSync.Children(1);
esfera = handles.waitbarAxesSync.Children(2);
barra.XData = [0 porcentaje];
esfera.XData = porcentaje;

%-% normal
if porcentaje < transicion
    barra.YData = [0 porcentaje];
    esfera.YData = 0.5;
    esfera.YData = porcentaje;
    barra.FaceColor = [102, 205, 170] / 255; % azul!
    barra.EdgeColor = [32, 178, 170] / 255;
    
else
    barra.YData = [1 1];
    barra.FaceColor = [255, 215, 0] / 255; % amarillo
    barra.EdgeColor = [250, 250, 210] / 255;
    esfera.YData = transicion;
end

%-% conteo
tamText = 20;
colorLetter = [0 0 1];
if porcentaje < transicion / 3
    handles.msjText.String = '3';
    
elseif (porcentaje >= transicion / 3) && (porcentaje < transicion * 2 / 3)
    handles.msjText.String = '2';
    
elseif (porcentaje >= transicion * 2 / 3) && (porcentaje < transicion)
    handles.msjText.String = '1';
    
else
    handles.msjText.String = 'GO!';
    colorLetter = [1 0 0];
    handles.msjText.FontWeight = 'normal';
    tamText = 18;
end

handles.msjText.ForegroundColor = colorLetter;
handles.msjText.FontSize = tamText;
drawnow;

function myTimer = timerCollectionSync()
%%
global timeGestureSync isSync;
isSync = true;
%-% Single shot timer
myTimer = timer('Name', 'Sync Timer');
myTimer.StartFcn = @timerStartCollection;
myTimer.TimerFcn = @timerFuncCollection;
myTimer.StopFcn = @timerStartCollection;
myTimer.StartDelay = timeGestureSync;

% not used anymore!!
% function timerFuncCollectionSync(~, ~)
% %% Stop myo streaming
% global myoObject userData gestureNameSync timeToStartRecording ...
%     repetitionNum deviceType gForceObject;
%
% %--
% switch deviceType
%
%     case DeviceName.myo
%         % # ----- Myo
%         sample = struct('emg', [], 'pose_myo', [], 'rot', [], 'gyro', [],...
%             'accel', [], 'pointGestureBegins', []);
%
%         emgs = myoObject.myoData.emg_log;
%         sample.emg = emgs;
%         sample.pose_myo = myoObject.myoData.pose_log;
%
%         if isempty(sample.emg)
%             errordlg('Myo armband not connected!','CONNECTION ERROR!');
%         end
%
%         if any(sample.pose_myo == 65535)
%             errordlg('Myo Armband hand gesture recognition not working',...
%                 '¡RECOGNITION ERROR (65535)!');
%         end
%
%         sample.rot = myoObject.myoData.rot_log();
%         sample.gyro = myoObject.myoData.gyro_log();
%         sample.accel =  myoObject.myoData.accel_log();
%
%         if ~isequal(gestureNameSync, 'relax')
%             sample.pointGestureBegins = round(timeToStartRecording*200);
%         end
%
%     case DeviceName.gForce
%         % # ----- GForce
%         sample = struct('emg', [], 'quaternions',...
%             [], 'pointGestureBegins', []);
%         % sample.emg = (double(gForceObject.getEmg())'- 127)/128;
%         sample.emg = gForceObject.getEmg()'; %8bits
%         if isempty(sample.emg)
%             errordlg('¡GForce not connected!','CONNECTION ERROR!');
%         end
%
%
%         % if gForceObject.enabledPredictions
%         %     sample.pose_myo = gForceObject.getPredictions();
%         % else
%         %     sample.pose_myo = [];
%         % end
%
%         if gForceObject.enabledQuats
%             sample.quaternions = gForceObject.getOrientation()'; % (4-by-m)'
%         else
%             sample.quaternions = [];
%         end
%
%         if ~isequal(gestureNameSync, 'relax')
%             sample.pointGestureBegins = round(...
%                 timeToStartRecording*gForceObject.emgFreq);
%         end
% end
% %-% Update sample
% userData.gestures.(gestureNameSync).data{repetitionNum,1} = sample;

function plotEMGSync(handles, userData, transicion)
%%
global gestureNameSync timeGestureSync repetitionNum ...
    deviceType gForceObject

%---% current
emgs = userData.gestures.(gestureNameSync).data{repetitionNum,1}.emg;

yMin = -1;
yMax = 1;

if deviceType == DeviceName.gForce
    freq = gForceObject.emgFreq;
else
    optionsRecording = recordingConfigs();
    freq = optionsRecording.myo.emgSamplingRate;
end

xlimit = timeGestureSync * freq;

transSTR = round(transicion * freq);

%-% textos
muestrasAq = length(emgs);
handles.numPointsText.String = num2str(muestrasAq);

options = recordingConfigs();
minSignalLength = options.recording.minSignalLength;
if muestrasAq < minSignalLength/100 * timeGestureSync * freq
    handles.numPointsText.ForegroundColor = [1 0 0];
else
    handles.numPointsText.ForegroundColor = [0 0 1];
end

%-% Plot on axes
for cidx = 1:8
    idxSTR = num2str(cidx);
    ax = handles.(['axes' idxSTR]);
    %     cmd = ['plot(' ax ', emgs(:,' idxSTR '));'];
    %     cmd = [cmd 'xlim(' ax ', [0 xlimit]);'];
    %     cmd = [cmd 'ylim(' ax ', [yMin yMax]);'];
    %     cmd = [cmd 'line([transSTR transSTR],[yMin yMax],''LineWidth'',2'...
    %         ',''Color'',[1 0.8043 0],''Parent'',' ax ');'];
    %     eval(cmd);
    
    plot(ax, emgs(:,cidx));
    xlim(ax, [0 xlimit]);
    ylim(ax, [yMin yMax]);
    line([transSTR transSTR],[yMin yMax],'LineWidth',2 ...
        ,'Color',[1 0.8043 0],'Parent', ax);
end
