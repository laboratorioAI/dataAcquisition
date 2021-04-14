function waitingFoto(userName)
%waitingFoto keeps showing a warning msg until a photo is detected in the
%given folder. It returns only when a foto was checked.
%
% INPUTS
% * userName    -char with the name of the user to check
%
% Outputs
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

02 March 2021
Matlab 9.9.0.1592791 (R2020b) Update 5.
%}

%%
i = 0;
while ~checkFoto(userName)
    % loop waiting until finding a photo in the correspoinding user folder
    i = i + 1;
    
    if i == 1
        % in the first execution shows an indication message
        uiwait(msgbox('Do not forget to take the photo of the foream!','Photo','help','modal'));
    else
        %
        uiwait(warndlg(['Make sure that the photo was taken and moved to ".\data\' userName '\"'], '¡Photo not found!', 'modal'));
    end
end