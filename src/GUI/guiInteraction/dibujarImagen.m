function dibujarImagen(handles,nameGesture)
% funcion para leer imagen y plotearla

% global reconocimientoConfiguracion
set(handles.tituloGestoText,'String',nameGesture) % nombre del gesto

% set(handles.tituloGestoText,'String',reconocimientoConfiguracion.nameGestures{kGesto}) % nombre del gesto

imageGesture = imread(['images\' nameGesture '.png']); % leyendo imagen
imshow(imageGesture,'Parent',handles.gestoAxes);
