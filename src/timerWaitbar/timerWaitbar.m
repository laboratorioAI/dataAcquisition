function myTimer = timerWaitbar(handles, transicion, userData)
timeGesture = userData.extraInfo.timePerRepetition;

myTimer = timer('Name', 'waitbarTimer');
myTimer.ExecutionMode = 'fixedRate'; %fixedSpacing
% myTimer.ExecutionMode = 'fixedRate';
myTimer.Period = 0.1;

%
numExecutions = floor(timeGesture / 0.1); % depende del tiempo del gesto 
myTimer.TasksToExecute = numExecutions;


myTimer.TimerFcn = @(timer, evnt)moverWaitbar(handles,timer.TasksExecuted/numExecutions,transicion/timeGesture);

end