function varargout = listaRecolectoresDatos(varargin)
% LISTARECOLECTORESDATOS MATLAB code for listaRecolectoresDatos.fig
%      LISTARECOLECTORESDATOS, by itself, creates a new LISTARECOLECTORESDATOS or raises the existing
%      singleton*.
%
%      H = LISTARECOLECTORESDATOS returns the handle to a new LISTARECOLECTORESDATOS or the handle to
%      the existing singleton*.
%
%      LISTARECOLECTORESDATOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LISTARECOLECTORESDATOS.M with the given input arguments.
%
%      LISTARECOLECTORESDATOS('Property','Value',...) creates a new LISTARECOLECTORESDATOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before listaRecolectoresDatos_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to listaRecolectoresDatos_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help listaRecolectoresDatos

% Last Modified by GUIDE v1.7 21-Jun-2024 ‏‎2:05:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @listaRecolectoresDatos_OpeningFcn, ...
    'gui_OutputFcn',  @listaRecolectoresDatos_OutputFcn, ...
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


% --- Executes just before listaRecolectoresDatos is made visible.
function listaRecolectoresDatos_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to listaRecolectoresDatos (see VARARGIN)

%- Choose default command line output for listaRecolectoresDatos
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

movegui(hObject,'center'); % mostrando en el centro
global lista;
[encabezado, lista, num] = crearListadeRecolectoresDeDatos();
str = cell(num + 1, 1);
str{1} = encabezado;
for i = 2:(num + 1)
    str{i} = lista(i - 1).name;
end
% str{num + 2} = 'My name is not here';
set(handles.listaRecolectoresPopMenu, 'String', str);


% --- Outputs from this function are returned to the command line.
function varargout = listaRecolectoresDatos_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listaRecolectoresPopMenu.
function listaRecolectoresPopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to listaRecolectoresPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listaRecolectoresPopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listaRecolectoresPopMenu

% --- Executes during object creation, after setting all properties.
function listaRecolectoresPopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listaRecolectoresPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in aceptarPushbutton.
function aceptarPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to aceptarPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lista nombreRecolectorDeDatos;
valor = get(handles.listaRecolectoresPopMenu, 'Value');
if valor == 1 % No se selecciona un nombre
    str = {'Choose a name from the list'};
    uiwait(msgbox(str,'WARNING','warn'));
else
    % popMenuList = get(handles.listaRecolectoresPopMenu, 'String');
    delete(gcf);
    entrenamiento();
    nombreRecolectorDeDatos = lista(valor - 1);
    % qstring{1} = 'You selected:';
    % qstring{2} = '';
    % qstring{3} = upper(lista(valor - 1).name);
    % qstring{4} = '';
    % qstring{5} = '¿Is it right?';
    % choice = questdlg(qstring,'Data collector',...
    %     'Yes','No','Yes');
    % 
    % if strcmpi(choice,'Yes')
    %     delete(gcf);
    %     entrenamiento();
    % end
    
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global nombreRecolectorDeDatos;

qstring = 'Are you sure to leave this program?';
choice = questdlg(qstring,'Exit',...
    'YES','NO','NO');
if strcmpi(choice,'YES')
    nombreRecolectorDeDatos = [];
    delete(gcf);
end
