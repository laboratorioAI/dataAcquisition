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

04 February 2021
Matlab 9.9.0.1538559 (R2020b) Update 3.
%}

%-- Input Validation
arguments
    deviceType            (1, 1) DeviceName
end

%-- listing
switch deviceType
    case DeviceName.myo
        listDevices = {'Myo-EPN-Marco Benalcázar'
            'Myo-Personal-Marco Benalcázar'
            'Myo-EPN-Lorena Barona'
            'Myo-UDLA-Lorena Barona'
            'Myo-UDLA-Leonardo Valdivieso'
            'Myo-EPN-Leonardo Valdivieso'
            'Myo-UTA-Rubén Nogales'
            'Myo-UTA-Freddy Benalcázar'
            'Myo-UTA-Jaime Guilcapi'
            'Myo-ESPE-Marcelo Álvarez'
            };
    case DeviceName.gForce
        listDevices = {'gForce_1'
        'gForce_2'
        'gForce_3'
        'gForce_4'
        'gForce_5'
            };
end
