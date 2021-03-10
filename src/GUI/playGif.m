function varargout = playGif(varargin)
% PLAYGIF MATLAB code for playGif.fig
%      PLAYGIF, by itself, creates a new PLAYGIF or raises the existing
%      singleton*.
%
%      H = PLAYGIF returns the handle to a new PLAYGIF or the handle to
%      the existing singleton*.
%
%      PLAYGIF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYGIF.M with the given input arguments.
%
%      PLAYGIF('Property','Value',...) creates a new PLAYGIF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before playGif_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to playGif_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help playGif

% Last Modified by GUIDE v2.5 18-Jul-2019 23:38:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @playGif_OpeningFcn, ...
    'gui_OutputFcn',  @playGif_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

global filename;
if nargin == 1
    filename = varargin{1};
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


% --- Executes just before playGif is made visible.
function playGif_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to playGif (see VARARGIN)

% Choose default command line output for playGif
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% axes(handles.axes1);
imshow(ones(150,250,3), 'Parent', handles.axes1);
% axis off;
drawnow;

% --- Outputs from this function are returned to the command line.
function varargout = playGif_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
movegui(hObject,'center'); % mostrando en el centr
play(hObject, eventdata, handles);
drawnow
% --- Executes on button press in replayPushbutton.
function replayPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to replayPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play(hObject, eventdata, handles);

% --- Executes on button press in closePushbutton.
function closePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to closePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(gcf);

function play(hObject, eventdata, handles)
global filename;
set(handles.gestureName, 'String', upper( filename )); 
axes(handles.axes1);
% fullname = fullfile('gifs',[filename '.gif']);
fullname = ['.\gifs\the11Gestures\' filename '.gif'];
[gifImage, cmap] = imread(fullname, 'Frames', 'all');
gifDraw = imshow(gifImage(:,:,:,1));
colormap(cmap)
[rows, columns, numColorChannels, numImages] = size(gifImage);
drawnow
% Despliega el gif en forma de video
for k = 1 : numImages
    try
        if get(handles.closePushbutton,'userdata') % stop condition
            break;
        end
    catch
        break;
    end
    gifDraw.CData = gifImage(:,:,:,k);
    
%     thisFrame = gifImage(:,:,:,k);
%     thisRGB = uint8(255 * ind2rgb(thisFrame, cmap));
%        thisRGB = image(ind2rgb(thisFrame, cmap));
%     imshow(thisRGB);
    drawnow;
end

