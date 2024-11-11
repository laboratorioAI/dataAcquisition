function options = syncConfigs()
%syncConfigs returns a struct with the options for sync gesture
%
% Inputs
%
% Outputs
% * options         -struct with fields
% 
% Ejemplo
%   options = syncConfigs()
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

27 January 2021
Matlab 9.9.0.1538559 (R2020b) Update 3.
%}

%{
Last version 1.8 by Alexander M.
23-Sep-2024
"The question is not whether machines think, but whether they do it better
than humans."
%}
%% 
options.gestureNameSync = 'sync';
options.timeGestureSync = 5;
options.numOfRepetitions = 1;
% options.timeGestureSync = 1;
% options.numOfRepetitions = 2;

% waiting time [s]
options.deadTime = 2; % waiting time before msg
options.windowTime = 3; % last possible initial time

% hence max time gesture 8seg
% min tam 5