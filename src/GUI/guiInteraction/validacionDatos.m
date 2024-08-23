function [isValid, msjPrint] = validacionDatos(handles)
isValid = false;
msjPrint = '';

% nameUser
nameUser = handles.nameUserText.String;
if isempty(nameUser)
    msjPrint = 'Wrong name!';
    return
end

% edad
edad = str2double(handles.edadText.String);
if ~isnumeric(edad) || isnan(edad) || edad <= 5
    msjPrint = 'Wrong age!';
    return
else
    % why?
%     if edad < 18
%         msjPrint = 'No se admiten menores de 18 años!';
%         return
%     end
end

% grupo Etnico
%etnia = handles.etniaText.String;
%if isempty(etnia)
%    msjPrint = 'Wrong ethnic group!';
%    return
%end

% ocupacion
ocupacion = handles.ocupacionText.String;
if isempty(ocupacion)
    msjPrint = 'Wrong occupation!';
    return
end

% numero repeticiones por gesto
numRep = str2double(handles.numRepText.String);
if ~isnumeric(numRep) || isnan(numRep) || numRep <= 0
    msjPrint = 'wrong number of samples!';
    return
end

% tiempo de recoleccion
tiempo = str2double(handles.timeGestureText.String);
if ~isnumeric(tiempo) || isnan(tiempo)
    msjPrint = 'wrong recording time!';
    return
else
    if tiempo <= 0
        msjPrint = 'Time must be greater than 0';
        return
    end
end
        
% numero repeticiones del gesto relajacion
numRepRelax = str2double(handles.numRepRelaxText.String);
if ~isnumeric(numRepRelax) || isnan(numRepRelax)
    msjPrint = 'wrong number of relax samples!';
    return
end

% brazo
perimetro = str2double(handles.perimetroText.String);
if ~isnumeric(perimetro) || isnan(perimetro) || perimetro <= 0
    msjPrint = 'wrong arm circumference!';
    return
end

% cubo codo
cubCodo = str2double(handles.cubCodoText.String);
if ~isnumeric(cubCodo) || isnan(cubCodo)|| cubCodo <= 0
    msjPrint = 'wrong length';
    return
end

% myo codo
codMyo = str2double(handles.codMyoText.String);
if ~isnumeric(codMyo) || isnan(codMyo)|| codMyo <= 0
    msjPrint = 'wrong length!';
    return
end

isValid = true;
end