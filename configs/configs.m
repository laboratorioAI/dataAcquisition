function options = configs()
%configs to store general configs.
%
% Outputs
%   options     -struct with fields
%
% Ejemplo
%    = configs()
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

05 May 2021
Matlab 9.9.0.1592791 (R2020b) Update 5.
%}


%%  software
options.version = '1.5';


%% paths
options.gifsPath = '.\gifs\the11Gestures\';
options.imgFolder = '.\images\';

%% username changes
% letters to replace to avoid any character encoding conflict
% optimised for spanish!
% old;new
options.replaces = {
    'á', 'é', 'í', 'ó', 'ú', 'ü', 'ñ', 'Á', 'É', 'Í', 'Ó', 'Ú', 'Ü', 'Ñ'
    'a', 'e', 'i', 'o', 'u', 'u', 'nh', 'A', 'E', 'I', 'O', 'U', 'U', 'Nh'};

% %% example
% r = options.replaces ;
% name = 'jÓnAñZÁé';
% for i = r
%     name = strrep(name, i{1},i{2});
% end
% name