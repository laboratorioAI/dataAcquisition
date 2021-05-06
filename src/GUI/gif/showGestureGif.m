function showGestureGif(handles, gestureName)
%showGestureGif runs a number of execution of a Gif of a gesture. Then it
%displays an image.
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

handles.msjText.String = 'Watch carefully the gif.';

%% config
options = configs();
gifName = [options.gifsPath gestureName '.gif'];

[gif, cmap] = imread(gifName, 'Frames', 'all');
numFrames = size(gif, 4); % only 4th dim

thisFrame = gif(:,:,:, 1);
% thisRGB = uint8(255 * ind2rgb(thisFrame, cmap));
gifPlot = imshow(thisFrame, 'Parent', handles.gestoAxes);
colormap(handles.gestoAxes, cmap)

%% getting gif delay
gifinfo = imfinfo(gifName);
% the delayTime is in hundreds of second
gifPeriod = mean([gifinfo.DelayTime])/100;

%% loop gif
options = gifConfigs();
for i = 1:options.numberOfGifRepetitions
    
    for k = 1:numFrames
        a = tic;
        %         thisFrame = gif(:,:,:,k);
        %         thisRGB = uint8(255 * ind2rgb(thisFrame, cmap));
        
        %         gifPlot.CData = thisRGB;
        gifPlot.CData = gif(:,:,:,k);
        
        while toc(a) < gifPeriod
            drawnow;
        end
    end
end

%% image
options = configs();

imgName = [options.imgFolder gestureName '.jpg'];

[img, cmap] = imread(imgName);

cla(handles.gestoAxes);
imshow(img, 'Parent', handles.gestoAxes);
colormap(handles.gestoAxes, cmap)
handles.msjText.String = '';
drawnow
end

