function updateBattery(handles)
%updateBattery handles showing the battery in the GUI.
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

%%
global gForceObject 
bat = gForceObject.getBattery();
gForceObject.vibrate();
drawnow
msjBat = sprintf('%d %%',bat);
if bat >= 80
    handles.bat_txt.ForegroundColor = [0.39 0.83 0.07];
elseif bat > 60
    handles.bat_txt.ForegroundColor = [0.93 0.69 0.13];
elseif bat > 0
    handles.bat_txt.ForegroundColor = 'red';
elseif bat == 0
    handles.bat_txt.ForegroundColor = 'black';
    msjBat = '-';
else
    handles.bat_txt.ForegroundColor = 'black';
    msjBat = '?';
end

handles.bat_txt.String = msjBat;