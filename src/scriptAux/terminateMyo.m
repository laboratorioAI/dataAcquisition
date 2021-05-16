function isConnected = terminateMyo()
% Function to stop myo for streaming data, is required to delete object
% twice just to be sure.
global myoObject
isConnected=0;

try
    stop(timerfindall)
    delete(timerfindall)
catch
end

try
    % Stopping myoObject
    myoObject.myoData.stopStreaming();
    myoObject.delete;
    clear myoObject
    
    fprintf('Connection with myo finished!\n');
    isConnected=0;
catch
    try
        myoObject.myoData.stopStreaming();
        myoObject.delete;
        clear myoObject
    catch
    end
end

