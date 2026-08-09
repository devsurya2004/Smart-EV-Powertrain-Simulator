[EV, scriptFolder, projectRoot] = Initialize_Project();

%%=========================================================================
% Output Speed Calculations
% Calculates the transmission output speed.
%==========================================================================

EV.Transmission.Calculated.Output.SpeedRPM = ...
    EV.Motor.MaximumSpeedRPM / ...
    EV.Transmission.GearRatio;

%%=========================================================================
% Output Torque Calculations
% Calculates the transmission output torque.
%==========================================================================

EV.Transmission.Calculated.Output.TorqueNm = ...
    EV.Motor.PeakTorque * ...
    EV.Transmission.GearRatio * ...
    EV.Transmission.Efficiency;

%%=========================================================================
% Transmission Ratio Calculations
% Calculates the transmission speed reduction and torque multiplication.
%==========================================================================

EV.Transmission.Calculated.Ratio.SpeedReduction = ...
    EV.Transmission.GearRatio;

EV.Transmission.Calculated.Ratio.TorqueMultiplication = ...
    EV.Transmission.GearRatio * ...
    EV.Transmission.Efficiency;

%%=========================================================================
% Power Calculations
% Calculates the transmission input power, output power and power losses.
%==========================================================================

InputAngularSpeed = ...
    EV.Motor.MaximumSpeedRPM * ...
    (2 * pi / 60);

OutputAngularSpeed = ...
    EV.Transmission.Calculated.Output.SpeedRPM * ...
    (2 * pi / 60);

EV.Transmission.Calculated.Power.InputkW = ...
    EV.Motor.PeakTorque * ...
    InputAngularSpeed / ...
    1000;

EV.Transmission.Calculated.Power.OutputkW = ...
    EV.Transmission.Calculated.Output.TorqueNm * ...
    OutputAngularSpeed / ...
    1000;

EV.Transmission.Calculated.Power.LosseskW = ...
    EV.Transmission.Calculated.Power.InputkW - ...
    EV.Transmission.Calculated.Power.OutputkW;
%%=========================================================================
% Transmission Validation
% Validates the transmission calculations.
%==========================================================================

PowerError = abs( ...
    EV.Transmission.Calculated.Power.OutputkW - ...
    EV.Transmission.Calculated.Power.InputkW * ...
    EV.Transmission.Efficiency);

PowerErrorPercent = ...
    (PowerError / EV.Transmission.Calculated.Power.InputkW) * 100;

ValidationStatus = "PASS";

if PowerErrorPercent > 0.1
    ValidationStatus = "FAIL";
end
%%=========================================================================
% Display Results
% Displays transmission calculation summary.
%==========================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              SMART EV POWERTRAIN SIMULATOR\n');
fprintf('              TRANSMISSION DESIGN REPORT\n');
fprintf('============================================================\n');
fprintf('\nTransmission Information\n');
fprintf('------------------------------------------------------------\n');

fprintf('Transmission Type     : %s\n', ...
    EV.Transmission.Type);

fprintf('Gear Ratio            : %.2f\n', ...
    EV.Transmission.GearRatio);

fprintf('Efficiency            : %.2f %%\n', ...
    EV.Transmission.Efficiency * 100);
fprintf('\nOutput Performance\n');
fprintf('------------------------------------------------------------\n');

fprintf('Output Speed          : %.2f RPM\n', ...
    EV.Transmission.Calculated.Output.SpeedRPM);

fprintf('Output Torque         : %.2f Nm\n', ...
    EV.Transmission.Calculated.Output.TorqueNm);
fprintf('\nTransmission Ratio\n');
fprintf('------------------------------------------------------------\n');

fprintf('Speed Reduction       : %.2f : 1\n', ...
    EV.Transmission.Calculated.Ratio.SpeedReduction);

fprintf('Torque Multiplication : %.4f\n', ...
    EV.Transmission.Calculated.Ratio.TorqueMultiplication);
fprintf('\nPower Flow\n');
fprintf('------------------------------------------------------------\n');

fprintf('Input Power           : %.2f kW\n', ...
    EV.Transmission.Calculated.Power.InputkW);

fprintf('Output Power          : %.2f kW\n', ...
    EV.Transmission.Calculated.Power.OutputkW);

fprintf('Power Loss            : %.2f kW\n', ...
    EV.Transmission.Calculated.Power.LosseskW);
fprintf('\nValidation\n');
fprintf('------------------------------------------------------------\n');

fprintf('Power Error           : %.4f %%\n', ...
    PowerErrorPercent);

fprintf('Overall Status        : %s\n', ...
    ValidationStatus);

fprintf('\n============================================================\n');
%%=========================================================================
% Save Results
% Saves the transmission calculation results.
%==========================================================================

save( ...
    fullfile(projectRoot,'Data','Transmission_Calculations.mat'), ...
    'EV');

fprintf('\nTransmission calculations saved successfully.\n');
fprintf('Location : %s\n', ...
    fullfile(projectRoot,'Data','Transmission_Calculations.mat'));