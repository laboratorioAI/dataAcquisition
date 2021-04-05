function timerStartCollection(~, ~)
global myoObject gForceObject deviceType;
if deviceType == DeviceName.myo
    myoObject.myoData.stopStreaming();
    myoObject.myoData.clearLogs();
    myoObject.myoData.startStreaming();
    
elseif deviceType == DeviceName.gForce    
    gForceObject.clear();
end
end

