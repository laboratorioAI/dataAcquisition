%ejecutar is the run script to execute the data acquisition system.

%{
Laboratorio de Inteligencia y Visión Artificial
ESCUELA POLITÉCNICA NACIONAL
Quito - Ecuador

autor: ztjona!
jonathan.a.zea@ieee.org

"I find that I don't understand things unless I try to program them."
-Donald E. Knuth

05 April 2021
Matlab 9.9.0.1592791 (R2020b) Update 5.
%}

%% Clean environment
close all;
% myoObject global variable that handles myo armband
% deviceType enum class that tells the device used
clearvars -global -except myoObject deviceType gForceObject;

clc;

%% Timers and path
addpath(genpath(pwd));
global currentDirectory;


pathname = mfilename('fullpath');
n = length(pathname);
while pathname(n) ~= '\'
    n = n - 1;
end
currentDirectory = pathname(1:(n-1));
cleaningTimers();


%% Start data acquisition

%listaRecolectoresDatos();

app = listaRecolectoresDatos_App();
%app.figure1.Visible = 'on';

cleaningTimers();
