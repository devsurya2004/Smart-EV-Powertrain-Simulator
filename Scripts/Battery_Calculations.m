%%=========================================================================
% Battery Calculations
%
% Project : Smart EV Powertrain Simulator
% Author  : Suryadev
%
% Description:
% Designs the battery pack based on the selected battery cell
% specifications and the target vehicle requirements.
%
%==========================================================================

clear

%%=========================================================================
% Initialize Project
% Initializes project paths and loads all project parameters.
%==========================================================================

[EV, scriptFolder, projectRoot] = Initialize_Project();

%%=========================================================================
% Cell Configuration
% Calculates the required series and parallel cell arrangement.
%==========================================================================

% Number of Series Cells
EV.Battery.Calculated.Cells.Series = ceil( ...
    EV.Battery.TargetPackVoltage / ...
    EV.Battery.Cell.NominalVoltage);

% Energy of One Series String
EnergyPerSeriesStringWh = ...
    EV.Battery.Calculated.Cells.Series * ...
    EV.Battery.Cell.EnergyWh;

% Number of Parallel Cells
EV.Battery.Calculated.Cells.Parallel = ceil( ...
    EV.Battery.TargetPackEnergyWh / ...
    EnergyPerSeriesStringWh);

% Total Number of Cells
EV.Battery.Calculated.Cells.Total = ...
    EV.Battery.Calculated.Cells.Series * ...
    EV.Battery.Calculated.Cells.Parallel;

%%=========================================================================
% Voltage Calculations
% Calculates nominal, maximum and minimum battery pack voltages.
%==========================================================================

EV.Battery.Calculated.Voltage.Nominal = ...
    EV.Battery.Calculated.Cells.Series * ...
    EV.Battery.Cell.NominalVoltage;

EV.Battery.Calculated.Voltage.Maximum = ...
    EV.Battery.Calculated.Cells.Series * ...
    EV.Battery.Cell.MaximumVoltage;

EV.Battery.Calculated.Voltage.Minimum = ...
    EV.Battery.Calculated.Cells.Series * ...
    EV.Battery.Cell.MinimumVoltage;

%%=========================================================================
% Capacity Calculations
% Calculates battery pack capacity and energy.
%==========================================================================

EV.Battery.Calculated.Capacity.Ah = ...
    EV.Battery.Calculated.Cells.Parallel * ...
    EV.Battery.Cell.CapacityAh;

EV.Battery.Calculated.Energy.Wh = ...
    EV.Battery.Calculated.Voltage.Nominal * ...
    EV.Battery.Calculated.Capacity.Ah;

EV.Battery.Calculated.Energy.kWh = ...
    EV.Battery.Calculated.Energy.Wh / 1000;
%%=========================================================================
% Current Calculations
% Calculates continuous and peak battery pack current.
%==========================================================================

EV.Battery.Calculated.Current.Continuous = ...
    EV.Battery.Calculated.Cells.Parallel * ...
    EV.Battery.Cell.ContinuousCurrent;

EV.Battery.Calculated.Current.Peak = ...
    EV.Battery.Calculated.Cells.Parallel * ...
    EV.Battery.Cell.PeakCurrent;
%%=========================================================================
% Mass Calculations
% Calculates the total battery pack mass.
%==========================================================================

EV.Battery.Calculated.Mass.Total = ...
    EV.Battery.Calculated.Cells.Total * ...
    EV.Battery.Cell.Mass;
%%=========================================================================
% Battery Pack Validation
% Validates the designed battery pack against project requirements.
%==========================================================================

VoltageError = abs( ...
    EV.Battery.Calculated.Voltage.Nominal - ...
    EV.Battery.TargetPackVoltage);

VoltageErrorPercent = ...
    (VoltageError / EV.Battery.TargetPackVoltage) * 100;

EnergyError = abs( ...
    EV.Battery.Calculated.Energy.kWh - ...
    EV.Battery.TargetPackEnergykWh);

