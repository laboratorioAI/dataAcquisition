function isConnectedGForce = connectGForce()
%connectGForce handles the connection with the GForce Pro device. This
%funcion requires that GForce class is added to the proyect.
%
% Inputs
%
% Outputs
%   isConnectedGForce   bool true when connected
%
% Example
%    connectGForce()
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

%% Checking that gForce_mex is added to the path
switch exist('gForce_mex', 'file')
    case 3
        disp('Mex function correctly found!')
    otherwise
        warning('Mex function "gForce_mex" not found. Check that it is compiled and added to the path.')
        isConnectedGForce = false;
        return
end
%%
global gForceObject

profile = 'emgFastLow'; % check predefined profiles regarding GForce class.
options = config_GForce(profile);
try
    gForceObject = GForce(options);
    isConnectedGForce = gForceObject.isConnected;
catch
    isConnectedGForce = false;
end

