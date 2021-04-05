function bloquearGUI(handles, flag)
% when flag false, everything disabled, when true, enabled.
% user panel
if nargin == 1
    flag = false;
end

if flag
    valFlag = 'on';
else
    valFlag = 'off';
end
handles.nameUserText.Enable = valFlag;
handles.emailText.Enable = valFlag;
handles.edadText.Enable = valFlag;
handles.ocupacionText.Enable = valFlag;
handles.etniaText.Enable = valFlag;
handles.hombreRadio.Enable = valFlag;
handles.mujerRadio.Enable = valFlag;
handles.diestroRadio.Enable = valFlag;
handles.zurdoRadio.Enable = valFlag;
handles.numRepText.Enable = valFlag;
handles.numRepRelaxText.Enable = valFlag;
handles.timeGestureText.Enable = valFlag;
handles.listOfMyos.Enable = valFlag;

% lesion check
handles.lesionCheck.Enable = valFlag;

% ubicacion Myo panel
handles.perimetroText.Enable = valFlag;
handles.cubCodoText.Enable = valFlag;
handles.codMyoText.Enable = valFlag;

% Desbloquear botones
handles.grabarButton.Enable = valFlag;
handles.repetirButton.Enable = valFlag;

% itself
handles.empezarEntrenamientoButton.Enable = valFlag;
handles.restaurarButton.Enable = valFlag;

% conexión Myo
handles.connectGForce_Button.Enable = valFlag;
handles.connectMyo_Button.Enable = valFlag;
end


