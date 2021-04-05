function initGestureGif(handles, gestureName)
%initGestureGif--- legacy, old function to display continuosly a gif during
%the data acquisition altogether with gifControl. NOT USED ANYMORE.
%
% Inputs
% *handles      - guide handles %gestoAxes, es el axes
% *gestureName  - char with the name of the gesture
%
% Outputs
%

%{
Laboratorio de Inteligencia y Visión Artificial
ESCUELA POLITÉCNICA NACIONAL
Quito - Ecuador

autor: ztjona!
jonathan.a.zea@ieee.org
Cuando escribí este código, solo dios y yo sabíamos como funcionaba.
Ahora solo lo sabe dios.

"I find that I don't understand things unless I try to program them."
-Donald E. Knuth

09 February 2021
Matlab 9.9.0.1538559 (R2020b) Update 3.
%}

nameTimer = 'gifTimer';
%% stoping previously if any, timer!
t1 = timerfind('Name', nameTimer);
if ~isempty(t1)
    stop(t1);
    delete(t1)
end
%% config
gifName = ['.\gifs\the11Gestures\' gestureName '.gif'];

[gifImage, cmap] = imread(gifName, 'Frames', 'all');
numImages = size(gifImage, 4); % only 4th dim

thisFrame = gifImage(:,:,:, 1);
thisRGB = uint8(255 * ind2rgb(thisFrame, cmap));
gif = imshow(thisRGB, 'Parent', handles.gestoAxes);

%% parallel op with timer!
gifTimer = timer('ExecutionMode', 'fixedSpacing','BusyMode','drop'...
    , 'Name', nameTimer, ...
    'Period', 0.1);
gifTimer.TimerFcn =  @giffing;
gifTimer.UserData.k = 1;
drawnow
start(gifTimer)


    function obj = giffing(obj, ~)
        % giffing timer function that plots a gif in "parallel"
        %
        % Inputs
        % *gifName      -char with the name
        %
        
        %%
        
        k = obj.UserData.k;
        % Despliega el gif en forma de video
        
        k = mod(k + 1, numImages);
        if k == 0
            k = numImages;
        end
        obj.UserData.k = k;
        thisFrame = gifImage(:,:,:,k);
        thisRGB = uint8(255 * ind2rgb(thisFrame, cmap));
        
        gif.CData = thisRGB;
        
        drawnow;
        
    end
end

