function varargout = imagenGForce(varargin)
% IMAGENGFORCE MATLAB code for imagenGForce.fig
%      IMAGENGFORCE, by itself, creates a new IMAGENGFORCE or raises the existing
%      singleton*.
%
%      H = IMAGENGFORCE returns the handle to a new IMAGENGFORCE or the handle to
%      the existing singleton*.
%
%      IMAGENGFORCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGENGFORCE.M with the given input arguments.
%
%      IMAGENGFORCE('Property','Value',...) creates a new IMAGENGFORCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imagenGForce_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imagenGForce_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imagenGForce

% Last Modified by GUIDE v2.5 03-Feb-2021 11:27:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imagenGForce_OpeningFcn, ...
                   'gui_OutputFcn',  @imagenGForce_OutputFcn, ...
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


% --- Executes just before imagenGForce is made visible.
function imagenGForce_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imagenGForce (see VARARGIN)

% Choose default command line output for imagenGForce
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes imagenGForce wait for user response (see UIRESUME)
% uiwait(handles.figure1);
movegui(hObject,'center') % mostrando en el centro
imgMyo = imread('images\gForce\gForce.jpg'); % leyendo imagen;
imshow(imgMyo, 'Parent', handles.myoImg);


% img2 = imread('images\gForce\howToGForce.png'); % leyendo imagen;
% imshow(img2, 'Parent', handles.axesHowTo);


drawnow

% --- Outputs from this function are returned to the command line.
function varargout = imagenGForce_OutputFcn(hObject, eventdata, handles) 
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
