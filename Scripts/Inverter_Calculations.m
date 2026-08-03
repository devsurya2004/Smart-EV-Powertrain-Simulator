clc

close all

clear

[EV, scriptFolder, projectRoot] = Initialize_Project();
%%=========================================================================
% Load Battery Calculation Results
%==========================================================================

loadedData = load( ...
    fullfile(projectRoot,'Data','Battery_Calculations.mat'), ...
    'EV');

EV.Battery.Calculated = loadedData.EV.Battery.Calculated;

%%=========================================================================
% DC Side Calculations
% Calculates the inverter DC input parameters.
%==========================================================================

EV.Inverter.Calculated.DC.VoltageV = ...
    EV.Battery.Calculated.Voltage.Nominal;

EV.Inverter.Calculated.DC.CurrentA = ...
    EV.Battery.Calculated.Current.Continuous;

EV.Inverter.Calculated.DC.PowerkW = ...
    (EV.Inverter.Calculated.DC.VoltageV * ...
    EV.Inverter.Calculated.DC.CurrentA) / ...
    1000;

%%=========================================================================
% AC Voltage Calculations
% Calculates the inverter AC output voltages.
%==========================================================================

EV.Inverter.Calculated.AC.LineVoltageV = ...
    EV.Inverter.ModulationIndex * ...
    EV.Inverter.Calculated.DC.VoltageV / ...
    sqrt(2);

EV.Inverter.Calculated.AC.PhaseVoltageV = ...
    EV.Inverter.Calculated.AC.LineVoltageV / ...
    sqrt(3);

%%=========================================================================
% AC Power Calculations
% Calculates inverter output power and power losses.
%==========================================================================

EV.Inverter.Calculated.Power.InputkW = ...
    EV.Inverter.Calculated.DC.PowerkW;

EV.Inverter.Calculated.Power.OutputkW = ...
    EV.Inverter.Calculated.Power.InputkW * ...
    EV.Inverter.Efficiency;

EV.Inverter.Calculated.Power.LosseskW = ...
    EV.Inverter.Calculated.Power.InputkW - ...
    EV.Inverter.Calculated.Power.OutputkW;

%%=========================================================================
% AC Current Calculations
% Calculates the inverter output phase current.
%==========================================================================

EV.Inverter.Calculated.AC.PhaseCurrentA = ...
    (EV.Inverter.Calculated.Power.OutputkW * 1000) / ...
    (sqrt(3) * EV.Inverter.Calculated.AC.LineVoltageV);
%%=========================================================================
% Inverter Validation
% Validates inverter power calculations.
%==========================================================================

PowerError = abs( ...
    EV.Inverter.Calculated.Power.OutputkW - ...
    EV.Inverter.Calculated.Power.InputkW * ...
    EV.Inverter.Efficiency);

PowerErrorPercent = ...
    (PowerError / EV.Inverter.Calculated.Power.InputkW) * 100;

ValidationStatus = "PASS";

if PowerErrorPercent > 0.1
    ValidationStatus = "FAIL";
end
%%=========================================================================
% Display Results
% Displays inverter calculation summary.
%==========================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              SMART EV POWERTRAIN SIMULATOR\n');
fprintf('                 INVERTER DESIGN REPORT\n');
fprintf('============================================================\n');
fprintf('\nInverter Information\n');
fprintf('------------------------------------------------------------\n');

fprintf('Inverter Type        : %s\n', ...
    EV.Inverter.Type);

fprintf('Topology             : %s\n', ...
    EV.Inverter.Topology);

fprintf('Switching Frequency  : %.0f Hz\n', ...
    EV.Inverter.SwitchingFrequency);

fprintf('Efficiency           : %.2f %%\n', ...
    EV.Inverter.Efficiency * 100);

fprintf('Modulation Index     : %.2f\n', ...
    EV.Inverter.ModulationIndex);
fprintf('\nDC Side\n');
fprintf('------------------------------------------------------------\n');

fprintf('DC Voltage           : %.2f V\n', ...
    EV.Inverter.Calculated.DC.VoltageV);

fprintf('DC Current           : %.2f A\n', ...
    EV.Inverter.Calculated.DC.CurrentA);

fprintf('DC Power             : %.2f kW\n', ...
    EV.Inverter.Calculated.DC.PowerkW);
fprintf('\nAC Side\n');
fprintf('------------------------------------------------------------\n');

fprintf('Line Voltage         : %.2f V\n', ...
    EV.Inverter.Calculated.AC.LineVoltageV);

fprintf('Phase Voltage        : %.2f V\n', ...
    EV.Inverter.Calculated.AC.PhaseVoltageV);

fprintf('Phase Current        : %.2f A\n', ...
    EV.Inverter.Calculated.AC.PhaseCurrentA);
fprintf('\nPower Flow\n');
fprintf('------------------------------------------------------------\n');

fprintf('Input Power          : %.2f kW\n', ...
    EV.Inverter.Calculated.Power.InputkW);

fprintf('Output Power         : %.2f kW\n', ...
    EV.Inverter.Calculated.Power.OutputkW);

fprintf('Power Loss           : %.2f kW\n', ...
    EV.Inverter.Calculated.Power.LosseskW);
fprintf('\nValidation\n');
fprintf('------------------------------------------------------------\n');

fprintf('Power Error          : %.4f %%\n', ...
    PowerErrorPercent);

fprintf('Overall Status       : %s\n', ...
    ValidationStatus);

fprintf('\n============================================================\n');
%%=========================================================================
% Save Results
% Saves inverter calculation results.
%==========================================================================

save( ...
    fullfile(projectRoot,'Data','Inverter_Calculations.mat'), ...
    'EV');

fprintf('\nInverter calculations saved successfully.\n');
fprintf('Location : %s\n', ...
    fullfile(projectRoot,'Data','Inverter_Calculations.mat'));
