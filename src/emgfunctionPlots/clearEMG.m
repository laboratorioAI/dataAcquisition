function clearEMG(handles)

%% loop on axes
cmd = '';
for cidx = 1:8
    cmd = sprintf('%s; cla(handles.emg%dAxes);',cmd, cidx); 
end
eval(cmd);
cla(handles.rotAxes)
end