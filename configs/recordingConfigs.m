function options = recordingConfigs()
%recordingConfigs returns options (i.e. a struct with fields) for the
%recording of gestures.
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


%% 
% the old starts at a random time
options.gestures.oldGestures = {'fist', 'waveIn', 'waveOut', 'open', 'pinch'};

options.gestures.newGestures = {'up', 'down', 'forward', 'backward', 'left', 'right'};

% when random starting, 20% of a 5 seconds rep means that the gesture
% should start at  5*20/100 = 1 second
options.recording.minStarting = 16; % in percentage. For a 5s rep, means 0.8s
options.recording.maxStarting = 65; % in percentage. For a 5s rep means at 3.25s

options.recording.fixedStarting = 20; % in percentage. For a 5s rep, means 1s

options.recording.minSignalLength = 90; % in percentage

%% samplings
options.myo.emgSamplingRate = 200;
% options.gForce.emgSamplingRate = ; % configurable
options.quaternionsSamplingRate = 50; % fixed for both devices