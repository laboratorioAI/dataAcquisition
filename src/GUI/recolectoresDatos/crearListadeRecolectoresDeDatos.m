function [encabezado, listaDeRecolectoresDeDatos, numUsers] =...
    crearListadeRecolectoresDeDatos()
encabezado = 'SELECT YOUR NAME:';

txt = readcell(configs("collectorsFilename"));
numUsers = size(txt,1) - 1;
for userNum = 1:numUsers
    listaDeRecolectoresDeDatos(userNum).name = txt{userNum + 1,1};
    listaDeRecolectoresDeDatos(userNum).email = txt{userNum + 1,2};
    listaDeRecolectoresDeDatos(userNum).cellphone = txt{userNum + 1,3};
    listaDeRecolectoresDeDatos(userNum).university = txt{userNum + 1,4};
end
return