function [] = createUserData(userData)
%createUserData is the skeleton structure where the gestures rep data will
%be added. 
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

%%
username = userData.userInfo.username;
userData.isComplete = false; % true cuando los gestos ya se añadieron!

%% Save gestureData
filepath = ['.\data\' username '\'];
if ~isfolder(filepath)
    mkdir(filepath);
end

%% creating the file!
save([filepath 'userData.mat'], 'userData');
