classdef FakeMyoData < handle
    properties
        emg_log
        pose_log
        rot_log
        quat_log
        gyro_log
        accel_log
        isStreaming
    end

    properties(Access=private)
        timerEmg
        timerPose
        timerRot
    end

    methods
        function myoData = FakeMyoData()
            %% Inital data for logs
            myoData.emg_log = rand(400,8);
            myoData.pose_log = rand(20,1);
            myoData.rot_log = rand(400,9);
            myoData.quat_log = rand(400,4);
            myoData.accel_log = rand(400,3);
            myoData.gyro_log = rand(400,3);
            
            %% Initialize timmers
            %% EMG timer
            myoData.timerEmg = timer;
            myoData.timerEmg.TimerFcn = @(t,v) myoData.updateEMG();
            myoData.timerEmg.ExecutionMode = 'fixedRate';
            myoData.timerEmg.Period = 0.2;
            %% Pose timer
            myoData.timerPose = timer;
            myoData.timerPose.TimerFcn = @(t,v) myoData.updatePose();
            myoData.timerPose.ExecutionMode = 'fixedRate';
            myoData.timerPose.Period = 0.5;
            %% Rot timer
            myoData.timerRot = timer;
            myoData.timerRot.TimerFcn = @(t,v) myoData.updateRot();
            myoData.timerRot.ExecutionMode = 'fixedRate';
            myoData.timerRot.Period = 0.2;
            %% Start streaming
            myoData.startStreaming();
        end

        function updateEMG(myoData)
            myoData.emg_log = [ myoData.emg_log; rand(50, 8) ];
        end

        function updatePose(myoData)
            myoData.pose_log = [ myoData.pose_log; ceil(rand(1,1)*6) ];
        end
        
        function updateRot(myoData)% updating all, instead
            myoData.rot_log = [ myoData.rot_log; rand(50, 9) ];
            myoData.accel_log = [ myoData.accel_log; rand(50, 3) ];
            myoData.quat_log = [ myoData.quat_log; rand(50, 4) ];
            myoData.gyro_log = [ myoData.gyro_log; rand(50, 3) ];
        end

        function startStreaming(myoData)
            myoData.isStreaming = true;
            start(myoData.timerEmg);
            start(myoData.timerPose);
            start(myoData.timerRot);
        end

        function stopStreaming(myoData)
            myoData.isStreaming = false;
            stop(myoData.timerEmg);
            stop(myoData.timerPose);
            stop(myoData.timerRot);
        end

        function clearLogs(myoData)
            myoData.emg_log = [];
            myoData.pose_log = [];
            myoData.rot_log = [];
            myoData.quat_log = [];
            myoData.gyro_log = [];
            myoData.accel_log = [];
            
        end
    end
end