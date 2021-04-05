function [isValid, msjPrint] = validacionDatos(handles)
isValid = false;
msjPrint = '';

% nameUser
nameUser = handles.nameUserText.String;
if isempty(nameUser)
    msjPrint = 'Ingrese correctamente el nombre!';
    return
end

% edad
edad = str2double(handles.edadText.String);
if ~isnumeric(edad) || isnan(edad)
    msjPrint = 'Ingrese correctamente la edad!';
    return
else
    if edad < 18
        msjPrint = 'No se admiten menores de 18 años!';
        return
    end
end

% grupo Etnico
etnia = handles.etniaText.String;
if isempty(etnia)
    msjPrint = 'Ingrese correctamente la etnia!';
    return
end

% ocupacion
ocupacion = handles.ocupacionText.String;
if isempty(ocupacion)
    msjPrint = 'Ingrese correctamente la ocupacion!';
    return
end

% numero repeticiones por gesto
numRep = str2double(handles.numRepText.String);
if ~isnumeric(numRep) || isnan(numRep)
    msjPrint = 'Ingrese correctamente el numero de repeticiones por gesto!';
    return
end

% tiempo de recoleccion
tiempo = str2double(handles.timeGestureText.String);
if ~isnumeric(tiempo) || isnan(tiempo)
    msjPrint = 'Ingrese correctamente el tiempo de grabacion por repeticion!';
    return
else
    if tiempo <= 0
        msjPrint = 'El tiempo de grabacion debe ser > a 0 segundos';
        return
    end
end
        
% numero repeticiones del gesto relajacion
numRepRelax = str2double(handles.numRepRelaxText.String);
if ~isnumeric(numRepRelax) || isnan(numRepRelax)
    msjPrint = 'Ingrese correctamente el numero de repeticiones para el gesto de relajacion!';
    return
end

% brazo
perimetro = str2double(handles.perimetroText.String);
if ~isnumeric(perimetro) || isnan(perimetro)
    msjPrint = 'Ingrese correctamente el perimetro del brazo de usuario!';
    return
end

% cubo codo
cubCodo = str2double(handles.cubCodoText.String);
if ~isnumeric(cubCodo) || isnan(cubCodo)
    msjPrint = 'Ingrese correctamente distancia cubito-codo!';
    return
end

% myo codo
codMyo = str2double(handles.codMyoText.String);
if ~isnumeric(codMyo) || isnan(codMyo)
    msjPrint = 'Ingrese correctamente distancia codo-Myo!';
    return
end

isValid = true;
end