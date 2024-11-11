function varargout = restaurar(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @restaurar_OpeningFcn, ...
    'gui_OutputFcn',  @restaurar_OutputFcn, ...
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


% --- Executes just before restaurar is made visible.
function restaurar_OpeningFcn(hObject, eventdata, handles, varargin)
%%
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% loading users!
usuarios = findingUsuarios();
handles.usuariosList.String = usuarios;

handles.usuariosList.Max = 2; % ?
handles.usuariosList.Value = [];
handles.okButton.Enable = 'off';

% --- Outputs from this function are returned to the command line.
function varargout = restaurar_OutputFcn(hObject, eventdata, handles)
%%
varargout{1} = handles.output;
movegui(hObject,'center'); % mostrando en el centro


% --- Executes on selection change in usuariosList.
function usuariosList_Callback(hObject, eventdata, handles)
%%
global theSelected % info about the selected user
%-- usuario elegido!
choosenUsuario = handles.usuariosList.Value;
choosenUsuario = handles.usuariosList.String{choosenUsuario};
theSelected.user = choosenUsuario;

%--- gestos que realizó tal usuario!
[gestosRealizados, repXGestoRealizadas, ~, isDataComplete] = ...
    checkGestos(choosenUsuario);
handles.gestosList.String = gestosRealizados; % poniendo gestos
handles.gestosList.Visible = 'on';
handles.gestosList.Max = 2; % ?
handles.gestosList.Value = [];
handles.okButton.Enable = 'off';

theSelected.repXGestoRealizadas = repXGestoRealizadas;

if isDataComplete
    handles.incompletoText.String = '';
else
    handles.incompletoText.String = 'WARNING, USER WITH INCOMPLETE RECORDINGS';
end


function usuariosList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
%%
global theSelected isValidRestaurar userData

nameUser = theSelected.user;

%---% load userData
filepath = ['.\data\' nameUser '\'];
loadedFile = load([ filepath 'userData.mat']);
userData = loadedFile.userData;
userData.counterGesture = theSelected.gesto;
userData.counterRepetition = theSelected.choosenRep;

% --- limiting reps
userData = loadUserData(userData);

nameGesture = userData.gestures.classes{userData.counterGesture};
dataReps = ...
    userData.gestures.(nameGesture).data(1:userData.counterRepetition);

% eliminatingOtherfiles(); % not implemented
saveUserData(); % updating counters!
userData.gestures.(nameGesture).data = dataReps; % ya que saveuser elimina las reps

isValidRestaurar = true; % flag to tell whether restauration is valid
clearvars -global -except isValidRestaurar ...
    userData myoObject deviceType gForceObject

delete(gcf)
drawnow
function gestosList_Callback(hObject, eventdata, handles)
%%
global theSelected
repXGestoRealizadas = theSelected.repXGestoRealizadas;

%--% gesto elegido!
choosenGesto = handles.gestosList.Value;
theSelected.gesto = choosenGesto;

%--% repeticiones que realizó tal usuario!
repVector = strsplit(num2str(1:repXGestoRealizadas(choosenGesto)),' ');
handles.repList.String = repVector;
handles.repList.Max = 2;
handles.repList.Value = [];
handles.okButton.Enable = 'off';
handles.repList.Visible = 'on';



% --- Executes during object creation, after setting all properties.
function gestosList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in repList.
function repList_Callback(hObject, eventdata, handles)
%%
global theSelected
%--% gesto elegido!
choosenGesto = handles.gestosList.Value;
theSelected.gesto = choosenGesto;
repXGestoRealizadas = theSelected.repXGestoRealizadas;

%--% muestra elegida!
if ~isempty(repXGestoRealizadas(choosenGesto))
    handles.okButton.Enable = 'on';
    choosenRep = handles.repList.Value;
    theSelected.choosenRep = choosenRep;
end

% --- Executes during object creation, after setting all properties.
function repList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
