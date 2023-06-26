function param = configs(name_field)
%configuration file to store general configs.
%
% Outputs
%   param     -struct with fields || param.name_field or it returns the
%               desired field. 
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

%}

% -------- avoiding duplicated initialization
persistent options
if ~isempty(options)
    % already created!
    if nargin == 1
        % requires 1 specific field
        if isfield(options, name_field)
            param = options.(name_field);
        else
            warning('field %s not found', name_field)
            % returns all
            param = options;
        end

    elseif nargin == 0
        % everything
        param = options;
    end
    return;
end

%%  software
options.version = '1.5.1';

%% gesture selection
options.select_gesture = true; 
% when false, does not display the Gesture Selector app

% default options for gesture_setup when options.select_gesture is false
options.gesture_setup.gesture_set = GestureSet.G5;
options.gesture_setup.include_sync = false;

%% paths
options.gifsPath = '.\gifs\the11Gestures\';
options.imgFolder = '.\images\';

%% file names
options.devicesFilename = 'list of devices.xlsx';
options.collectorsFilename = 'list of recollectors.xlsx';

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

%% Getting specific field
if nargin == 1
    if isfield(options, name_field)
        param = options.(name_field);
    else
        error('in property %s', name_field)
    end
elseif nargin == 0
    param = options;
end
