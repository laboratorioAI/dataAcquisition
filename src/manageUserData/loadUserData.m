function userData = loadUserData(userData)
% loadUserData es la función que carga los datos del usuario y además, las
% repeticiones del gesto actual! La información del gesto actual se graba
% en userData. La información de los gestos se graba en un archivo por
% gesto.
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

23 February 2021
Matlab 9.9.0.1592791 (R2020b) Update 5.
%}

%% Get info
username = userData.userInfo.username;
filepath = ['.\data\' username '\'];

gestosRealizados = userData.gestures.classes;
nameGesture = gestosRealizados{userData.counterGesture};

%% updating the gestureData
fileName = [filepath nameGesture '.mat'];
if isfile(fileName)
    dataReps = load(fileName, 'reps');
    userData.gestures.(nameGesture) = dataReps.reps.(nameGesture);
% else
%     userData.gestures.(nameGesture) = {};
end
% no leemos el userData principal!
end