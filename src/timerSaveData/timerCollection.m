function myTimer = timerCollection(userData)
%% Single shot timer
myTimer = timer('Name', 'recolectionTimer');
myTimer.StartFcn = @timerStartCollection;
myTimer.TimerFcn = @timerFuncCollection;
myTimer.StopFcn = @timerStartCollection;
myTimer.StartDelay = userData.extraInfo.timePerRepetition;
end