%%=========================================================================
% Motor Calculations
%==========================================================================

clear
clc

scriptFolder = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptFolder);

run(fullfile(scriptFolder,'Project_Parameters.m'));

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

%%=========================================================================
% Save Results
%==========================================================================

save(fullfile(projectRoot,'Data','Motor_Calculations.mat'),'EV');