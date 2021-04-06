function transitionTime  = getStartingTime(nameGesture, timeRep)
%getStartingTime() returns the time (in seconds) to start the recording
%depending on the name of the gesture. The old gestures have a random
%initial time, the new gestures all starts at time 1.
%
% Inputs
%   nameGesture        -char with the name of the gesture
%   timeRep             -double, seconds of the rep
%
% Outputs
%   transitionTime      -double, time in seconds to start recording signal
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

05 April 2021
Matlab 9.9.0.1592791 (R2020b) Update 5.
%}

%% Input Validation
arguments
    nameGesture        (1, :) char
    timeRep             (1, 1)
end

%%
options = recordingConfigs();
oldGestures = options.gestures.oldGestures;
for kGesture = oldGestures
    if isequal(nameGesture, kGesture{1})
        % starting at random time
        value = rand(); % 0-1
        minTime = options.recording.minStarting*timeRep/100;
        maxTime = options.recording.maxStarting*timeRep/100;
        transitionTime = value*(maxTime - minTime) + minTime;
        return;       
    end
end
% else
% starting at fixed value
transitionTime = options.recording.fixedStarting;
