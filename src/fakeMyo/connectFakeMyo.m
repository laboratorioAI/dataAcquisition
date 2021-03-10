function isConnectedMyo = connectFakeMyo()
% Función para conectarse al Fake Myo.
global myoObject
myoObject = FakeMyoMex();
isConnectedMyo = myoObject.myoData.isStreaming;
end