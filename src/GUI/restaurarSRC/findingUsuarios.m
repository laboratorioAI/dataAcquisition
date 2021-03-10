function vectorUser = findingUsuarios()
usuariosList = dir('.\data');
%%
usuariosNum = size(usuariosList,1);

%%
vectorUser = cell(usuariosNum - 2,1);
for kUser = 3:usuariosNum
  vectorUser{kUser - 2} = usuariosList(kUser).name;
end

end
