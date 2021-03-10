function saveUserData()
global userData;
% saveUserData es la función que gestiona el guardar archivos tanto de la
% recolección normal como la añadida del gesto sync.
%IMPORTANTE: esta función cambia de funcionamiento al ya no grabar los
%datos de todos los gestos en un archivo, si no que genera un archivo por
%gesto, para luego ser todos recopilados.
% este archivo es significativamente más ligero que en la versión anterior
% pues solo graba las repeticiones y ya!
%En el caso de sync graba las repeticiones en el archivo base. ie no crea
%un archivo sync de usuario.

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

Modified: 23 February 2021
Matlab 9.9.0.1592791 (R2020b) Update 5.
%}

%% Get info
username = userData.userInfo.username;

%% Save gestureData
filepath = ['.\data\' username '\'];
if ~isfolder(filepath)
    mkdir(filepath);
end

%% which gesture
if userData.counterGesture == 0
    % ie sync gesture. igual q antes
else
    %% Saving by gesture, and then in another time combine
    gestosRealizados = userData.gestures.classes;
    nameGesture = gestosRealizados{userData.counterGesture};
    
    reps.(nameGesture) = userData.gestures.(nameGesture);
    userData.gestures.(nameGesture).data = [];
    save([filepath nameGesture '.mat'], 'reps');
end

% se usa userData como archivo ligero de contadores
save([filepath 'userData.mat'], 'userData'); 
end
