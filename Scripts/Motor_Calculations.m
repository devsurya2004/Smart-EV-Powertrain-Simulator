%%=========================================================================
% Motor Calculations
%==========================================================================

clear
clc

scriptFolder = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptFolder);

run(fullfile(scriptFolder,'Project_Parameters.m'));
%%=========================================================================
% Load Vehicle Calculation Results
%==========================================================================

load(fullfile(projectRoot,'Data','Vehicle_Calculations.mat'),'EV');

%%=========================================================================
% Wheel Circumference
%==========================================================================

EV.Calculated.WheelCircumference = ...
    2 * pi * EV.Vehicle.WheelRadius;

%%=========================================================================
% Wheel Speed
%==========================================================================

EV.Calculated.WheelRPS = ...
    EV.Requirements.TopSpeed / ...
    EV.Calculated.WheelCircumference;

EV.Calculated.WheelRPM = ...
    EV.Calculated.WheelRPS * 60;
%%=========================================================================
% Gear Ratio
%==========================================================================

EV.Motor.MaximumSpeedRPM = 12000;

EV.Transmission.GearRatio = ...
    EV.Motor.MaximumSpeedRPM / ...
    EV.Calculated.WheelRPM;
%%=========================================================================
% Motor Torque
%==========================================================================

EV.Calculated.WheelTorque = ...
    EV.Calculated.TotalTractiveForce * ...
    EV.Vehicle.WheelRadius;

EV.Motor.PeakTorque = ...
    EV.Calculated.WheelTorque / ...
    (EV.Transmission.GearRatio * EV.Transmission.Efficiency);

%%=========================================================================
% Display Results
%==========================================================================

fprintf('\n');
fprintf('=============== Motor Calculations ==================\n');

fprintf('Wheel Circumference : %.3f m\n', ...
    EV.Calculated.WheelCircumference);

fprintf('Wheel Speed         : %.2f RPM\n', ...
    EV.Calculated.WheelRPM);

fprintf('=====================================================\n');
fprintf('Maximum Motor Speed : %.0f RPM\n', ...
    EV.Motor.MaximumSpeedRPM);

fprintf('Gear Ratio          : %.2f : 1\n', ...
    EV.Transmission.GearRatio);
fprintf('Wheel Torque        : %.2f Nm\n', ...
    EV.Calculated.WheelTorque);

fprintf('Peak Motor Torque   : %.2f Nm\n', ...
    EV.Motor.PeakTorque);

%%=========================================================================
% Save Results
%==========================================================================

save(fullfile(projectRoot,'Data','Motor_Calculations.mat'),'EV');