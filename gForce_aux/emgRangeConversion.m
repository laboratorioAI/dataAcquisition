function emgData = emgRangeConversion(emgData)
%emgRangeConversion converts the uint8 Emg to the range [-1, 1]. It is
%alinear conversion with a fixed reference.
%
% Inputs
%   emgData     uint8 (:,:) Emg input matrix in the range 0-255.
%
% Outputs
%   emgData     double (:,:) Emg output matrix in the range [-1,1].
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

global gForceObject
options = config_GForce();

%% checking ADC resolution
maxVal = 255; % prealloc 8 bits
if isempty(gForceObject)
    % no gForceObject
    if isa(emgData, 'uint8')
        ref = options.ref8bits;
    else
        maxVal = 4095;
        ref = options.ref12bits;
    end
    
else
    % with gForceObject
    if gForceObject.emgResolution == 8
        ref = options.ref8bits;
    else
        maxVal = 4095;
        ref = options.ref12bits;
    end
end
%% conversion
emgData = double(emgData) - ref;
emgData = emgData / max(maxVal - ref, ref);
% so the side with the larger num of elements is converted to [0, |1|]
