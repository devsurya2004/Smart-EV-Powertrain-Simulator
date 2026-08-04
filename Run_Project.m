clc
clear
close all

projectRoot = fileparts(mfilename('fullpath'));
addpath(fullfile(projectRoot,'Scripts'));

tic

fprintf('\n');
fprintf('============================================================\n');
fprintf('          SMART EV POWERTRAIN SIMULATOR\n');
fprintf('                    Version 1.0\n');
fprintf('============================================================\n');
fprintf('\n');

fprintf('Loading simulation modules...\n');
fprintf('------------------------------------------------------------\n');

fprintf('Battery               ');
Battery;
fprintf('Done\n');

fprintf('Motor                 ');
Motor;
fprintf('Done\n');

fprintf('Transmission          ');
Transmission;
fprintf('Done\n');

fprintf('Inverter              ');
Inverter;
fprintf('Done\n');

fprintf('Vehicle               ');
Vehicle;
fprintf('Done\n');

fprintf('Vehicle Dynamics      ');
Vehicle_Dynamics;
fprintf('Done\n');

fprintf('Drive Cycle           ');
Drive_Cycle;
fprintf('Done\n');

fprintf('Regenerative Braking  ');
Regenerative_Braking;
fprintf('Done\n');

fprintf('Performance Summary   ');
Performance_Summary;
fprintf('Done\n');

fprintf('------------------------------------------------------------\n');

ElapsedTime = toc;

fprintf('\n');
fprintf('Simulation completed successfully.\n');
fprintf('Execution Time : %.2f seconds\n',ElapsedTime);

fprintf('============================================================\n');
