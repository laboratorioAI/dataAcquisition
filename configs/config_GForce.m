function options = config_GForce(configProfile)
%config_GForce returns a struct with the parameters of the GForce device
%for a given profile. This function contains predefined profiles to
%configure the GForce. These profiles are used by GForce class at
%constructor.
%
% Inputs
%   configProfile       char with the name of the configuration profile.
%                       Depending on the profile a different configuration
%                       is returned.
%
% Outputs
%   options         struct with fields
%
% Ejemplo
%   options = config_GForce('onlyEmg')
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

20 January 2021
Matlab 9.9.0.1538559 (R2020b) Update 3.
%}

%% Input Validation
arguments
    configProfile (1, :) char = 'default';
end

%% default values
% center value must be 128 or 2048 (at 12bits), but...
options.ref8bits = 118;
options.ref12bits = 2000;

%% profile
switch configProfile
    case 'emgFastLow'
        options.emgResolution = 8; % 8 or 12
        options.enabledQuats = true;
        options.emgFreq = 500;
        options.verbose = 0; % 0 no, 1 yes
        
    case 'onlyEmg'
        options.emgResolution = 8; % 8 or 12
        options.enabledQuats = false;
        options.emgFreq = 1000;
        options.verbose = 0; % 0 no, 1 yes
    case 'default'
        
    otherwise
        error(['Profile "' configProfile '" not defined'])
end
