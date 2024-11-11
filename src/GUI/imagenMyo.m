function varargout = imagenMyo(varargin)
% IMAGENMYO MATLAB code for imagenMyo.fig
%      IMAGENMYO, by itself, creates a new IMAGENMYO or raises the existing
%      singleton*.
%
%      H = IMAGENMYO returns the handle to a new IMAGENMYO or the handle to
%      the existing singleton*.
%
%      IMAGENMYO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGENMYO.M with the given input arguments.
%
%      IMAGENMYO('Property','Value',...) creates a new IMAGENMYO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imagenMyo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imagenMyo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imagenMyo

% Last Modified by GUIDE v2.5 09-Jul-2019 05:09:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imagenMyo_OpeningFcn, ...
                   'gui_OutputFcn',  @imagenMyo_OutputFcn, ...
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


% --- Executes just before imagenMyo is made visible.
function imagenMyo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imagenMyo (see VARARGIN)

% Choose default command line output for imagenMyo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes imagenMyo wait for user response (see UIRESUME)
% uiwait(handles.figure1);
movegui(hObject,'center') % mostrando en el centro
axes(handles.myoImg);
imgMyo = imread('images\Myo.png'); % leyendo imagen;
image(imgMyo);
axis off;

% --- Outputs from this function are returned to the command line.
function varargout = imagenMyo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cerrarButton.
function cerrarButton_Callback(hObject, eventdata, handles)
% hObject    handle to cerrarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
