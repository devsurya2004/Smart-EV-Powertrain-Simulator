%%=========================================================================
% Motor Calculations
%=========================================================================

clear

[EV, scriptFolder, projectRoot] = Initialize_Project();

%%=========================================================================
% Load Vehicle Calculation Results
%=========================================================================

loadedData = load(fullfile(projectRoot,'Data','Vehicle_Calculations.mat'),'EV');

EV.Calculated = loadedData.EV.Calculated;

%%=========================================================================
% Wheel Circumference
%=========================================================================

EV.Calculated.WheelCircumference = ...
    2*pi*EV.Vehicle.WheelRadius;

%%=========================================================================
% Wheel Speed
%=========================================================================

EV.Calculated.WheelSpeedRPS = ...
    EV.Requirements.TopSpeed / ...
    EV.Calculated.WheelCircumference;

EV.Calculated.WheelSpeedRPM = ...
    EV.Calculated.WheelSpeedRPS * 60;

%%=========================================================================
% Gear Ratio
%=========================================================================

EV.Transmission.GearRatio = ...
    EV.Motor.MaximumSpeedRPM / ...
    EV.Calculated.WheelSpeedRPM;

%%=========================================================================
% Peak Motor Torque
%=========================================================================

EV.Calculated.WheelTorqueNm = ...
    EV.Calculated.TotalTractiveForce * ...
    EV.Vehicle.WheelRadius;

EV.Motor.PeakTorque = ...
    EV.Calculated.WheelTorqueNm / ...
    (EV.Transmission.GearRatio * EV.Transmission.Efficiency);

%%=========================================================================
% Rated Motor Torque
%=========================================================================

BaseSpeedRadPerSec = ...
    (2*pi*EV.Motor.BaseSpeedRPM)/60;

EV.Motor.RatedTorque = ...
    EV.Motor.RatedPower / BaseSpeedRadPerSec;

%%=========================================================================
% Display Results
%=========================================================================

fprintf('\n');
fprintf('=============== Motor Calculations ==================\n');

fprintf('Wheel Circumference : %.3f m\n', ...
    EV.Calculated.WheelCircumference);

fprintf('Wheel Speed         : %.2f RPM\n', ...
    EV.Calculated.WheelSpeedRPM);

fprintf('=====================================================\n');

fprintf('Maximum Motor Speed : %.0f RPM\n', ...
    EV.Motor.MaximumSpeedRPM);

fprintf('Gear Ratio          : %.2f : 1\n', ...
    EV.Transmission.GearRatio);

fprintf('Wheel Torque        : %.2f Nm\n', ...
    EV.Calculated.WheelTorqueNm);

fprintf('Peak Motor Torque   : %.2f Nm\n', ...
    EV.Motor.PeakTorque);

fprintf('\n');
fprintf('=========================================\n');
fprintf(' Rated Motor Parameters\n');
fprintf('=========================================\n');

fprintf('Base Speed          : %.0f RPM\n', ...
    EV.Motor.BaseSpeedRPM);

fprintf('Rated Power         : %.2f kW\n', ...
    EV.Motor.RatedPower/1000);

fprintf('Rated Torque        : %.2f Nm\n', ...
    EV.Motor.RatedTorque);

%%=========================================================================
% Save Results
%=========================================================================

save(fullfile(projectRoot,'Data','Motor_Calculations.mat'),'EV');