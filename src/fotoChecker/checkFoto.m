function fotoWasFound = checkFoto(userName)
%checkFoto returns true when the given user has a photo in its
%correspondent folder.
%
% INPUTS
% * userName    -char with the name of the user to check
%
% OUTPUTS
% * fotoWasFound -bool true when foto was found in the correspoding folder
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

02 March 2021
Matlab 9.9.0.1592791 (R2020b) Update 5.
%}

%%
validFormatsOfPictures = {'tiff', 'tif', 'jpeg', 'jpg', 'png'};

for kFormat = validFormatsOfPictures
    files = ls(['.\data\' userName '\*.' kFormat{1}]);
    if isempty(files)
        continue;
    else
        fotoWasFound = true;
        return;
    end
end
% reaching this point means that no photo was found in any extension
fotoWasFound = false;
return;