EnergyErrorPercent = ...
    (EnergyError / EV.Battery.TargetPackEnergykWh) * 100;

%%=========================================================================
% Display Results
% Displays battery pack design summary.
%==========================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              SMART EV POWERTRAIN SIMULATOR\n');
fprintf('               BATTERY PACK DESIGN REPORT\n');
fprintf('============================================================\n');

%%-----------------------------------------------------------------------
% Battery Information
%------------------------------------------------------------------------

fprintf('\nBattery Information\n');
fprintf('------------------------------------------------------------\n');

fprintf('Battery Chemistry     : %s\n', ...
    EV.Battery.Cell.Chemistry);

fprintf('Cell Form Factor      : %s\n', ...
    EV.Battery.Cell.FormFactor);

%%-----------------------------------------------------------------------
% Cell Configuration
%------------------------------------------------------------------------

fprintf('\nCell Configuration\n');
fprintf('------------------------------------------------------------\n');

fprintf('Series Cells          : %d\n', ...
    EV.Battery.Calculated.Cells.Series);

fprintf('Parallel Cells        : %d\n', ...
    EV.Battery.Calculated.Cells.Parallel);

fprintf('Total Cells           : %d\n', ...
    EV.Battery.Calculated.Cells.Total);

%%-----------------------------------------------------------------------
% Voltage
%------------------------------------------------------------------------

fprintf('\nVoltage\n');
fprintf('------------------------------------------------------------\n');

fprintf('Nominal Voltage       : %.2f V\n', ...
    EV.Battery.Calculated.Voltage.Nominal);

fprintf('Maximum Voltage       : %.2f V\n', ...
    EV.Battery.Calculated.Voltage.Maximum);

fprintf('Minimum Voltage       : %.2f V\n', ...
    EV.Battery.Calculated.Voltage.Minimum);

%%-----------------------------------------------------------------------
% Capacity & Energy
%------------------------------------------------------------------------

fprintf('\nCapacity & Energy\n');
fprintf('------------------------------------------------------------\n');

fprintf('Pack Capacity         : %.2f Ah\n', ...
    EV.Battery.Calculated.Capacity.Ah);

fprintf('Pack Energy           : %.2f kWh\n', ...
    EV.Battery.Calculated.Energy.kWh);

%%-----------------------------------------------------------------------
% Current Capability
%------------------------------------------------------------------------

fprintf('\nCurrent Capability\n');
fprintf('------------------------------------------------------------\n');

fprintf('Continuous Current    : %.2f A\n', ...
    EV.Battery.Calculated.Current.Continuous);

fprintf('Peak Current          : %.2f A\n', ...
    EV.Battery.Calculated.Current.Peak);

%%-----------------------------------------------------------------------
% Battery Mass
%------------------------------------------------------------------------

fprintf('\nBattery Mass\n');
fprintf('------------------------------------------------------------\n');

fprintf('Total Battery Mass    : %.2f kg\n', ...
    EV.Battery.Calculated.Mass.Total);

%%-----------------------------------------------------------------------
% Validation
%------------------------------------------------------------------------

fprintf('\nValidation\n');
fprintf('------------------------------------------------------------\n');

fprintf('Voltage Error         : %.2f %%\n', ...
    VoltageErrorPercent);

fprintf('Energy Error          : %.2f %%\n', ...
    EnergyErrorPercent);

ValidationStatus = "[PASS]";

if VoltageErrorPercent > 2 || EnergyErrorPercent > 5
    ValidationStatus = "FAIL";
end
fprintf('Overall Status        : %s\n', ValidationStatus);

fprintf('\n============================================================\n');

%%=========================================================================
% Save Results
% Saves the battery calculation results for future modules.
%==========================================================================

save( ...
    fullfile(projectRoot,'Data','Battery_Calculations.mat'), ...
    'EV');

fprintf('\nBattery calculations saved successfully.\n');
fprintf('Location : %s\n', ...
    fullfile(projectRoot,'Data','Battery_Calculations.mat'));