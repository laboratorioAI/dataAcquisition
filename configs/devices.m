function listDevices = devices(deviceType)
%devices returns the list of devices for every kind
%
% Inputs
%*deviceType    -DeviceName (myo or gForce)
%
% Outputs
%*listDevices   -cell with chars
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

%-- Input Validation
arguments
    deviceType            (1, 1) DeviceName
end

%-- listing
excel = readcell(configs("devicesFilename"));

listDevices.myo = {};
listDevices.gForce = {};

for i = 2:size(excel, 1) % ignoring header
    dev_type = excel{i, 3};

    listDevices.(dev_type){end + 1, 1} = excel{i, 2};
end

listDevices = listDevices.(char(deviceType)); % filtering
