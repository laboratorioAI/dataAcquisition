function options = gifConfigs()
% gifConfigs returns a structure with the parameters of the gif.
%
% Outputs
% * options -struct with fields
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

%}

%%
% the number of times the gif will be repeted before continuing with the
% acquisition
options.numberOfGifRepetitions = 2;
% options.numberOfGifRepetitions = 0;

% seconds that each frame of the gif is displayed
% NOT USED, gif delay is used instead
% options.gifPeriod = 0.1;