function gifControl(flag)
%gifControl pauses or resumes the gif.
%
% Inputs
% *flag         -bool when true resumes
%
% Ejemplo
%    = gifControl()
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

09 February 2021
Matlab 9.9.0.1538559 (R2020b) Update 3.
%}

%%
nameTimer = 'gifTimer';
%% stoping previously if any, timer!
t1 = timerfind('Name', nameTimer);

if isempty(t1)
    return;
end
if flag
    if isequal(t1.Running, 'off')
        start(t1)
    end
else
    stop(t1)
end