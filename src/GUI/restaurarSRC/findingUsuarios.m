function vectorUser = findingUsuarios()
%findingUsuarios returns a list of the folders inside /data/, excludes
%files.
%
% Outputs
%   vectorUser  -cell with chars
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

06 April 2021
Matlab 9.9.0.1592791 (R2020b) Update 5.
%}

%%
usuariosList = dir('.\data');
%%
usuariosNum = size(usuariosList,1);

%%
vectorUser = cell(usuariosNum - 2, 1);
numFolders = 0;
for kUser = 3:usuariosNum
    if usuariosList(kUser).isdir % filtering non folders
        numFolders = numFolders + 1;
        vectorUser{numFolders} = usuariosList(kUser).name;
    end
end
if numFolders > 0
    vectorUser = vectorUser(1:numFolders);
else
    vectorUser = {};
end
end
