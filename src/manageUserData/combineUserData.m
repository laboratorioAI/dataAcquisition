function combineUserData(userData)
%combineUserData junta los archivos generados de un usuario: tanto el
%esqueleto como los de cada gesto. Además, elimina los archivos temporales.
% userData es solo una mega estructura con la información pero hueca (i.e.
% sin los datos de los gestos).

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
filepath = ['.\data\' username '\'];


%% gathering gestures
classes = userData.gestures.classes;

for kGesture = classes % loop by gesture, gathering!
    nameGesture = kGesture{1};
    if isfile([filepath nameGesture '.mat'])
        dataReps = load([filepath nameGesture '.mat'], 'reps');
        userData.gestures.(nameGesture) = dataReps.reps.(nameGesture);
    else
        error('Gesture file not found __%s__!\nDo the RESUME process', nameGesture)
    end
end


%% saving complete userData
userData.isComplete = true; % true cuando los gestos ya se añadieron!
save([filepath 'userData.mat'], 'userData');


% gesture temp files not deleting!
% %% deleting the gestures temp files
% for kGesture = classes % loop by gesture, deleting!
%     nameGesture = kGesture{1};
%     delete([filepath nameGesture '.mat'])
% end

