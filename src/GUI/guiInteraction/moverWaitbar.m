function moverWaitbar(handles, porcentaje, transicion)
% porcentaje: 0 a 1
% transicion: valor entre 0 y 1
barra = handles.waitbarAxes.Children(1);
esfera = handles.waitbarAxes.Children(2);


barra.XData = [0 porcentaje];
esfera.XData = porcentaje;

%% normal
if porcentaje < transicion
    barra.YData = [0 porcentaje];
    esfera.YData = 0.5;
    esfera.YData = porcentaje;
    barra.FaceColor = [102, 205, 170] / 255; % azul!
    barra.EdgeColor = [32, 178, 170] / 255;
    
else
    barra.YData = [1 1];
    barra.FaceColor = [255, 215, 0] / 255; % amarillo
    barra.EdgeColor = [250, 250, 210] / 255;
    esfera.YData = transicion;
end


%% progreso styles
% defaults, when 0, 0
tamText = 12;
colorLetter = [0 0 1];
handles.msjText.String = '';

if porcentaje < transicion / 3
    handles.msjText.String = '3';
    
elseif (porcentaje >= transicion / 3) && (porcentaje < transicion * 2 / 3)
    handles.msjText.String = '2';
    
elseif (porcentaje >= transicion * 2 / 3) && (porcentaje < transicion)
    handles.msjText.String = '1';
    
elseif porcentaje > transicion
    handles.msjText.String = 'GO!';
    colorLetter = [1 0 0];
    handles.msjText.FontWeight = 'normal';
    tamText = 18;
end
% if porcentaje*0.98 <= transicion && transicion <= 1.02*porcentaje
%     beep
% end
%
handles.msjText.ForegroundColor = colorLetter;
handles.msjText.FontSize = tamText;
drawnow
end




% if porcentaje < transicion/2
%     barra.YData = [0 porcentaje];
%     esfera.YData = 0.5;
%     esfera.YData = porcentaje;
%     handles.msjText.String = 'Espere';
%     handles.msjText.ForegroundColor = [0 0 1];
%     handles.msjText.FontSize = 10;
%     barra.FaceColor = [102, 205, 170] / 255; % azul!
%     barra.EdgeColor = [32, 178, 170] / 255;
%
% elseif porcentaje < transicion
%     barra.YData = [0 porcentaje];
%     esfera.YData = 0.5;
%     esfera.YData = porcentaje;
%     handles.msjText.String = '¡¡Prepárate!!';
%     handles.msjText.ForegroundColor = [0 0 1];
%     handles.msjText.FontSize = 14;
%     barra.FaceColor = [102, 205, 170] / 255; % azul!
%     barra.EdgeColor = [32, 178, 170] / 255;